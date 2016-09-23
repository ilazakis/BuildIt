#!/bin/bash

rm -rf /private/tmp/fixtures # copy fixtures/resources to make available to tests
cp -r fixtures /private/tmp
swift package generate-xcodeproj
xcodebuild \
	-scheme RequestBuilder \
	-enableCodeCoverage YES \
	test
