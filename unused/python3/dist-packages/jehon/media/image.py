
import exiftool # type: ignore
from PIL import Image, ImageFont, ImageDraw

import jehon.objects as jobj

from .abstract import JHMetadataMedia

def translate_orientation(rotation: str) -> int:
    rotation = str(rotation)

    # What is the top-left corner?
    if rotation in [ "1", "Horizontal (normal)", "top, left"]:
        return 0

    if rotation in [ "6", "Rotate 90 CW", "right, top" ]:
        # https://github.com/recurser/exif-orientation-examples/blob/master/Landscape_6.jpg
        return 90

    if rotation in [ "3", "Rotate 180", "bottom, right" ]:
        # https://github.com/recurser/exif-orientation-examples/blob/master/Landscape_3.jpg
        return 180

    if rotation in [ "8", "Rotate 270 CW", "left, bottom" ]:
        # https://github.com/recurser/exif-orientation-examples/blob/master/Landscape_8.jpg
        return 270

    if rotation in [ "0", "", "(0)", "Unknown (0)" ]:
        # No information given
        return 0

    raise ValueError(f"exifReadRotation: could not understand exif-value: {rotation}")

class JHMetadataImage(JHMetadataMedia):
    def __init__(self, filename):
        super().__init__(filename)

        with exiftool.ExifToolHelper() as et:
            metadata = et.get_metadata(self.filename)[0]

            if "EXIF:Orientation" in metadata:
                self.orientation = translate_orientation(metadata["EXIF:Orientation"])

            if "EXIF:DateTimeOriginal" in metadata:
                self.timestamp = jobj.parse_exif(metadata["EXIF:DateTimeOriginal"])

            if "XMP:Title" in metadata:
                self.title = metadata["XMP:Title"]

        self.img = Image.open(self.filename)
        self.editable = ImageDraw.Draw(self.img)

    def fix_orientation(self):
        self.img.rotate(self.orientation)

    def resize_to_max(self, max_width: int, max_height: int):
        width, height = self.img.size
        reduction = max(width/max_width, height/max_height, 1)
        if reduction > 1:
            self.img = self.img.resize((int(width / reduction),int(height / reduction))) # Image.Resampling.LANCZOS)
            self.editable = ImageDraw.Draw(self.img)

        return self

    def add_text_centered(self, pos, text, font_size = 0.08):
        width, height = self.img.size
        fontSize = round(height * font_size)

        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf", fontSize)
        _, _, w, h = self.editable.textbbox((0, 0), text, font=font)
        dest_x = max(width * pos[0] - w/2, 0)
        dest_y = max(height * pos[1] - h/2, 0)

        self.editable.text((dest_x, dest_y), text, fill=(255, 255, 255), font=font)

        return self
