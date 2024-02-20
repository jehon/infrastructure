
import yaml

from .section import block

def dump(arg, name: str = "") -> None:
    if name:
        with block(name):
            dump(arg)
        return

    if isinstance(arg, str):
        print(arg)
        return
    if isinstance(arg, int):
        print(str(arg))
        return
    for line in yaml.dump(arg).split("\n"):
        print(line)
