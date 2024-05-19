import mimeTypes from "mime-types";
import child_process from "node:child_process";
import path from "node:path";
import FileFolder, { getFolderByName } from "../file-types/file-folder";
import { arrayShuffle, arrayShuffleWeighted } from "../helpers/array-helpers";
import { fsIsFolder } from "../helpers/fs-helpers";
import buildFile from "../lib/buildFile";

export const command = ["kiosk [source]"];

export const describe = "Launch kiosk on tty";

export const builder = {
  amount: {
    describe: "Number of files",
    type: "number",
    default: 20
  }
};

const CONFIG_NAME = "kiosk.json";
interface Config {
  priority: number;
}

function takeImages(inside: FileFolder, n: number): string[] {
  const list = Array.from(inside.getAllCurrentFilenames())
    .map((f) => path.join(inside.currentFilepath, f))
    .filter((f) => (mimeTypes.lookup(f) || "").split("/")[0] == "image")
    .filter((f) => !fsIsFolder(f));
  return arrayShuffle(list).slice(0, n);
}

function getRandomizedFolders(inside: FileFolder): (FileFolder | null)[] {
  const subFolders = Array.from(inside.getAllCurrentFilenames())
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

function takeInFolder(inside: FileFolder, n: number): string[] {
  const list: string[] = [];
  for (const f of getRandomizedFolders(inside)) {
    if (list.length >= n) {
      break;
    }
    if (f) {
      list.push(...takeInFolder(f, n - list.length));
    } else {
      list.push(...takeImages(inside, n - list.length));
    }
  }
  return list;
}

export function handler(globalOptions: { source: string; amount: number }) {
  const root = getFolderByName(globalOptions.source);
  const list = takeInFolder(root, globalOptions.amount);

  // Process with ... | xargs -d "\n" ...
  process.stdout.write(list.join("\n") + "\n");
  child_process.execFileSync(
    "/usr/bin/fbi",
    [
      "--autozoom",
      "--noedit",
      "--readahead",
      // Transition mix
      "--blend",
      "100",
      // Image time
      "--timeout",
      "15",
      ...list
    ],
    {
      stdio: "inherit"
    }
  );

  return Promise.resolve();
}
