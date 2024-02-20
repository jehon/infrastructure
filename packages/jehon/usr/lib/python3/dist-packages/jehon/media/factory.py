
from .image import JHMetadataImage
from .abstract import JHMetadataMedia

def j_media_factory(filename: str) -> JHMetadataMedia:
    # TODO: handle movies too...

    return JHMetadataImage(filename)
