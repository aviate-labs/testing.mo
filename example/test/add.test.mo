// TODO: replace with vessel package.
import Assert "../../src/Assert";
import { describe; it; Suite } = "../../src/Suite";

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
        it("a + 2 = 12", func (st : State) : Bool {
            st.a + 2 == 12;
        }),
        it("Some sums...", Assert.it.all([
            Assert.isTrue(1 + 2 == 3),
            Assert.isTrue(2 + 2 == 4),
            // etc...
        ])),
        it("This test will fail.", Assert.it.isTrue(
            1 + 1 == 3
        )),
        describe("More!", [
            it("a + b = ?", func (st : State) : Bool {
                st.a + st.b == 10;
            }),
        ]),
    ]),
]);
