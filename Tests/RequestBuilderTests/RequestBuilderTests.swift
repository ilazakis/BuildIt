import XCTest
import Foundation
@testable import RequestBuilder

class RequestBuilderTests: XCTestCase {
    
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
        let request = builder.POST()
                        .url(url!)
                        .build()
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
        let request = builder.PUT()
                        .url(url!)
                        .setValue("Some token", for: "Authorization")
                        .build()
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
        let url = URL(string: "https://api.somehost.com/some/path?query=queryValue&someOtherQuery=queryValue")
        var expectedRequest = URLRequest(url: url!)
        expectedRequest.setValue("text/html,application/xhtml+xml", forHTTPHeaderField: "Accept")
        expectedRequest.setValue("en-IE", forHTTPHeaderField: "Accept-Language")
        
        // WHEN
        let fixtureURL = URL(fileURLWithPath: "./fixtures/requests.json")
        let data = try! Data(contentsOf: fixtureURL, options: [])
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let request = builder
                        .request(from: json)
                        .query(name: "query", value: "queryValue")
                        .query(name: "someOtherQuery", value: "queryValue").build()
        // THEN
        XCTAssertEqual(request, expectedRequest)
    }

    // MARK: - Linux
    
    static var allTests : [(String, (RequestBuilderTests) -> () throws -> Void)] {
        return [
            ("testRequestDefaultsToGET", testRequestDefaultsToGET),
            ("testRequestPOST", testRequestPOST)
        ]
    }
}
