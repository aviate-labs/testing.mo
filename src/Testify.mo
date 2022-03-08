import Prim "mo:⛔";

module {
    public type Testify<T> = {
        toText : (t : T) -> Text;
        equal  : (x : T, y : T) -> Bool;
    };

    public func testify<T>(
        toText : (t : T) -> Text,
        equal  : (x : T, y : T) -> Bool
    ) : Testify<T> = { toText; equal };

    public func optionalTestify<T>(
        testify : Testify<T>,
    ) : Testify<?T> = {
        toText = func (t : ?T) : Text = switch (t) {
            case (null) { "null" };
            case (? t)  { "?" # testify.toText(t) }
        };
        equal = func (x : ?T, y : ?T) : Bool = switch (x) {
            case (null) switch (y) {
                case (null) { true };
                case (_)    { false };
            };
            case (? x) switch(y) {
                case (null) { false };
                case (? y)  { testify.equal(x, y) };
            };
        };
    };

    public type TestifyElement<T> = Testify<T> and {
        element : T;
    };

    public func testifyElement<T>(
        testify : Testify<T>,
        element : T
    ) : TestifyElement<T> = {
        toText = testify.toText;
        equal  = testify.equal;
        element;
    };

    /// Submodule of primitive testify functions (excl. 'Any', 'None' and 'Null').
    /// https://github.com/dfinity/motoko/blob/master/src/prelude/prelude.mo
    public module Testify {
        public let bool : Testify<Bool> = {
            toText = func (t : Bool) : Text { if (t) { "true" } else { "false" } };
            equal  = func (x : Bool, y : Bool) : Bool { x == y };
        };

        public let nat : Testify<Nat> = {
            toText = func (n : Nat) : Text = intToText(n);
            equal  = func (x : Nat, y : Nat) : Bool { x == y };
        };

        public let nat8 : Testify<Nat8> = {
            toText = func (n : Nat8) : Text = nat.toText(Prim.nat8ToNat(n));
            equal  = func (x : Nat8, y : Nat8) : Bool { x == y };
        };

        public let nat16 : Testify<Nat16> = {
            toText = func (n : Nat16) : Text = nat.toText(Prim.nat16ToNat(n));
            equal  = func (x : Nat16, y : Nat16) : Bool { x == y };
        };

        public let nat32 : Testify<Nat32> = {
            toText = func (n : Nat32) : Text = nat.toText(Prim.nat32ToNat(n));
            equal  = func (x : Nat32, y : Nat32) : Bool { x == y };
        };

        public let nat64 : Testify<Nat64> = {
            toText = func (n : Nat64) : Text = nat.toText(Prim.nat64ToNat(n));
            equal  = func (x : Nat64, y : Nat64) : Bool { x == y };
        };

        public let int : Testify<Int> = {
            toText = func (i : Int) : Text = intToText(i);
            equal  = func (x : Int, y : Int) : Bool { x == y };
        };

        public let int8 : Testify<Int8> = {
            toText = func (i : Int8) : Text = int.toText(Prim.int8ToInt(i));
            equal  = func (x : Int8, y : Int8) : Bool { x == y };
        };

        public let int16 : Testify<Int16> = {
            toText = func (i : Int16) : Text = int.toText(Prim.int16ToInt(i));
            equal  = func (x : Int16, y : Int16) : Bool { x == y };
        };

        public let int32 : Testify<Int32> = {
            toText = func (i : Int32) : Text = int.toText(Prim.int32ToInt(i));
            equal  = func (x : Int32, y : Int32) : Bool { x == y };
        };

        public let int64 : Testify<Int64> = {
            toText = func (i : Int64) : Text =  int.toText(Prim.int64ToInt(i));
            equal  = func (x : Int64, y : Int64) : Bool { x == y };
        };

        public let float : Testify<Float> = {
            toText = func (f : Float) : Text = Prim.floatToText(f);
            equal  = func (x : Float, y : Float) : Bool { x == y };
        };

        public let char : Testify<Char> = {
            toText = func (c : Char) : Text = Prim.charToText(c);
            equal  = func (x : Char, y : Char) : Bool { x == y };
        };

        public let text : Testify<Text> = {
            toText = func (t : Text) : Text { t };
            equal  = func (x : Text, y : Text) : Bool { x == y };
        };

        public let blob : Testify<Blob> = {
            toText = func (b : Blob) : Text { encodeBlob(b) };
            equal  = func (x : Blob, y : Blob) : Bool { x == y };
        };

        public let error : Testify<Error> = {
            toText = func (e : Error) : Text { Prim.errorMessage(e) };
            equal  = func (x : Error, y : Error) : Bool {
                Prim.errorCode(x)    == Prim.errorCode(y) and 
                Prim.errorMessage(x) == Prim.errorMessage(y);
            };
        };

        public let principal : Testify<Principal> = {
            toText = func (p : Principal) : Text { debug_show(p) };
            equal  = func (x : Principal, y : Principal) : Bool { x == y };
        };

        // Utility Functions
        private func intToText(i : Int) : Text {
            if (i == 0) return "0";
            let negative = i < 0;
            var t = "";
            var n = if (negative) { -i } else { i };
            while (0 < n) {
                t := (switch (n % 10) {
                    case 0 { "0" };
                    case 1 { "1" };
                    case 2 { "2" };
                    case 3 { "3" };
                    case 4 { "4" };
                    case 5 { "5" };
                    case 6 { "6" };
                    case 7 { "7" };
                    case 8 { "8" };
                    case 9 { "9" };
                    case _ { Prim.trap("unreachable") };
                }) # t;
                n /= 10;
            };
            if (negative) { "-" # t } else { t };
        };

        private let hex : [Char] = [
            '0', '1', '2', '3', 
            '4', '5', '6', '7', 
            '8', '9', 'a', 'b', 
            'c', 'd', 'e', 'f',
        ];

        private func encodeByte(n : Nat8, acc : Text) : Text {
            let c0 = hex[Prim.nat8ToNat(n / 16)];
            let c1 = hex[Prim.nat8ToNat(n % 16)];
            Prim.charToText(c0) # Prim.charToText(c1) # acc;
        };

        private func encodeBlob(b : Blob) : Text {
            let bs = Prim.blobToArray(b);
            var t = "";
            var i = bs.size();
            while (0 < i) {
                i -= 1;
                t := encodeByte(bs[i], t);
            };
            t;
        };
    };
};
