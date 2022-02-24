⚠️ **WIP**

# Testing Framework for Motoko

Inspired by Mocha and Chai 🍵.

## Example

```shell
# cd example
$(vessel bin)/moc -r $(vessel sources) test/add.test.mo
```

```text
📄 Add
  🟢 a + 2 = 12
  🟢 Some sums...
  🛑 This test will fail.
  
  📄 More!
    🟢 a + b = ?

🟢 3/4 | 🛑 1/4
```
