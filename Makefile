.PHONY: build
build:
	mkdocs build -s

.PHONY: serve
serve:
	mkdocs serve

.PHONY: publish
publish: build
	./publish.sh

.PHONY: clean
clean:
	mkdocs build --clean
	rm -rf site
