import XCTest
@testable import RequestBuilder
import Foundation

class RequestBuilderTests: XCTestCase {
    
    // MARK: - SUT
    
    let builder = RequestBuilder()
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
    }
    
    func testRequestGET() {
        
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
        let url = URL(string: "http://apple.com")
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

    // MARK: - Linux
    
    static var allTests : [(String, (RequestBuilderTests) -> () throws -> Void)] {
        return [
            ("testRequestGET", testRequestGET), ("testRequestPOST", testRequestPOST)
        ]
    }
}
