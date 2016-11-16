
import Foundation

// MARK: - Convenience Constants

/// HTTP Method enumeration.
public enum HttpMethod: String {
    case GET, POST, PUT, DELETE
}

/// Schemes.
public enum Scheme: String {
    case http, https
}

// MARK: - Request builder

/// Request Builder.
///
/// - Note: Defaults to GET, https.
///
/// Vanilla implementation of the GOF `Builder` Design Pattern for `URLRequest` instances.
public class RequestBuilder {

    // MARK: - Private variables
    
    private var url: URL?
    
    fileprivate var host: String?
    
    fileprivate var path: String?
    
    fileprivate var body: Data?
    
    fileprivate var scheme = Scheme.https.rawValue
    
    fileprivate var httpMethod = HttpMethod.GET.rawValue
    
    fileprivate var httpHeaders: [String: String] = [:]
    
    fileprivate var queryItems: [URLQueryItem] = []
    
    // MARK: - Initialization
    
    public required init() {}
    
    // MARK: - API
    
    // MARK: - URL
    
    /// Sets the request URL.
    ///
    /// - parameter url: The URL.
    ///
    /// - returns: The builder instance.
    public func url(_ url: URL) -> RequestBuilder {
        self.url = url
        return self
    }
    
    // MARK: - HTTP Method
    
    /// HTTP GET.
    ///
    /// - returns: The builder instance.
    public func GET() -> RequestBuilder {
        return method(.GET)
    }
    
    /// HTTP POST.
    ///
    /// - returns: The builder instance.
    public func POST() -> RequestBuilder {
        return method(.POST)
    }
    
    /// HTTP PUT.
    ///
    /// - returns: The builder instance.
    public func PUT() -> RequestBuilder {
        return method(.PUT)
    }
    
    /// HTTP DELETE.
    ///
    /// - returns: The builder instance.
    public func DELETE() -> RequestBuilder {
        return method(.DELETE)
    }
    
    // MARK: - URL scheme
    
    /// The URL scheme.
    ///
    /// - returns: The builder instance.
    public func scheme(_ scheme: String) -> RequestBuilder {
        self.scheme = scheme
        return self
    }
    
    /// Plain http.
    ///
    /// - returns: The builder instance.
    public func http() -> RequestBuilder {
        return scheme(Scheme.http.rawValue)
    }

    /// Secure http.
    ///
    /// - returns: The builder instance.
    public func https() -> RequestBuilder {
        return scheme(Scheme.https.rawValue)
    }
    
    // MARK: - HTTP Headers
    
    /// Sets a value-HTTP header pair.
    ///
    /// - parameter value: The value to use for the header.
    /// - parameter field: The header for which the value is being changed.
    /// - returns: The builder instance.
    public func setValue(_ value: String, for headerField: String) -> RequestBuilder {
        let existingValue = self.httpHeaders[headerField]
        self.httpHeaders[headerField] = existingValue == nil ? value : existingValue! + "," + value
        return self
    }
    
    // MARK: - Queries
    
    /// Adds a query key-value pair to the request.
    ///
    /// - note: This method maps the passed key-value pair
    ///   to a `URLQueryItem` so expect the same behaviors for
    ///   edge cases as the ones described for `NSURLComponenent`'s
    ///   `queryItems` array.
    ///
    /// - parameter name:   The query name e.g. `username`.
    /// - parameter value: The quey value e.g. `Joakim`.
    ///
    /// - returns: The builder instance.
    public func query(name: String, value: String) -> RequestBuilder {
        let query = URLQueryItem(name: name, value: value)
        queryItems.append(query)
        return self
    }
    
    // MARK: - Host
    
    /// The host subcomponent.
    ///
    /// - parameter name: The host name e.g. `api.somehost.com`
    ///
    /// - returns: The builder instance.
    public func host(_ name: String) -> RequestBuilder {
        host = name
        return self
    }
    
    // MARK: - Path
    
    /// The path subcomponent.
    ///
    /// - Note: You can omit the prefixing forward slash i.e.
    ///   `some/path` and `/some/path` will both be respected.
    ///
    /// - parameter name: The path name e.g. "some/path/to/a/resource"
    ///
    /// - returns: The builder instance.
    public func path(_ name: String) -> RequestBuilder {
        path = name
        return self
    }
    
    // MARK: - Body
    
    /// Adds the request's body.
    ///
    /// - parameter body: The body payload.
    ///
    /// - returns: The builder instance.
    public func body(_ body: Data) -> RequestBuilder {
        self.body = body
        return self
    }
    
    // MARK: - Build method.
    
    /// The build method.
    /// Call this method **last**, after you have called 
    /// all other methods to configure the URL request.
    ///
    /// - returns: A fully initialized `URLRequest` instance 
    ///            or nil if initialization failed.
    public func build() -> URLRequest? {
        
        // Use a URL if one was provided by the client.
        var components: URLComponents?
        if url != nil {
            components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        }
        else { // else try to build one from `scheme`, `host` and `path`
            components = URLComponents()
            components?.host = host
            components?.scheme = scheme
            if path == nil {
                components?.path = ""
            }
            else {
                components?.path = path!.hasPrefix("/") ? path! : "/" + path!
            }
        }
        
        // Append any potential queries
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        
        // By this point, we must have request and a host.
        guard let url = components?.url, components?.host != nil else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = httpHeaders
        return request
    }
}

// MARK: - Extension(s)

// MARK: - `HTTP method` `designated` method.

fileprivate extension RequestBuilder {

    /// HTTP method setter helper.
    ///
    /// This is the `designated` method that all the API `convenience`
    /// methods (`GET()`, `POST()` etc) end up calling to set the
    /// `HTTP method` on the built request.
    ///
    /// - parameter httpMethod: The HTTP method.
    ///
    /// - returns: The builder instance.
    fileprivate func method(_ httpMethod: HttpMethod) -> RequestBuilder {
        self.httpMethod = httpMethod.rawValue
        return self
    }
}

// MARK: - Build from JSON

extension RequestBuilder {

    private enum Keys: String {
        case host, scheme, path, headers, queries, httpMethod
    }
    
    public func request(_ name: String, from jsonObject: [String: Any]) -> RequestBuilder {
        parseComponents(from: jsonObject, for: name)
        return self
    }
    
    private func parseComponents(from jsonObject: [String: Any]) {
        host = parseHost(from: jsonObject) ?? host
        path = parsePath(from: jsonObject) ?? path
        scheme = parseScheme(from: jsonObject)
        httpMethod = parseMethod(from: jsonObject)
        queryItems = parseQueries(from: jsonObject)
        
        let headers = parseHeaders(from: jsonObject)
        for (key, value) in headers {
            _ = setValue(value, for: key)
        }
    }
    
    private func parseComponents(from jsonObject: [String: Any], for requestIdentifier: String) {
        parseComponents(from: jsonObject) // "top level / common" components
        guard let requestDict = jsonObject[requestIdentifier] as? [String: Any] else { return }
        parseComponents(from: requestDict) // request specific overrides
    }
    
    private func parseHost(from jsonObject: [String: Any]) -> String? {
        return jsonObject[Keys.host.rawValue] as? String
    }
    
    private func parsePath(from jsonObject: [String: Any]) -> String? {
        return jsonObject[Keys.path.rawValue] as? String
    }
    
    private func parseScheme(from jsonObject: [String: Any]) -> String {
        return jsonObject[Keys.scheme.rawValue] as? String ?? Scheme.https.rawValue
    }
    
    private func parseMethod(from jsonObject: [String: Any]) -> String {
        return jsonObject[Keys.httpMethod.rawValue] as? String ?? HttpMethod.GET.rawValue
    }
    
    private func parseQueries(from jsonObject: [String: Any]) -> [URLQueryItem] {
        guard let queriesDict = jsonObject[Keys.queries.rawValue] as? [[String: Any]] else { return [] }
        
        var queries: [URLQueryItem] = []
        for queryDict in queriesDict {
            guard let key = queryDict.keys.first else { break }
            let value = queryDict[key]
            queries.append(URLQueryItem(name: key, value: value as? String))
        }
        return queries
    }

    private func parseHeaders(from jsonObject: [String: Any]) -> [String: String] {
        return jsonObject[Keys.headers.rawValue] as? [String: String] ?? [:]
    }
}
