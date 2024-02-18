
from typing import Optional, TypeVar, List

import hashlib
import json
import mimetypes
import os
import pathlib

mime = mimetypes.MimeTypes()

def file_latest(in_path: str, globs: List[str]) -> str:
    """ Get the latest file matching glob
           according to globs
    """

    matches: List[pathlib.Path] = []

    for glob in globs:
        print(f"Looking for {glob} in {in_path}")
        matches = matches + list(pathlib.Path(in_path).glob(glob))

    if len(matches) == 0:
        print("Nothing found")
        raise FileNotFoundError

    return str(max(matches, key=os.path.getctime))

T1 = TypeVar('T1')
def folders_with_properties(path: str, file_properties: str = ".props.json", defaults: Optional[T1] = None) -> dict[str, Optional[T1]]:
    """ Get all files with properties
    """

    res = { '.': defaults }
    for file in os.listdir(path):
        afile = os.path.join(path, file)
        if os.path.isfile(afile):
            continue
        if os.path.isdir(afile):
            if os.path.isfile(os.path.join(afile, file_properties)):
                with open(os.path.join(afile, file_properties), encoding="utf-8") as json_file:
                    res[file] = json.load(json_file)
                    continue
        res[file] = defaults

    return res

def is_image(path: str) -> bool:
    # if mime is None:
    #     exit(1)
    fmime = mime.guess_type(path)[0]
    if not fmime:
        return False
    return fmime.startswith("image/")

def md5(fname: str):
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()
