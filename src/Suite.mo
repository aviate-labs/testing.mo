import { debugPrint } = "mo:⛔";

module {
    public type Test<T>    = (t : T) -> Bool;
    public type Testing<T> = (t : T) -> ();

    public type NamedTest<T> = {
        #Describe : (Text, [NamedTest<T>]);
        #Test     : (Text, Test<T>);
    };

    public func describe<T>(name : Text, tests : [NamedTest<T>]) : NamedTest<T> {
        #Describe(name, tests);
    };

    public func it<T>(name : Text, test : Test<T>) : NamedTest<T> {
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

    private func doNothing<T>() : Testing<T> { func (_ : T) {} };

    public class Suite<T>(state : T) {
        let s : Status = Status();

        var _before : Testing<T> = doNothing<T>();
        public func before(c : Testing<T>) { _before := c; };

        var _beforeEach : Testing<T> = doNothing<T>();
        public func beforeEach(c : Testing<T>) { _beforeEach := c; };

        var _after : Testing<T> = doNothing<T>();
        public func after(c : Testing<T>) { _after := c; };

        var _afterEach : Testing<T> = doNothing<T>();
        public func afterEach(c : Testing<T>) { _afterEach := c; };

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
            _before(state);
            for (t in tests.vals()) {
                switch (t) {
                    case (#Describe(name, tests)) {
                        print("");
                        print("📄 " # name);
                        indent += 1;
                        _run(tests);
                        indent -= 1;
                    };
                    case (#Test(name, test)) {
                        _beforeEach(state);
                        if (test(state)) {
                            print("🟢 " # name);
                            s.pass();
                        } else {
                            print("🛑 " # name);
                            s.fail();
                        };
                        _afterEach(state);
                    };
                };
            };
            _after(state)
        };
    };
};
