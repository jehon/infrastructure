#!/usr/bin/env python3

#
# Remove empty folders
#
# If there is only one eaDir, it is still empty#
#

import os
import sys
import shutil

EADIR="@eaDir"

def recurse(folder):
    os.chdir(folder)

    i = 0
    for f in os.scandir(folder):
        if f.name == EADIR:
            continue

        if f.is_file():
            i += 1
            continue

        if f.is_dir():
            i += recurse(os.path.join(folder, f))
                
    if i > 0:
        # Something here!
        return 1

    print("We should remove " + folder)
    ea = os.path.join(folder, EADIR)
    if os.path.isdir(ea):
        shutil.rmtree(ea)
    os.rmdir(folder)
    return 0

if (len(sys.argv) == 2):
    recurse(sys.argv[1])
else:
    recurse("{{ data_volume }}/Documents")
    recurse("{{ data_volume }}/Photos")
    recurse("{{ data_volume }}/Musiques")
    recurse("{{ data_volume }}/Videos")
  