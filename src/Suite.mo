import { debugPrint } = "mo:⛔";
import Testify "Testify";

module {
    public type Test<T> = (
        print : (t : Text) -> ()
    ) -> Bool;

    public func equal<T, E>(
        testify  : Testify.TestifyElement<E>,
        actual   : E
    ) : Test<T> = func (print: (t : Text) -> ()) : Bool {
        let b = testify.equal(testify.element, actual);
        if (not b) print("💬 expected: " # testify.toText(testify.element) # ", actual: " # testify.toText(actual));
        b;
    };

    public type NamedTest<T> = {
        #Describe : (Text, [NamedTest<T>]);
        #Test     : (Text, Test<T>);
    };

    public func describe<T>(name : Text, tests : [NamedTest<T>]) : NamedTest<T> {
        #Describe(name, tests);
    };

    public func it<T>(name : Text, test : () -> Bool) : NamedTest<T> {
        #Test(name, func (print : (t : Text) -> ()) : Bool = test());
    };

    public func itp<T>(name : Text, test : Test<T>) : NamedTest<T> {
        #Test(name, test);
    };

    private class Status() {
        var _pass = 0;
        public func pass() { _pass += 1 };
        public func passed() : Nat { _pass };

        var _fail = 0;
        public func fail() { _fail += 1 };
        public func failed() : Nat { _fail };

        public func printStatus() {
            let total = debug_show(_pass + _fail);
            debugPrint("🟢 " # debug_show(_pass) # "/" # total # " | 🛑 " # debug_show(_fail) # "/" # total # "\n");
        };
    };

    public class Suite<T>(state : T) {
        let s : Status = Status();

        var indent = 0;
        public func print(t : Text) {
            var s = "";
            var i = 0; while (i < indent) { s #= "  "; i += 1 };
            debugPrint(s # t);
        };

        public func run(tests : [NamedTest<T>]) {
            _run(tests);
            debugPrint("");
            s.printStatus();
        };

        private func _run(tests : [NamedTest<T>]) {
            for (k in tests.keys()) {
                let t = tests[k];
                switch (t) {
                    case (#Describe(name, tests)) {
                        print("");
                        print("📄 " # name);
                        indent += 1;
                        _run(tests);
                        indent -= 1;
                    };
                    case (#Test(name, test)) {
                        if (k != 0) print("");
                        if (test(print)) {
                            print("🟢 " # name);
                            s.pass();
                        } else {
                            print("🛑 " # name);
                            s.fail();
                        };
                    };
                };
            };
        };
    };
};
