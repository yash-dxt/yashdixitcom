clean:
	rm -rf ./build

serve: build
	npx superstatic .

deploy: clean build
	firebase deploy
	@echo "Visit https://filiph.net"

build: copy_web

copy_web: spanify
	mkdir -p build
	cp -R ./web/* ./build

spanify:
	dart --enable-asserts tool/spanify.dart \
	  --html src/index.template.html \
	  src/index.md \
	  > web/index.html
