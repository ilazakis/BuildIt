#!/bin/bash

rm -rf /private/tmp/fixtures # copy fixtures/resources to make available to tests
cp -r fixtures /private/tmp
swift package generate-xcodeproj
xcodebuild \ 
	-scheme RequestBuilder \
	-enableCodeCoverage YES \
	-destination 'platform=iOS Simulator,name=iPhone 7,OS=10.0' \
	test
