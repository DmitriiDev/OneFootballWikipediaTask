
import Foundation
import XCTest

open class BaseScreen: NSObject {
    
    internal let app: XCUIApplication
    internal var testCase: WikipediaTestCases?
    internal var screenTraits: [XCUIElement]
    
    override init() {
        app = App.shared.current()
        screenTraits = []
        super.init()
    }
    
    convenience init(testCase inTestCase: WikipediaTestCases) {
        self.init()
        testCase = inTestCase
    }
        
    //Userful method to check for a specific element, so that we know we are on that screen.
    func isScreenShown(timeout: TimeInterval = 10) {
        guard screenTraits.count > 0 else {
            return
        }
        if let element = screenTraits.first {
            testCase?.waitUntilElementActive(element: element, timeout: timeout)
        }
    }
    
    func skipTutorialScreen() {
        if app.staticTexts["The free encyclopedia"].exists {
            app.buttons["Skip"].tap()
        }
    }

}
