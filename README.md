# BuildIt

[![Build Status](https://travis-ci.org/ilazakis/BuildIt.svg?branch=master)](https://travis-ci.org/ilazakis/BuildIt)
[![Twitter](https://img.shields.io/badge/twitter-buildit-blue.svg?style=flat)](http://twitter.com/cocoapoatterns)


[GOF's Builder](https://en.wikipedia.org/wiki/Builder_pattern) implementation for Cocoa's [URLRequest](https://developer.apple.com/reference/foundation/urlrequest) in Swift.

Request builder leverages the [URLComponents](https://developer.apple.com/reference/foundation/urlcomponents) structure and exposes a lightweight and easy to use API for URLRequest construction.

# Examples

### Plain GET
`GET https://api.somehost.com/some/path/to/a/resource`

```` 
let path = "some/path/to/a/resource"
let host = "api.somehost.com"
let request = builder.GET().https().host(host).path(path).build()
````

Actually, since `GET` and `https` are the default values for the HTTP method and scheme respectively, the above GET request can be written in an even less wordy way:

````
let request = builder.host(host).path(path).build()
````

### What about queries?
`GET https://api.somehost.com/some/path.json?name=joakim`

````
let request = builder.host(host).path(path)
                     .query(name: "name", value: "joakim")
                     .build()
````
