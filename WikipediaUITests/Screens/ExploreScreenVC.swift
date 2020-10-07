
import Foundation
import XCTest

class ExploreScreenVC: BaseScreen {

    var title: XCUIElement!
    var searField: XCUIElement!
    var subTitle: XCUIElement!
    var tapbarTitle: XCUIElement!
    
    var cellsQuery: XCUIElementQuery!
    var cellElement: XCUIElement!

    override init() {
    super.init()
    
    title = app.staticTexts["Today"]
    searField = app.searchFields["Search Wikipedia"]
    tapbarTitle = app.tabBars["Tab Bar"].buttons["History"]
    cellsQuery = app.collectionViews.cells
    
//    screenTraits.append(title)
    screenTraits.append(searField)
//    screenTraits.append(tapbarTitle)
    }
    
    func pasteTextToTheSearchField(nameOfThePage: String) {
        UIPasteboard.general.string = nameOfThePage
        app.searchFields["Search Wikipedia"].tap()
        app.searchFields["Search Wikipedia"].doubleTap()
        app.menuItems.element(boundBy: 0).tap()
    }
    
    func openThePage(nameOfPage: String) {
        
        let cell = cellsQuery.staticTexts[nameOfPage]
        print("=========================")
        print(nameOfPage)
        print(cell.exists)
        print("=========================")
        if cell.exists {
            cell.tap()
        } else {
            let cellUpperCase = cellsQuery.staticTexts[nameOfPage.uppercased()]
            cellUpperCase.tap()
        }
    }
    
    func typeASearchRequst(name: String) {
        app.searchFields["Search Wikipedia"].tap()
        for char in name {
            let charKey = app.keys["\(char)"]
            charKey.tap()
        }
    }
    
    func pressBackButton() {
        app.navigationBars["W"].buttons["Search"].tap()
    }
    
    func pressCancelButton() {
//        let verticalScrollBar3PagesCollectionView = app.collectionViews.containing(.other, identifier:"Vertical scroll bar, 3 pages").element
//        verticalScrollBar3PagesCollectionView.tap()
        app.buttons["Cancel"].tap()

    }
    
}
