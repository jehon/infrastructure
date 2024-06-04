
# contextmanager is to define with... functions easily
from contextlib import contextmanager
import sys

# https://pypi.org/project/termcolor/ <= see list of colors
# python -m termcolor
from termcolor import colored

@contextmanager
def block(title: str = "block"):
    """Show the following lines between two markers (**** line)"""

    try:
        print("")
        print(f"**************** begin: {title} ***********************")
        yield None
    finally:
        print(f"**************** end: {title} -------------------------")
        print("")

def info(msg: str):
    """Log a message (with tags)"""

    print(colored(text=msg, color="blue"))

def warning(msg: str):
    """Log a message (with tags)"""

    print(colored(text=msg, color="magenta"))

def error(msg: str):
    """Log a message (with tags)"""

    print(colored(text=msg, color="red"))

def fatal(msg: str):
    """Log a message (with tags)"""

    print(colored(text=msg, color="red"), file=sys.stderr)
    sys.exit(1)
