SHELL := /bin/sh

default: build

clean:
	rm -f pdftk-aws-lambda.zip
	rm -rf ./bin

build: clean
	mkdir -p ./bin
	wget https://gitlab.com/pdftk-java/pdftk/-/jobs/1527259632/artifacts/raw/build/native-image/pdftk -O bin/pdftk
	chmod +x ./bin/pdftk
	@zip -9 --filesync --recurse-paths pdftk-aws-lambda.zip bin/
