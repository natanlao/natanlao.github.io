---
title: Documenting Makefile targets
date: 2022-02-01
---

Inspired by [this post (*Autodocumenting Makefiles*) on Hacker
News][make-docs-hn]. This approach only requires `sed`. That can be a good thing
or a bad thing; `sed` is pretty widely available, but its availability isn't
guaranteed, and flags can vary between implementations.

  [make-docs-hn]: https://news.ycombinator.com/item?id=30137254

There is a [Make-native][make-docs-native] way to do this, which is more robust.
I like this approach because it's concise, but it's not *that* much more
concise. There's a tradeoff to be made for sure.

  [make-docs-native]: https://www.cmcrossroads.com/article/self-documenting-makefiles

```Makefile
.DEFAULT_GOAL := help

.PHONY: help
help: ## Display this help message
	@sed -En 's/^([a-zA-Z]+):.*##(.*)$$/\1: \2/p' $(MAKEFILE_LIST) | sort

.PHONY: foo
foo: ## Do the foo
	foo

.PHONY: bar
bar: ## Do the bar
	bar

undocumented_target:
	exit 1
```

```console
$ make
bar:  Do the bar
foo:  Do the foo
help:  Display this help message

$ make help
bar:  Do the bar
foo:  Do the foo
help:  Display this help message
```

See this [Stack Overflow post on printing capture groups with `sed`][sed-regex]
for more info about the `sed` call.

  [sed-regex]: https://stackoverflow.com/a/58379307

The regular expression, piece by piece:

- `^`: match start of line
- `([a-zA-Z]+)`: match 1 or more letters and assign that match to a capture group
- `:.*##`: match a colon, followed by any character, followed by two `#` characters
- `(.*)`: match the rest of the line and assign that match to a capture group
- `$$`: match the end of the line (this should just be `$` but is escaped to `$$` for Make)

Note that `sed` has [slightly different regex syntax][sed-syntax].

  [sed-syntax]: https://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html

