"""
    This module is my system module
"""

# https://docs.python.org/3/reference/import.html#submodules

#
# This file is necessary to treat the folder as a named module:
#
#  => jehon/jh.py ? => import jehon.jh
#
# But it can define aliases:
#
# from .system import jh
#
#  => import jh from jehon
#

#
# Other info:
#
# - Get the real PYTHONPATH:
#     python3 -c "import sys;print(sys.path)"
#
# - Specify what to expose (and what to hide):
#   __all__ = [ "jh" ]
#
