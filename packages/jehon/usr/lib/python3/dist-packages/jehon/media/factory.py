
from .image import JHMetadataImage
from .abstract import JHMetadataMedia

def j_media_factory(filename: str) -> JHMetadataMedia:
    return JHMetadataImage(filename)
