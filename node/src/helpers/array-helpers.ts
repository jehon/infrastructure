export function weightedRandom<T>(weightedList: Map<T, number>): T[] {
  const res: T[] = [];

  while (weightedList.size > 0) {
    const total = Array.from(weightedList.values()).reduce(
      (acc, val) => acc + val,
      0
    );
    const step = Math.random() * total;

    let acc = 0.0;
    for (const key of Array.from(weightedList.keys())) {
      acc += weightedList.get(key)!;
      if (acc >= step) {
        res.push(key);
        weightedList.delete(key);
        break;
      }
    }
  }

  return res;
}
