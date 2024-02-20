from textual.app import ComposeResult
from textual.containers import Container
from textual.screen import ModalScreen
from textual.widgets import Input

class InputModal(ModalScreen):
    DEFAULT_CSS = """
    InputModal {
        align: center middle;
    }

    InputModal > Container {
        width: auto;
        height: auto;
    }

    InputModal > Container > Input {
        width: 32;
    }
    """

    def compose(self) -> ComposeResult:
        with Container():
            yield Input()

    def on_input_submitted(self) -> None:
        # dismiss the modal screen with value
        self.dismiss(self.query_one(Input).value)
