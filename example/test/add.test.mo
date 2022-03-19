// import { testifyElement } = "mo:testing/Testify";
// import { describe; it; Suite } = "mo:testing/Suite";
import { testifyElement; Testify } = "../../src/Testify";
import { describe; itp; equal; Suite } = "../../src/SuiteState";

import Math "../src/Math";

type State = {
    var a : Nat;
    var b : Nat;
};

let s = Suite<State>({
    var a = 0;
    var b = 0;
});

s.before(func (s : State) {
    s.a := 10;
});

s.run([
    describe("Add", [
        itp("add 2", equal(
            testifyElement(Testify.nat, 12), 
            func (s : State) : Nat { s.a + 2 }
        )),
        itp("oops...", equal(
            testifyElement(Testify.nat, 12), 
            func (s : State) : Nat { s.a }
        )),
    ]),
]);
