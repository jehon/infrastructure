
from typing import Optional

from textual.widgets import RichLog

# https://textual.textualize.io/widgets/text_log/
# https://textual.textualize.io/guide/workers/

class LogWidget(RichLog):
    command: str
    title: Optional[str]

    def __init__(self, title: str = "Messages", **kwargs):
        super().__init__(highlight = True, markup=True, max_lines=5, **kwargs)
        self.title = title

    def on_mount(self):
        self.styles.border = ("ascii", "white")
        if self.title:
            self.border_title = self.title
