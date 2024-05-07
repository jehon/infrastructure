import assert from "node:assert";
import test from "node:test";
import { arrayShuffle, arrayShuffleWeighted } from "./array-helpers";

await test("should arrayShuffle()", function () {
  const res = arrayShuffle(["a", "b", "c"]);

  assert.equal(res.length, 3);
});

await test("should arrayShuffleWeighted()", function () {
  const res = arrayShuffleWeighted(
    new Map([
      ["a", 1],
      ["b", 1],
      ["last", 0],
      ["d", 1]
    ])
  );

  assert.equal(res.length, 4);
  assert.equal(res[3], "last");
  assert.ok(res.includes("a"));
});
