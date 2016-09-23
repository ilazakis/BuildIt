#!/bin/bash

cp -r fixtures /private/tmp
xcodebuild -scheme RequestBuilder test
