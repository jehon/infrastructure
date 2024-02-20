
import unittest

import os

import jehon.fs as jfs

TEST_DATA = __file__.replace('.py', '/')

class TestJehonObject (unittest.TestCase):
    def test_is_image(self):
        self.assertFalse(jfs.is_image(TEST_DATA))
        self.assertFalse(jfs.is_image(os.path.join(TEST_DATA, "text.txt")))
        self.assertTrue(jfs.is_image(os.path.join(TEST_DATA, "image.jpg")))

if __name__ == '__main__':
    unittest.main()
