import Foundation
import XCTest


final class App {
    
    //Any app logic, i.e. terminate, etc
    //Any logic to handle things like GPS, Language, Environment setup can be initiated here.

    static let shared = App()
    
    private var currentApp: XCUIApplication?
    
    private init () {}
    
    func terminate() {
        currentApp?.terminate()
        currentApp = nil
    }
    
    func current() -> XCUIApplication {
        if let app =  currentApp {
            return app
        }
        
        let app = XCUIApplication()
        currentApp = app
        return app
    }
    
    func startApp() {
        XCUIApplication().launch()
    }
    
}
