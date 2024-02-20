
import unittest

from datetime import datetime

import jehon.media as jm

TEST_DATA = __file__.replace('.py', '/')

class TestJehonMedia(unittest.TestCase):
    def test_no_exif(self):
        f = jm.j_media_factory(TEST_DATA + 'no_exif.jpg')

        self.assertEqual(f.timestamp.is_empty(), True) # EXIF_EMPTY
        self.assertEqual(f.title, "")
        self.assertEqual(f.orientation, 0)

#       expect(f.i_fe_tz.initial).toBe(null);

    def test_2018_my_title(self):
        f = jm.j_media_factory(TEST_DATA + '2018-01-02 03-04-05 my comment.jpg')

        self.assertEqual(f.timestamp, datetime(2018, 1, 2, 3, 4, 5))
        self.assertEqual(f.title, "my comment")
        self.assertEqual(f.orientation, 0)

#       expect(f.i_fe_tz.initial).toBe(null);

    def test_1998(self):
        f = jm.j_media_factory(TEST_DATA + '1998-12-31 12-10-11 exifok01.jpg')

        self.assertEqual(f.title, "")
        self.assertEqual(f.timestamp, datetime(1998, 12, 31, 12, 10, 11)) # "1998:12:31 12:10:11"
        self.assertEqual(f.orientation, 0)

#       expect(f.i_fe_tz.initial).toBe(null);

    def test_rotated_bottom_left(self):
        f = jm.j_media_factory(TEST_DATA + 'rotated-bottom-left.jpg')

        self.assertEqual(f.timestamp.is_empty(), True) # "2000-00-00 00-00-00" - Erroneous, but like that in the file
        self.assertEqual(f.title, "rotated-bottom-left")
        self.assertEqual(f.orientation, 270)

#       expect(f.i_fe_tz.initial).toBe(null);

if __name__ == '__main__':
    unittest.main()
