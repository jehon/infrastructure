
import unittest

import jehon.display as jdi

class TestStringMethods (unittest.TestCase):

    def test_headers(self):
        jdi.header_begin("test")
        print("hello 1")
        jdi.header_begin("test2")
        print("hello 2")
        jdi.header_end()
        print("hello 1")
        jdi.header_end()

    def test_messages(self):
        with jdi.block("test_messages"):
            jdi.info("Info message")
            jdi.warning("Warning message")
            jdi.error("Error message")

    def test_subsections(self):
        with jdi.block("test_with_headers"):
            with jdi.header("subsection_1"):
                jdi.info("We are inside test 1")
                with jdi.header("subsection_2"):
                    jdi.info("We are inside test 2")
                jdi.info("We are inside test 1")

    def test_dump(self):
        with jdi.header("test_jh"):
            jdi.dump(123)
            jdi.dump("test")
            jdi.dump([ 1, 2, 3 ])


if __name__ == '__main__':
    unittest.main()
