import XCTest

class ArtistsFeature: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchEnvironment = ["IsAutomationTestsRunning": "YES"]
        
        /**
         1. Uncomment app.startRecordingStubs(for: self) and run the test
         2. Observe the recorded JSON responses in the NetworkStubs dir, relative to the dir of this file
         3. Switch app.startRecordingStubs(for: self) for app.replayStubs(for: self)
         4. Re-run the test. The tests should now be running from the JSON stubs, rather than hitting the network
         5. If you're feeling mischievous, you can alter the content of the responses on disk and observe that they
         get reflected in the UI during tests
         */
        
//        app.startRecordingStubs(for: self)
//        app.replayStubs(for: self)
        
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    
    func test_canNavigateToArtistDetail_fromArtistsList() {
        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["Aphex Twin"].tap()
        sleep(4)
        app.navigationBars["NetworkStubbingBlog.ArtistDetailView"].buttons["Back"].tap()
    }
}
