import assert from "node:assert";
import test from "node:test";
import { createEmptyUnitFile } from "../../test/unit/test-unit-helpers";
import FileFolder, { getFolderByName } from "../file-types/file-folder";
import FileHidden from "../file-types/file-hidden";
import buildFile from "./buildFile";

await test("should handle folders", () => {
  const etc = getFolderByName("/etc");
  assert.ok(etc instanceof FileFolder);
});

await test("should handle files without extension", () => {
  const fp = createEmptyUnitFile("blablabla");
  assert.ok(buildFile(fp) instanceof FileHidden);
});

await test("should use cache for folders", () => {
  // Works only for folders
  const f0 = getFolderByName("/etc/default");
  const f1 = getFolderByName("/etc/default");
  assert.equal(f1.id, f0.id);
  assert.equal(f0.getParentValue().initial.id, f1.getParentValue().initial.id);
});
