import path from "node:path";
import File from "../file-types/file";
import FileFolder, { getFolderByName } from "../file-types/file-folder";
import { arrayShuffle, arrayShuffleWeighted } from "../helpers/array-helpers";
import { fsIsFolder } from "../helpers/fs-helpers";
import buildFile from "../lib/buildFile";

export const command = ["select [source]"];

export const describe = "Select some files for kiosk mode";

export const builder = {
  amount: {
    describe: "Number of files",
    type: "number",
    default: 20
  },
  to: {
    describe: "Destination",
    type: "string",
    default: "."
  }
};

const CONFIG_NAME = "kiosk.json";
interface Config {
  priority: number;
}

function takeFiles(inside: FileFolder, n: number): File[] {
  inside.buildAllFiles();
  const list = Array.from(inside.listOfFiles.current.values()).filter(
    (f) => !f.i_f_is_folder.current
  );
  return arrayShuffle(list).slice(0, n);
}

function getRandomizedFolders(inside: FileFolder): (FileFolder | null)[] {
  inside.buildAllFiles();

  const subFolders = Array.from(inside.listOfFiles.current.keys())
    .map((filename) => path.join(inside.currentFilepath, filename))
    .filter((folderpath) => fsIsFolder(folderpath))
    .map((folderpath) => buildFile(folderpath) as FileFolder);

  const wf = new Map<FileFolder | null, number>(
    subFolders.map((f) => [f, f.loadConfig<Config>(CONFIG_NAME)?.priority || 1])
  );

  wf.set(null, 1);
  const list = arrayShuffleWeighted<FileFolder | null>(wf);
  return [...list];
}

function takeInFolder(inside: FileFolder, n: number): File[] {
  const list: File[] = [];
  for (const f of getRandomizedFolders(inside)) {
    if (list.length >= n) {
      break;
    }
    if (f) {
      list.push(...takeInFolder(f, n - list.length));
    } else {
      list.push(...takeFiles(inside, n - list.length));
    }
  }
  return list;
}

export function handler(globalOptions: {
  source: string;
  to: string;
  amount: number;
}) {
  const root = getFolderByName(globalOptions.source);
  const list = takeInFolder(root, globalOptions.amount);

  // Process with ... | xargs -d "\n" ...
  process.stdout.write(list.map((f) => f.currentFilepath).join("\n") + "\n");

  return Promise.resolve();
}
