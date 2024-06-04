
class JProxy():
    _target = None

    def __init__(self, target: object):
        self._target = target

    def get_target(self):
        """Get the target"""

        return self._target

    def __getattr__(self, name):
        return getattr(self._target, name)
