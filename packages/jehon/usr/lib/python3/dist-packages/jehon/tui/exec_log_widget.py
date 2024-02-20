
import asyncio
from typing import Optional

from textual import work
from textual.message import Message
from textual.widgets import RichLog

# https://textual.textualize.io/widgets/text_log/
# https://textual.textualize.io/guide/workers/

class ExecLogWidget(RichLog):
    # https://textual.textualize.io/guide/events/#custom-messages
    class Selected(Message):
        """Color selected message."""

        def __init__(self, success: bool) -> None:
            self.success = success
            super().__init__()

    command: str
    title: Optional[str]

    def __init__(self, command: str, title: Optional[str] = "", **kwargs):
        super().__init__(highlight = True, markup=True, **kwargs)
        self.command = command
        self.title = title

    def on_mount(self):
        self.styles.border = ("ascii", "white")
        if self.title:
            self.border_title = self.title
        else:
            self.border_title = self.command

    async def _read_stream(self, stream):
        while True:
            line = await stream.readline()
            if line:
                self.write(line)
            else:
                break

    #
    # This will be non-blocking
    #
    #   https://textual.textualize.io/guide/workers/#thread-workers
    #
    @work(exclusive=True)
    async def start(self) -> None:
        # https://docs.python.org/3/library/asyncio-subprocess.html
        process = await asyncio.create_subprocess_shell(self.command, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.STDOUT)

        if process.stdout:
            while True:
                line = await process.stdout.readline()
                if line:
                    self.write(line.decode('utf-8').strip())
                else:
                    break

        exit_code = await process.wait()

        self.write("")

        if exit_code == 0:
            self.write("[green] ✓ Success")
            self.styles.border = ("ascii", "green")
            await asyncio.sleep(5)
            self.remove()
        else:
            self.styles.border = ("ascii", "red")
            self.write("[red] ✗ Failed " + str(exit_code))

        self.post_message(self.Selected(exit_code == 0))
