![Buildit](https://raw.githubusercontent.com/ilazakis/BuildIt/assets/logo.png)

[![Build Status](https://travis-ci.org/ilazakis/BuildIt.svg?branch=master)](https://travis-ci.org/ilazakis/BuildIt)
[![Test Coverage](https://codecov.io/gh/ilazakis/BuildIt/branch/master/graph/badge.svg)](https://codecov.io/gh/ilazakis/BuildIt)
[![Twitter](https://img.shields.io/badge/twitter-buildit-blue.svg?style=flat)](http://twitter.com/cocoapatterns)


Hassle-free and [URLRequest](https://developer.apple.com/reference/foundation/urlrequest) implementation for your REST endpoints (or any other use).

Request builder leverages the [URLComponents](https://developer.apple.com/reference/foundation/urlcomponents) structure and exposes a lightweight and easy to use API for URLRequest construction.

- [Features](#features)
- [Examples](#examples)
- [Requirements](#requirements)
- [Communication](#communication)

## Features
- [x] Expressive, consice request construction.
- [x] *JSON* -> *URLRequest*. Write your endpoint definitions in *JSON* config files, no need to repeat yourself all over your codebase.

## Examples

### Plain GET
`GET https://api.somehost.com/some/path/to/a/resource`

```swift 
let path = "some/path/to/a/resource"
let host = "api.somehost.com"
let request = builder.GET().https().host(host).path(path).build()
```

Actually, since `GET` and `https` are the default values for the HTTP method and scheme respectively, the above GET request can be written in an even less wordy way:

```swift
let request = builder.host(host).path(path).build()
```

### What about queries?
`GET https://api.somehost.com/some/path.json?name=joakim`

```swift
let request = builder.host(host).path(path)
                     .query(name: "name", value: "joakim")
                     .build()
```

## Requirements

- iOS 9.0+ / macOS 10.11+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.0+
- Swift 3.0+

## Communication

- If you'd like to **ask a question**, hit [Joakim](https://twitter.com/cocoapatterns) (@cocoapatterns).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.
