import Foundation
import XCTest

class ArticlePageScreen: BaseScreen {
    
    var tapBar: XCUIElement!
    var tapBarButtonChangeLanguage: XCUIElement!
    
    override init() {
        super.init()
        tapBar = app.toolbars.matching(identifier: "Toolbar").element(boundBy: 1)
        tapBarButtonChangeLanguage = app.toolbars.matching(identifier: "Toolbar").buttons["Change language"]
        screenTraits.append(tapBarButtonChangeLanguage)
    }
    
}

