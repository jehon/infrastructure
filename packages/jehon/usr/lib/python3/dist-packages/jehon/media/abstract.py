
import jehon.objects as jobj

class JHMetadataMedia:
    """To hold metadata"""

    filename: str
    orientation: int = 0
    timestamp: jobj.DateTimeIncomplete = jobj.empty_date_time()
    title: str = ""

    def __init__(self, filename):
        self.filename = filename
