
import unittest

import os

import jehon.media as jm
import jehon.objects as jobj

TEST_DATA = os.path.join(
    os.path.dirname(os.path.dirname(__file__)),
    "data"
)

class TestJehonMedia(unittest.TestCase):
    def one(self, file, timestamp, title):
        f = jm.j_media_factory(os.path.join(TEST_DATA, file))

        self.assertEqual(f.timestamp, timestamp, msg=file + " - timestamp")
        self.assertEqual(f.title, title, msg=file + " - title")

    def test_android(self):
        self.one("android-camera/20211225_202250.jpg", jobj.DateTimeIncomplete(2021, 12, 25, 20, 22, 50), "")
        # self.one("android-camera/20211225_202302.mp4", DateTimeIncomplete(2021, 12, 25, 20, 22, 25), "")

    def test_android_signal(self):

        self.one("android-signal/signal-2022-04-07-16-45-43-559.jpg", jobj.empty_date_time(), "")

        # The image is 2022-04-22 12:25:32
        # The exif is: "MediaModifyDate": "2022:04:22 10:25:36"
        # self.one("android-signal/signal-2022-04-22-12-25-56-329.mp4", DateTimeIncomplete(2022, 4, 22, 10, 25, 56), "")

    def test_android_whatsapp(self):
        self.one("android-whatsapp/IMG-20211226-WA0001.jpeg", jobj.DateTimeIncomplete(2021, 12, 26, 13, 13, 2), "")
    #     self.one("android-whatsapp/VID-20211226-WA0003.mp4", DateTimeIncomplete(2021, 12, 26, 12, 13, 17), "") // UTC

    def test_camera_canon(self):
        self.one("camera-canon/DSC_5747.JPG", jobj.DateTimeIncomplete(2021, 12, 25, 20, 22, 23), "")
        # self.one("camera-canon/DSC_5749.MOV", jobj.DateTimeIncomplete(2021, 12, 25, 20, 22, 48), "")

    def test_scanner_naps2(self):
        self.one("scanner-naps2/2021-12 scanned.jpg", jobj.empty_date_time(), "")

    def test_web(self):
        self.one("web/2021-02-03.png", jobj.empty_date_time(), "")

if __name__ == '__main__':
    unittest.main()
