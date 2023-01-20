.PHONY: test

test:
	find test -type f -name '*.test.mo' -print0 | xargs -0 $(shell vessel bin)/moc $(shell vessel sources) -r
