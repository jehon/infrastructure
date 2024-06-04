
from typing import Callable, TypeVar

from random import SystemRandom

cryptorand = SystemRandom()

TKey = TypeVar('TKey')
TValue = TypeVar('TValue')
TOutput = TypeVar('TOutput')

def mutate_dict(source: dict[TKey, TValue], mapper: Callable[[TValue], TOutput]) -> dict[TKey, TOutput]:
    return {
        k: mapper(v)
        for k, v in source.items()
    }

def filter_dict(source: dict[TKey, TValue], selected_if: Callable[[TValue, TKey], bool]) -> dict[TKey, TValue]:
    return {
        k: v
        for k, v in source.items() if selected_if(v, k)
    }

def randomize_weighted_list(weightedList: dict[TKey, float]) -> list[TKey]:
    keys = list(weightedList.keys())
    res = []

    total = sum(weightedList.values())

    while len(keys) > 0:
        step: float = cryptorand.random() * total

        acc: float = 0.0
        for key in keys:
            acc += weightedList[key]
            if acc >= step:
                keys.remove(key)
                total -= weightedList[key]
                res.append(key)
                break

    return res
