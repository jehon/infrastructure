
from typing import Generic, TypeVar, Optional
# Callable

T = TypeVar("T")

# value = Value[str]()

class Value(Generic[T]):
    # _canonize_function: Callable[[T], T]

    _initial: Optional[T]

    _current: Optional[T]
    # _current_function: Callable[[], T]

    _expected: Optional[T]
    # _expected_function: Callable[[], T]
    # _expected_frozen = False

    # _fix_function: Callable([T, File], None) = (_v, _f) => {};
    # _fix_also: list[Self]= []

    # List of associated messages
    messages: list[str] = []

    def __init__(self, value: Optional[T]):
        self._initial = value
        self._current = value
        self._expected = value

    def __str__ (self):
        return f'Value({self.initial()} -> {self.current()} => {self.expected()})'

    def equals(self, first: Optional[T], second: Optional[T]) -> bool:
        return first == second

    def initial(self) -> Optional[T]:
        return self._initial

    def current(self) -> Optional[T]:
    #  if (self._current_function):
#       return self._current_function();
        return self._current

    def expected(self) -> Optional[T]:
#     if (self._expected_function) {
#       return self._expected_function();
#     }
        return self._expected

    def is_modified(self) -> bool:
        """Test if someone did modify the (current) value"""
        return not self.equals(self.current(), self.initial())

    def is_done(self) -> bool:
        return self.equals(self.expected(), self.current())

#   is_calculated() {
#     return (
#       self._expected_frozen || self._expected_function || self._current_function
#     );
#   }

    def expect(self, expect: T, message: Optional[str] = None):

#     if (self._expected_frozen) {
#       throw new Error(
#         `Expected value is frozen to ${
#           self._expected
#         }. Could not expect anymore to ${expect} (${message})`
#       );
#     }

#     expect = self._canonize_function(expect);

        if self.equals(self._expected, expect):
            return self

        if message:
            self.messages.append(message)

        if self._expected != expect:
            self._expected = expect
            # self.emitExpectedChange(expect);

        return self

#   /**
#    *
#    * @param {function(any):any} fn to validate a value
#    * @returns {self} for chaining
#    */
#   withCanonize(fn) {
#     self._canonize_function = fn;
#     // If the expected value was already set, we need to canonize it...
#     self._expected = self._canonize_function(self._expected);
#     return self;
#   }

#   /**
#    *
#    * @param {*} expected to be frozen to
#    * @param {string} message associated with the action (for info only)
#    * @returns {self} for chaining
#    */
#   withExpectedFrozen(expected, message = "") {
#     self.expect(expected, message);
#     self._expected_frozen = true;
#     return self;
#   }

#   /**
#    *
#    * @param {ValueCalculation} fn to calculate the expected value
#    * @param {Array<Value>} basedOn to listen for
#    * @returns {self} for chaining
#    */
#   withExpectedCalculated(fn, basedOn = []) {
#     const prevExpected = self.expected;

#     self._expected_function = fn;
#     for (const val of basedOn) {
#       val.onExpectedChanged(() => self.emitExpectedChange());
#     }

#     // The calculated (new) value is different thant previous one?
#     if (self.expected != prevExpected) {
#       self.emitExpectedChange();
#     }

#     return self;
#   }

#   /**
#    * The current value is calculated based on a formula.
#    *    - the initial value is calculated also
#    *    - if the expected value is not already set, it is initialized
#    *
#    * @param {ValueCalculation} fn to calculate the current value
#    * @returns {self} for chaining
#    */
#   withCurrentCalculated(fn) {
#     if (self.self._initial !== undefined) {
#       throw new Error(
#         `When using withCurrentCalculated, initial value must be not set (it was set to ${
#           self.self._initial
#         })`
#       );
#     }
#     self._current_function = fn;
#     self.self._initial = fn();
#     if (self._expected === undefined) {
#       self._expected = fn();
#     }
#     return self;
#   }

#   /**
#    *
#    * @param {FixFunction} fixFunction to fix the value
#    * @param {Array<Value>} fixAlso to listen for
#    * @returns {self} self for chaining
#    */
#   withFix(fixFunction, fixAlso = []) {
#     self._fix_function = fixFunction;
#     self._fix_also = fixAlso;
#     return self;
#   }

#   /**
#    * Revert the value to the current value
#    *
#    * @returns {self} self for chaining
#    */
#   revert() {
#     if (!self._expected_frozen && !self._expected_function) {
#       self.expect(self.current);
#     }
#     return self;
#   }

#   /**
#    *
#    * @returns {self} self for chaining
#    */
#   fixed() {
#     if (!self._current_function) {
#       self._current = self.expected;
#     }

#     // Dependant values are also automatically fixed
#     for (const val of self._fix_also) {
#       val.fixed();
#     }

#     return self;
#   }

#   /**
#    * Fix the current value by executing fixing function
#    * - If the function is alreay "done", does nothing...
#    * - In case of error, store the error in #lastError
#    *
#    * We don't fix the value here, since we don't know if it worked or not
#    *
#    * @returns {Promise} when fix is completed
#    */
#   async runFixValue() {
#     if (self.is_done()) {
#       return;
#     }

#     try {
#       return self._fix_function(self);
#     } catch (e) {
#       self.lastError = e;
#       return false;
#     }
#   }

#   /**
#    * Emit a signal that the expected value has changed
#    *
#    * @param {any} nv as the new value
#    * @protected
#    * @returns {self} to be chained
#    */
#   emitExpectedChange(nv) {
#     self.emit("expectedChanged", nv);
#     return self;
#   }

#   /**
#    * Register a callback
#    *
#    * @param {function(Value):any} cb to be called
#    * @param {boolean} fireImmediately if need to be fired immediately
#    * @returns {self} for chaining
#    */
#   onExpectedChanged(cb, fireImmediately = false) {
#     self.on("expectedChanged", () => cb(self));
#     if (fireImmediately) {
#       cb(self);
#     }
#     return self;
#   }

#   toJSON() {
#     const vjson = (val) => (val?.id ? val.id : val);

#     return {
#       className: self.constructor.name,
#       initial: vjson(self.initial),
#       current: vjson(self.current),
#       expected: vjson(self.expected),
#       messages: self.messages,
#       lastError: self.lastError,
#     };
#   }
