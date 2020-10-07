
import Foundation
import XCTest

open class WikipediaTestCases: XCTestCase {
    
    func waitUntilElementActive(element: XCUIElement, timeout: TimeInterval = 5) {
        let exists = NSPredicate(format: "exists == true AND hittable == true")
        self.expectation(for: exists, evaluatedWith: element, handler: nil)
        self.waitForExpectations(timeout: timeout, handler: nil)
        XCTAssert(element.exists)
    }
    
    func assertElementSelected(element: XCUIElement) {
        let selected = NSPredicate(format: "selected == true")
        self.expectation(for: selected, evaluatedWith: element, handler: nil)
        self.waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(element.isSelected)

    }
    
    func waitTime(second: Double) {
        let waitTimeExpectation = XCTestExpectation(description: "wait time")
        DispatchQueue.main.asyncAfter(deadline: .now() + second, execute: {
            waitTimeExpectation.fulfill()
        })
        wait(for: [waitTimeExpectation], timeout: second + 1.0)
    }
    
    

}
