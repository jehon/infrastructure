import assert from "node:assert";
import test from "node:test";
import { weightedRandom } from "./array-helpers";

await test("should weightedRandom()", function () {
  const res = weightedRandom(
    new Map([
      ["a", 1],
      ["b", 1],
      ["last", 0],
      ["d", 1]
    ])
  );

  assert.equal(res.length, 4);
  assert.equal(res[3], "last");
});
