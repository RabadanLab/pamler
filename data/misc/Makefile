SHELL := /bin/bash

help: ## Prints help for targets with comments
	@grep -E '^[.0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test:
	bash tests/test-if-number-of-fasta-aligned-matches-with-trees.sh

