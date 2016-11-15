![Buildit](https://raw.githubusercontent.com/ilazakis/BuildIt/assets/logo.png)

[![Build Status](https://travis-ci.org/ilazakis/BuildIt.svg?branch=master)](https://travis-ci.org/ilazakis/BuildIt)
[![Test Coverage](https://codecov.io/gh/ilazakis/BuildIt/branch/master/graph/badge.svg)](https://codecov.io/gh/ilazakis/BuildIt)
[![Twitter](https://img.shields.io/badge/twitter-buildit-blue.svg?style=flat)](http://twitter.com/cocoapatterns)


Hassle-free and concise [URLRequest](https://developer.apple.com/reference/foundation/urlrequest) implementation for your REST endpoints (or any other use) through a lightweight and easy to use API.

- [Features](#features)
- [Usage](#usage)
- [Installation](#installation)
- [Requirements](#requirements)
- [Communication](#communication)

## Features
- [x] Expressive, consice request construction.
- [x] *JSON* -> *URLRequest*. Write your endpoint definitions in *JSON* config files, no need to repeat yourself all over your codebase.

## Usage

#### Using a *JSON* file for endpoint definitions

The main reason you are reading this. Define your endpoints in *JSON* files instead of repeating yourself everywhere you encounter a *URL Request*. Given the following *JSON* file,

```json
{
    "ReposPOST": {
        "host": "api.github.com",
        "path": "user/repos",
        "httpMethod": "POST",
        "headers": {
           "Accept": "application/vnd.github.v3+json",
            "User-Agent": "Some-User-Agent"
        }
    }
}
````

all you need to generate your request is the name of the request as defined in the *JSON* file ("ReposPOST") and the name of the *JSON* file itself:

```swift 
let request = builder.request("ReposPOST", from: "json_filename").build()
````

That's the equivalent of doing:

```swift
let url = URL(string: "https://api.github.com/user/repos")
var request = URLRequest(url: url!)
request.httpMethod = "POST"
request.setValue("Some-User-Agent", forHTTPHeaderField: "User-Agent")
request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
````

More wordy, requires code changes and, most importantly, usually leads to multiple copies of the same setup code. Which leads us naturally to the first question that comes to mind:

> What if I have a large number of requests that share many *URL* components like *host* or *path*?

Place all common *URL* components as top-level entries in your *JSON* file:

```json
{
	"host": "api.github.com",
    "path": "user/repos",
    "headers": {
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "Some-User-Agent"
    },
    "ReposGET": {
		"path": "user/repos",
        "queries": [
            { "page": "2" },
            { "per_page": "100" }
        ]
	},
	"ReposPOST": {
        "httpMethod": "POST",
        "headers": {
            "Time-Zone": "Europe/Berlin"
        }
    }
}
```

*host*, *path* and *headers* above will be re-used for all requests in that file. Notice how *ReposPOST* also defines a *header* of its own ("Time-Zone"); that header will be appended to the default ones. You can also overwrite a header with a value specific to a particular request.

#### TODO: Dynamic values (queries, headers, body)

#### Without *JSON*
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

#### What about queries?
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

## Installation


## Communication

- If you'd like to **ask a question**, hit [Joakim](https://twitter.com/cocoapatterns) (@cocoapatterns).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.
