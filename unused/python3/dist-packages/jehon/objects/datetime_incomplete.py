
from datetime import datetime

class DateTimeIncomplete(datetime):
    def is_empty(self):
        return self.year == 1

def empty_date_time():
    return DateTimeIncomplete(1, 1, 1, 0, 0, 0)

def parse_exif(text):
    try:
        return DateTimeIncomplete.strptime(
                ":".join(text.split("-")),
                '%Y:%m:%d %H:%M:%S'
            )
    except ValueError:
        pass

    return empty_date_time()
