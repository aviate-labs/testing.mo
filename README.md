# Testing Framework for Motoko

Inspired by Mocha and Chai 🍵.

## Example

```shell
# cd example
# $(vessel bin)/moc -r $(vessel sources) test/add.test.mo
$(vessel bin)/moc -r test/add.test.mo
```

```text
📄 Add
  0. 🟢 add 2
  
  💬 expected: 12, actual: 10
  1. 🛑 oops...

🟢 1/2 | 🛑 1/2
```

## Modules

### Testify

A module to make a types test 'ready'.
