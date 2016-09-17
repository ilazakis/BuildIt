
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
/// - Note: Defaults to GET
///
/// A vanilla GOF implementation of the `Builder`
public class RequestBuilder {

    // MARK: - Private variables
    
    private var url: URL?
    
    private var scheme = Scheme.http.rawValue
    
    fileprivate var httpMethod = HttpMethod.GET.rawValue
    
    private var httpHeaders: [String: String] = [:]
    
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
    public func setValue(_ value: String?,
                         for headerField: String) -> RequestBuilder {
        self.httpHeaders[headerField] = value
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
        guard url != nil else { return nil }
        
        //
        var components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        components?.scheme = scheme
        
        //
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = httpHeaders
        
        return request
    }
}

fileprivate extension RequestBuilder {

    /// HTTP method setter helper.
    ///
    /// - parameter httpMethod: The HTTP method.
    ///
    /// - returns: The builder instnce.
    fileprivate func method(_ httpMethod: HttpMethod) -> RequestBuilder {
        self.httpMethod = httpMethod.rawValue
        return self
    }
}
