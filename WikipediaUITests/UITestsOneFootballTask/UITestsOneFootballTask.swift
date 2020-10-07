import XCTest

class UITestsVokuev: Feature {

    let searchWord = "Qa"
    let serchWordFootball = "Football"
    func test_a_searchQAArticle_OpenFirstPge() {
        // GIVEN
        exploreViewController.isScreenShown()
        
        // WHEN
        exploreViewController.pasteTextToTheSearchField(nameOfThePage: searchWord)
        
        // THEN
        waitTime(second: 1)
        exploreViewController.openThePage(nameOfPage: searchWord)
        
        // "check that article opened"
        articlePageScreen.isScreenShown()
        
        // "go back to the search result"
        exploreViewController.pressBackButton()
    }
    
    func test_b_removeArticleFromTheHistoryList() {
        // GIVEN
        exploreViewController.typeASearchRequst(name: searchWord)
        
        // WHEN
        waitTime(second: 1)
        exploreViewController.openThePage(nameOfPage: searchWord)
        
        // THEN
        exploreViewController.pressBackButton()
        exploreViewController.pressCancelButton()

        
        // WHEN
        historyViewController.openHistoryButton()
        historyViewController.isScreenShown()
        
        // THEN
        historyViewController.deleteTheCell(name: searchWord)
        XCTAssertFalse(historyViewController.isCellExist(name: searchWord))
    }
    
    func test_c_openTheArticle_returnToTheMainScree_removeAllHistory() {
        // GIVEN
        exploreViewController.isScreenShown()
        exploreViewController.pasteTextToTheSearchField(nameOfThePage: serchWordFootball)
        
        // THEN Open the article. We can't open the article right away because we bound by time for response and synchronization of the XCUITEST framework and UIKit
        waitTime(second: 1)
        exploreViewController.openThePage(nameOfPage: "Group of related team sports")
        // "check that article opened"
        articlePageScreen.isScreenShown()
        
        
        exploreViewController.pressBackButton()
        exploreViewController.pressCancelButton()
        
        // GIVEN Open History screen
        historyViewController.openHistoryButton()
        
        // THEN check that History screen is shown
        historyViewController.isScreenShown()
        // When Remove all History and check that it's empty
        historyViewController.clearAllHistory()
        XCTAssertTrue(historyViewController.checkHistoryIsEmpty(), "history isn't empty")
    }
    
    
}
