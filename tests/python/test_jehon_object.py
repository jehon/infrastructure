
import unittest

import jehon.objects as jobj

class Empty:
    a = 123

class TestJehonObject (unittest.TestCase):

    def test_datetime_incomplete(self):
        self.assertEqual(jobj.empty_date_time().is_empty(), True)

        moment = jobj.parse_exif("2000:01:01 00:00:00")
        self.assertEqual(moment.is_empty(), False)

    def test_filter_dict(self):
        self.assertEqual(jobj.filter_dict({}, lambda x, y: True), {})
        self.assertEqual(jobj.filter_dict({"a": 1, "b": 2 }, lambda x, y: True), { "a": 1, "b": 2})
        self.assertEqual(jobj.filter_dict({"a": 1, "b": 2 }, lambda x, y: x < 2), { "a": 1 })

    def test_mutate_dict(self):
        self.assertEqual(jobj.mutate_dict({}, lambda x: x), {})
        self.assertEqual(jobj.mutate_dict({"a": 1}, lambda x: x), { "a": 1})
        self.assertEqual(jobj.mutate_dict({"a": 1}, lambda x: 2 * x), { "a": 2})
        self.assertEqual(jobj.mutate_dict({"a": 1, "b": 2 }, lambda x: 2 * x), { "a": 2, "b": 4})

    def test_proxy(self):
        source = Empty()
        proxy = jobj.JProxy(source)

        self.assertEqual(123, source.a)
        self.assertEqual(123, proxy.a)
        self.assertEqual(source, proxy.get_target())

    def test_randomize_weighted_list(self):
        res = jobj.randomize_weighted_list({ "a": 0.5, "b": 1 })
        self.assertEqual(len(res), 2)

        res = jobj.randomize_weighted_list({ "a": 1, "b": 0 })
        self.assertEqual(len(res), 2)
        self.assertEqual(res[0], "a")
        self.assertEqual(res[1], "b")

        res = jobj.randomize_weighted_list({ "a": 0, "b": 1 })
        self.assertEqual(len(res), 2)
        self.assertEqual(res[0], "b")
        self.assertEqual(res[1], "a")

    def test_value(self):
        val = jobj.Value[str]("test")

        self.assertEqual(val.initial(), "test")
        self.assertEqual(val.current(), "test")
        self.assertEqual(val.expected(), "test")
        self.assertEqual(val.is_done(), True)
        self.assertEqual(val.is_modified(), False)
        self.assertEqual(len(val.messages), 0)

        val.expect("new")
        self.assertEqual(val.initial(), "test")
        self.assertEqual(val.current(), "test")
        self.assertEqual(val.expected(), "new")
        self.assertEqual(val.is_done(), False)
        self.assertEqual(val.is_modified(), False)

        # We expect the same, so no message
        val.expect("new", "because")
        self.assertEqual(len(val.messages), 0)


        # We expect different, so message
        val.expect("another-new", "because")
        self.assertEqual(len(val.messages), 1)

#     val.fixed()

#     self.assertEqual(val.is_done()).toBeTrue()
#     self.assertEqual(val.is_modified()).toBeTrue()

#     v.expect("new3")
#     val.revert()
#     self.assertEqual(val.is_done()).toBeTrue()
#     self.assertEqual(val.expected),val.current)
#   })

#   it("should fire events", function (done) {
#     const v = new Value("test")

#     val.onExpectedChanged((v2) => {
#       self.assertEqual(v2),v)
#       if (val.expected == "test") {
#         // initial call
#         return;
#       }
#       self.assertEqual(val.expected),123)
#       done()
#     })

#     v.expect(123)
#   })

#   it("should equals", function () {
#     const v = new Value("test")

#     self.assertEqual(val.equals("a", "a")).toBeTrue()
#     self.assertEqual(val.equals("a", "b")).toBeFalse()
#     self.assertEqual(val.equals(null, null)).toBeTrue()
#   })

#   describe("withCanonize", function () {
#     it("without fixAlso", function () {
#       const v = new Value("test").withCanonize((v) => "123" + v)
#       v.expect("new_value")
#       self.assertEqual(val.expected),"123new_value")
#     })
#   })

#   describe("withFix", function () {
#     it("without fixAlso", function () {
#       const v = new Value("test")
#       v.expect("new_value")
#       val.fixed()
#       self.assertEqual(val.current),"new_value")
#     })

#     it("with fixAlso", function () {
#       const v2 = new Value("test2").self.assertEqual("new_value_2")
#       const v = new Value("test").withFix(async () => {}, [v2])
#       v.expect("new_value")
#       val.fixed()
#       self.assertEqual(val.current),"new_value")
#       self.assertEqual(v2.current),"new_value_2")
#     })
#   })

#   it("withExpectedFrozen", function () {
#     const v = new Value("test")
#     self.assertEqual(val.expected),"test")
#     val.withExpectedFrozen("test2")
#     self.assertEqual(val.expected),"test2")
#     self.assertEqual(() => v.expect("anything")).toThrowError()
#   })

#   it("withCurrentCalculated", function () {
#     const v = new Value().withCurrentCalculated(() => "2")

#     self.assertEqual(val.current),"2")

#     self.assertEqual(() => new Value("test").withCurrentCalculated(() => true))
#       .withContext("withCurrentCalculated implies not initial values given")
#       .toThrowError()
#   })

#   describe("withExpectedCalculated", function () {
#     it("without basedOn", function () {
#       const v = new Value("test").withExpectedCalculated(() => "2")

#       self.assertEqual(val.expected),"2")
#     })

#     it("with basedOn", function (done) {
#       const emitter = new Value("test")
#       const v = new Value("test").withExpectedCalculated(() => "2", [emitter])

#       self.assertEqual(val.expected),"2")

#       val.onExpectedChanged(() => {
#         done()
#       })

#       emitter.self.assertEqual("anything")
#     })


if __name__ == '__main__':
    unittest.main()
