clean:
	rm -rf ./build

serve: build
	npx superstatic .

clean-serve:
	@echo "Stopping any existing server..."
	@pkill -f "superstatic" || true
	@sleep 1

deploy: clean build
	firebase deploy
	@echo "Visit https://filiph.net"

build: copy_web

copy_web: spanify trip_pages
	mkdir -p build
	cp -R ./web/* ./build

spanify:
	dart --enable-asserts tool/spanify.dart \
	  --html src/index.template.html \
	  src/index.md \
	  > web/index.html

trip_pages:
	@echo "Building trip pages..."
	@for file in src/trips/*.md; do \
		if [ -f "$$file" ]; then \
			filename=$$(basename "$$file" .md); \
			echo "Building $$filename.html from $$file"; \
			dart --enable-asserts tool/md_to_html.dart \
			  --html src/index.template.html \
			  "$$file" \
			  > "web/$$filename.html"; \
		fi; \
	done
