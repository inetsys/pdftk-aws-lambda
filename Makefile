SHELL := /bin/sh

default: build

clean:
	rm -f pdftk-aws-lambda.zip

build: clean
	@zip -9 --filesync --recurse-paths pdftk-aws-lambda.zip bin/ lib/
