import { debugPrint } = "mo:⛔";
import Status "Status";
import Testify "Testify";

module {
    public type Test = (
        print : (t : Text) -> ()
    ) -> Bool;

    public func equal<E>(
        testify  : Testify.TestifyElement<E>,
        actual   : E
    ) : Test = func (print: (t : Text) -> ()) : Bool {
        let b = testify.equal(testify.element, actual);
        if (not b) print("💬 expected: " # testify.toText(testify.element) # ", actual: " # testify.toText(actual));
        b;
    };

    public type NamedTest = {
        #Describe : (Text, [NamedTest]);
        #Test     : (Text, Test);
    };

    public func describe(name : Text, tests : [NamedTest]) : NamedTest {
        #Describe(name, tests);
    };

    public func it(name : Text, test : () -> Bool) : NamedTest {
        #Test(name, func (print : (t : Text) -> ()) : Bool = test());
    };

    public func itp(name : Text, test : Test) : NamedTest {
        #Test(name, test);
    };

    public class Suite() {
        let s = Status.Status();

        var indent = 0;
        public func print(t : Text) {
            var s = "";
            var i = 0; while (i < indent) { s #= "  "; i += 1 };
            debugPrint(s # t);
        };

        public func run(tests : [NamedTest]) {
            _run(tests);
            debugPrint("");
            s.printStatus();
        };

        private func _run(tests : [NamedTest]) {
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
                            print(debug_show(k) # ". 🟢 " # name);
                            s.pass();
                        } else {
                            print(debug_show(k) #  ". 🛑 " # name);
                            s.fail();
                        };
                    };
                };
            };
        };
    };
};
