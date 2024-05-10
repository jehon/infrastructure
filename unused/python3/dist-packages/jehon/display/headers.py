
from contextlib import contextmanager
import io
import sys

class _StampedOut(io.StringIO):
    """Stamped stdout."""

    headersStack: list[str] = []
    is_newline = False

    def __init__(self, out):
        super().__init__()
        self.out = out

    def get_headers(self):
        if len(self.headersStack) == 0:
            return ""
        return "[" +  "][".join(self.headersStack) + "] "

    def write(self, what):
        """Write function overloaded.
        """
        #
        # "ab".split("\n") => ['ab']
        # "a\nb".split("\n") => ['a', 'b']
        # "\na\nb\n".split("\n") => ['', 'a', 'b', '']
        # "\n".split("\n") => ['', '']
        # "".split("\n") => ['']
        #
        if self.is_newline:
            # Last time, we had a newline
            self.out.write(f"{self.get_headers()}")
            self.is_newline = False

        lines = str(what).split("\n")
        if lines[-1] == '':
            # We end with a newline
            #   so we don't print the last headers
            #   in case we header_end before writing something
            lines.pop()
            self.is_newline = True

        self.out.write(("\n" + self.get_headers()).join(lines))


        if self.is_newline:
            # We write the newline at the end
            self.out.write("\n")

    def isatty(self) -> bool:
        return self.out.isatty()

    def flush(self):
        self.out.flush()

    def begin(self, key):
        self.headersStack.append(key)
        self.is_newline=True

    def end(self):
        self.headersStack.pop()

stamper = _StampedOut(sys.stdout)
sys.stdout = stamper

def header_begin(key: str):
    stamper.begin(key)

def header_end():
    stamper.end()

@contextmanager
def header(key: str):
    """Start a subsection with new headers / prefix"""

    try:
        header_begin(key)
        yield None
    finally:
        header_end()
