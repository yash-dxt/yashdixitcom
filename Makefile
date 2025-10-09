clean:
	rm -rf ./build

serve: build
	cd build && npx superstatic .

clean-serve:
	@echo "Stopping any existing server..."
	@pkill -f "superstatic" || true
	@sleep 1

deploy: clean build
	@echo "Deploy target removed - Firebase no longer configured"
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
	@echo "Building all markdown pages..."
	@find src -name "*.md" -not -name "index.md" | while read file; do \
		filename=$$(basename "$$file" .md); \
		dirname=$$(dirname "$$file" | sed 's|src/||'); \
		if [ "$$dirname" != "src" ]; then \
			echo "Building $$dirname/$$filename.html from $$file"; \
			mkdir -p "web/$$dirname"; \
			dart --enable-asserts tool/md_to_html.dart \
			  --html src/index.template.html \
			  "$$file" \
			  > "web/$$dirname/$$filename.html"; \
		else \
			echo "Building $$filename.html from $$file"; \
			dart --enable-asserts tool/md_to_html.dart \
			  --html src/index.template.html \
			  "$$file" \
			  > "web/$$filename.html"; \
		fi; \
	done
