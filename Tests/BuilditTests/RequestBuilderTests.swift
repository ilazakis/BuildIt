import XCTest
import Foundation
@testable import Buildit

class RequestBuilderTests: XCTestCase {
    
    // MARK: - Fixture path(s)
    let jsonFilePath = "./fixtures/requests.json"
    let jsonTopLevelFilePath = "./fixtures/requests_top_level.json"
    
    // MARK: - Requests stub values
    let host = "api.github.com"
    let path = "user/repos"
    let pathWithForwardSlash = "/user/repos"
    let urlString = "https://api.github.com"
    let url = URL(string: "https://api.github.com")
    
    let urlWithPath = URL(string: "https://api.github.com/user/repos")
    let urlWithEmptyQuery = URL(string: "https://api.github.com/user/repos?page=")
    let urlWithPathAndQueries = URL(string: "https://api.github.com/user/repos?page=2&per_page=100")
    let urlNonSecureWithPathAndQueries = URL(string: "http://api.github.com/user/repos?page=2&per_page=100")
    let query1Key = "page"
    let query1Value = "2"
    let query2Key = "per_page"
    let query2Value = "100"
    
    let bodyDictionary: [String: Any] = ["somekey" : "some value", "some other key" : 5]
    
    let header1Key = "User-Agent"
    let header1Value = "Some user agent"
    
    let PUT = "PUT"
    let POST = "POST"
    let DELETE = "DELETE"
    
    // MARK: - SUT
    let builder = RequestBuilder()
    
    // MARK: - Tests
    
    func test_UsingUrl_ImplicitGET_ImplicitHttps() {
        
        // GIVEN
        let expectedRequest = URLRequest(url: url!)
        
        // WHEN
        let request = builder
            .url(url!)
            .build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func test_UsingUrl_ExplicitGET_ExplicitHttps() {
        
        // GIVEN
        let expectedRequest = URLRequest(url: url!)
        
        // WHEN
        let request = builder
            .GET()
            .https()
            .url(url!)
            .build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func test_UsingHost_POST_ImplicitHttps() {
        
        // GIVEN
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.httpMethod = POST
        
        // WHEN
        let request = builder
            .POST()
            .host(host)
            .build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func test_UsingHost_DELETE() {
        
        // GIVEN
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.httpMethod = DELETE
        
        // WHEN
        let request = builder
            .DELETE()
            .host(host)
            .build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func test_UsingHost_POST_ImplicitHttps_Body() {
        
        // GIVEN
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.httpMethod = POST
        let body = try! JSONSerialization.data(withJSONObject: bodyDictionary)
        expectedRequest.httpBody = body
        
        // WHEN
        let request = builder
            .POST()
            .host(host)
            .body(body)
            .build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func test_UsingUrl_PUT_Headers() {
        
        // GIVEN
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.httpMethod = PUT
        expectedRequest.setValue(header1Value, forHTTPHeaderField: header1Key)
        
        // WHEN
        let request = builder.PUT().url(url!)
            .setValue(header1Value, for: header1Key)
            .build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func test_UsingHostAndPath_ImplicitGET_Headers_Queries() {
        
        // GIVEN
        var expectedRequest = URLRequest(url: urlWithPathAndQueries!)
        expectedRequest.setValue(header1Value, forHTTPHeaderField: header1Key)
        
        // WHEN
        let request = builder.host(host).path(path)
            .setValue(header1Value, for: header1Key)
            .query(name: query1Key, value: query1Value)
            .query(name: query2Key, value: query2Value)
            .build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func test_NonSecureHTTP_UsingHostAndPath_ImplicitGET_Headers_Queries() {
        
        // GIVEN
        var expectedRequest = URLRequest(url: urlNonSecureWithPathAndQueries!)
        expectedRequest.setValue(header1Value, forHTTPHeaderField: header1Key)
        
        // WHEN
        let request = builder.http().host(host).path(pathWithForwardSlash)
            .setValue(header1Value, for: header1Key)
            .query(name: query1Key, value: query1Value)
            .query(name: query2Key, value: query2Value)
            .build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }

    
    func test_UsingUrl_ImplicitGET_EmptyQuery() {
        
        // GIVEN
        let url = URL(string: "http://api.somehost.com/test.json?someQuery=")
        let expectedRequest = URLRequest(url: url!)
    
        // WHEN
        let request = builder
                        .url(URL(string: "http://api.somehost.com/test.json")!)
                        .query(name: "someQuery", value: "")
                        .build()
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func testHostAndPath() {
        
        // GIVEN
        let url = URL(string: "https://api.somehost.com/some/path")
        let expectedRequest = URLRequest(url: url!)
        
        // WHEN
        let request = builder.host("api.somehost.com").path("some/path").build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func testHeaderWithMultipleValues() {
        
        // GIVEN
        let url = URL(string: "https://api.somehost.com/some/path")
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.setValue("text/html,application/xhtml+xml", forHTTPHeaderField: "Accept")
        
        // WHEN
        let request = builder
                        .host("api.somehost.com")
                        .path("some/path")
                        .setValue("text/html", for: "Accept")
                        .setValue("application/xhtml+xml", for: "Accept").build()
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    // MARK: - Build from JSON tests
    
    func testGetJSON() {
        
        // GIVEN
        let url = URL(string: "https://api.somehost.com/some/path")
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.setValue("text/html,application/xhtml+xml", forHTTPHeaderField: "Accept")
        expectedRequest.setValue("en-IE", forHTTPHeaderField: "Accept-Language")
        
        // WHEN
        let fixture = json(at: jsonFilePath)
        let request = builder.request("RequestGET", from: fixture).build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func testPostJsonWithEmbeddedQueries() {
        
        // GIVEN
        let url = URL(string: "https://api.somehost.com/someResource?query=5&someOtherQuery=queryValue")
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.httpMethod = "POST"
        
        // WHEN
        let fixture = json(at: jsonFilePath)
        let request = builder.request("RequestPOST", from: fixture).build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func testNonexistentRequestNameReturnsNil() {
        
        // GIVEN
        let requestName = "RequestNameWhichIsNotInOurJsonFile"
        
        // WHEN
        let fixture = json(at: jsonFilePath)
        let request = builder.request(requestName, from: fixture).build()
        
        // THEN
        XCTAssertNil(request)
    }
    
    func test_UsingTopLevelJson_ReposGET() {
        
        // GIVEN
        let requestName = "ReposGET"
        var expectedRequest = URLRequest(url: urlWithPathAndQueries!)
        expectedRequest.setValue("Some-User-Agent", forHTTPHeaderField: "User-Agent")
        expectedRequest.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        // WHEN
        let fixture = json(at: jsonTopLevelFilePath)
        let request = builder.request(requestName, from: fixture).build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func test_UsingTopLevelJson_ReposPOST() {
        
        // GIVEN
        let requestName = "ReposPOST"
        var expectedRequest = URLRequest(url: urlWithPath!)
        expectedRequest.httpMethod = "POST"
        expectedRequest.setValue("Some-User-Agent", forHTTPHeaderField: "User-Agent")
        expectedRequest.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        expectedRequest.setValue("Europe/Berlin", forHTTPHeaderField: "Time-Zone")
        
        
        // WHEN
        let fixture = json(at: jsonTopLevelFilePath)
        let request = builder.request(requestName, from: fixture).build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    // MARK: - Linux
    
    static var allTests : [(String, (RequestBuilderTests) -> () throws -> Void)] {
        return [
           // ("testRequestUsingUrlGetImplicit", testRequestUsingUrlGetImplicit),
           // ("testRequestUsingUrlGetExplicit", testRequestUsingUrlGetExplicit)
        ]
    }
}

// MARK: - Helpers

extension RequestBuilderTests {

    func json(at path: String) -> [String: Any] {
        let fixtureURL = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: fixtureURL, options: [])
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        return json
    }
}
