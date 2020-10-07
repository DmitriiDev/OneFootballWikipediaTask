
import Foundation
import XCTest

open class Feature: WikipediaTestCases {
    
    var exploreViewController: ExploreScreenVC!
    var historyViewController: HistoryScreenVC!
    var articlePageScreen: ArticlePageScreen!

    //Allows access to the 'app' scope
    var app: XCUIApplication {
        return App.shared.current()
    }

    open override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        skipTutorialScreen()
        exploreViewController = ExploreScreenVC(testCase: self)
        historyViewController = HistoryScreenVC(testCase: self)
        articlePageScreen = ArticlePageScreen(testCase: self)
    }

    open override func tearDown() {
        super.tearDown()
        app.terminate()
    }
    
    func skipTutorialScreen() {
        if app.staticTexts["The free encyclopedia"].exists {
            app.buttons["Skip"].tap()
            waitTime(second: 1.5)
        }
    }
}
