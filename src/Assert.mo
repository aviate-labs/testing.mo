import Suite "Suite";

module Assert {
    public module it {
        public func isTrue<T>(t : Bool) : Suite.Test<T> {
            func (_ : T) : Bool { Assert.isTrue(t) };
        };

        public func isFalse<T>(t : Bool) : Suite.Test<T> {
            func (_ : T) : Bool { Assert.isFalse(t) };
        };

        public func all<T>(ts : [Bool]) : Suite.Test<T> {
            func (_ : T) : Bool { Assert.all(ts) };
        };
    };

    public func isTrue(t : Bool) : Bool { t };

    public func isFalse(t : Bool) : Bool { not t };

    public func all(ts : [Bool]) : Bool {
        for (a in ts.vals()) if (not a) return false;
        return true;
    };
};