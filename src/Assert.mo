module {
  public func assertTrue(x : Bool) : Bool {
    x == true;
  };

  public func assertFalse(x : Bool) : Bool {
    x == false;
  };

  public func assertAllTrue(xs : [Bool]) : Bool {
    for (v in xs.vals()) if (v == false) return false;
    true;
  };
};
