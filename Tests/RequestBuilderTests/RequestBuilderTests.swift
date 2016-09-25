import XCTest
import Foundation
@testable import RequestBuilder

class RequestBuilderTests: XCTestCase {
    
    // MARK: - Fixture path(s)
    let jsonFilePath = "./fixtures/requests.json"
    
    // MARK: - SUT
    
    let builder = RequestBuilder()
    
    // MARK: - Tests
    
    func testRequestDefaultsToGET() {
        
        // GIVEN
        let url = URL(string: "http://apple.com")
        let expectedRequest = URLRequest(url: url!)
        
        // WHEN
        let request = builder.url(url!).build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func testRequestPOST() {
        
        // GIVEN
        let url = URL(string: "http://apple.com")
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.httpMethod = "POST"
        
        // WHEN
        let request = builder.POST().http().host("apple.com").build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func testRequestDELETE() {
        
        // GIVEN
        let url = URL(string: "https://apple.com")
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.httpMethod = "DELETE"
        
        // WHEN
        let request = builder.DELETE().host("apple.com").build()
        
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func testRequestPUTAndHeaders() {
        
        // GIVEN
        let url = URL(string: "https://apple.com")
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.httpMethod = "PUT"
        expectedRequest.setValue("Some token", forHTTPHeaderField: "Authorization")
        
        // WHEN
        let request = builder.PUT().https().url(url!)
                        .setValue("Some token", for: "Authorization").build()
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func testRequestGETWithHeadersAndQueries() {
        
        // GIVEN
        let url = URL(string: "http://api.somehost.com/user_timeline.json?screen_name=cocoapatterns&include_rts=true")
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.setValue("Some token", forHTTPHeaderField: "Authorization")
        
        // WHEN
        let request = builder.GET()
                        .url(URL(string: "http://api.somehost.com/user_timeline.json")!)
                        .setValue("Some token", for: "Authorization")
                        .query(name: "screen_name", value: "cocoapatterns")
                        .query(name: "include_rts", value: "true")
                        .build()
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }
    
    func testRequestGETWithEmptyQuery() {
        
        // GIVEN
        let url = URL(string: "http://api.somehost.com/test.json?someQuery=")
        let expectedRequest = URLRequest(url: url!)
    
        // WHEN
        let request = builder.GET()
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
    
    // MARK: - Linux
    
    static var allTests : [(String, (RequestBuilderTests) -> () throws -> Void)] {
        return [
            ("testRequestDefaultsToGET", testRequestDefaultsToGET),
            ("testRequestPOST", testRequestPOST)
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