import Foundation
import XCTest

class HistoryScreenVC: BaseScreen {
    
    var title: XCUIElement!
    var subTitle: XCUIElement!
    var tapbarTitle: XCUIElement!
    var cellsQuery: XCUIElementQuery!
    
    override init() {
        super.init()
        title = app.staticTexts["History"]
        tapbarTitle = app.tabBars["Tab Bar"].buttons["History"]
        cellsQuery = app.collectionViews.cells
        screenTraits.append(title)
        screenTraits.append(tapbarTitle)
    }
    
    func openHistoryButton() {
        app.tabBars["Tab Bar"].buttons["History"].tap()
    }
    
    func deleteTheCell(name: String) {
        let cellToDelete = cellsQuery.otherElements.containing(.staticText, identifier: name).element
        if cellToDelete.exists {
            cellToDelete.swipeLeft()
            cellToDelete/*@START_MENU_TOKEN@*/.buttons["swipe action delete"]/*[[".cells.buttons[\"swipe action delete\"]",".buttons[\"swipe action delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            
        } else {
            let upperCase = cellsQuery.otherElements.containing(.staticText, identifier: name.uppercased()).element
            upperCase.swipeLeft()
            upperCase.buttons["swipe action delete"].tap()
        }
    }
    
    func isCellExist(name: String) -> Bool {
        return cellsQuery.otherElements.containing(.staticText, identifier: name).element.exists
    }
    
    
    func clearAllHistory() {
        app.toolbars["Toolbar"].buttons["Clear"].tap()
        app.sheets.buttons["Yes, delete all"].tap()
    }
    
    func checkHistoryIsEmpty() -> Bool {
        return app.staticTexts["No history to show"].exists

    }
}




