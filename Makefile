##
# Kore Make
# Copyright(c) 2013 Koreviz
# MIT Licensed
##
SHELL := /bin/bash

APP = green-lantern
VERSION = v1.0.0
PUG = $(shell find node_modules/pug-cli -maxdepth 3 -name "index.js" -type f)
OPTIONS = { "filename": " ", "title": "Kore", "description": "", "keywords": "" }
PAGES = index.pug
REPO = koreviz/$(APP)
SERVE = $(shell find node_modules -name "serve" -type f)
UGLIFYJS = $(shell find node_modules -name "uglifyjs" -type f)
VENDOR = moz,webkit

all: configure compile
	
clean:
	rm -fR {build,components,node_modules}
	rm -fR public/fonts
	rm -f public/*{.css,.js,.html}

configure:
	npm install
	mkdir -p ./build

compile:
	duo style/app.css > public/build.css
	$(foreach page,$(PAGES),$(foreach view,$(shell find view -name "$(page)" -type f),$(PUG) $(view) -O '$(OPTIONS)' -o public;))
	duo script/app.js > public/build.js

debug:
	duo style/app.css > public/build.css
	$(foreach page,$(PAGES),$(foreach view,$(shell find view -name "$(page)" -type f),$(PUG) $(view) -O '$(OPTIONS)' -o public;))
	duo script/app.js > public/build.js

package:
	export COPYFILE_DISABLE=true; tar czvf ../$(APP)-$(VERSION).tar.gz History.md public Readme.md

push:
	rm -fR .git
	git init
	git add .
	git commit -m "Initial release"
	git remote add origin gh:$(REPO).git
	git push origin master

serve:
	$(SERVE) -f ./public/favicon.ico ./public