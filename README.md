In my task I Used a native UI testing framework from Apple - "XCUITEST". It’s a black box tool with Apple supporting. I implemented test architecture with the ScreenObject Pattern (mobile analog of PageObject). this approach has both strengths and weaknesses.  
## Strengths: 
- it’s a black box. You can emulate exactly the same behavior of a user as it happens in the real life.  
- You don’t need to have much knowledge for writing such tests. Any Testers who have a little knowledge of how to code can use it. 
- Apple provides a recording tool. You can find a quick solution from the record of your interaction with the app.

## Weaknesses: 
- Your tests don’t isolate.  Your environment depends on the internet connection, states of the previous test run, old data. That why you can’t trust the tests on 100%
- tests are very slow. XCUITest Framework lives in a separate process and it should sync with the app after each interaction. It’s very time-consuming and the time for such interaction isn’t constant. It means that you don’t know the expected result - in the end, you have not reliable tests. 
- you can’t stub the network layer and prepare the data for testing. 

I thought to use Earlgray for the UITesting of the Wikipedia iOS App. Unfortunately, I faced issues while I wrote the Framework. As EarlGray is a Whitebox testing tool you able to write tests in the Unit Test target. (Your tests will be like a unit tests but with UI) 
It means that you should write many test doubles objects (DI, mock, Fake objects and etc) and it’s a very time-consuming process. I have a project which can show you all advantages of this approach. But I don’t speak that we should use just this approach. No, I think we should use both for a more efficient test process. 

Here you can find a short FAQ about my framework.  


## Feature.swift (Found in... WikipediaUITests > FrameworkUITests > Feature > Feature.swift)
This file essentually handles the App state (including setup and teardown).
This file is where you are required to explicitly add your screen objects (swift files) so that they can be
loaded and referenced when writing your test functions.

## App.swift (Found in... FrameworkUITests  > Helpers > App.swift) 
This file is the singleton in charge of creating XCUIApplication instance and managing the global app state.
This is created so the same application instance can be used across different pages of the app
and the instance we are calling is the one that got launched.

## WikipediaTestCases.swift (Found in... WikipediaUITests > WikipediaTestCases.swift)
This file acts as a sort of parent class, where the files are able to access other methods. 
You could actually get away with not having this and putting this capability elsewhere.

The file also includes a method that allows you to check the 'selected' state of an element. Particularly useful
when wanting to check if a button/switch is in the state you want it to be in.

## BaseScreen.swift (Found in... WikipediaUITests > Screens > BaseScreen.swift)
This is essentially the blueprint for what all the other screens/pages will be modelled on.
It contains a component that will allow for a 'trait' to be defined for each screen/page which adds a
pre-condition/check to ensure you're on the screen/page that you think you're on, i.e....
## UITestsOneFootballTask.swift (Found in... WikipediaUITests > UITestsOneFootballTask > UITestsOneFootballTask.swift)
Here collected 3 tests that check-in different user cases. All tests are independent from each other. 

## Building and Running

In the directory, run `./scripts/setup`.  Note: going to `scripts` directory and running `setup` will not work due to relative paths.

Running `scripts/setup` will setup your computer to build and run the app. The script assumes you have Xcode installed already. It will install [homebrew](https://brew.sh), [Carthage](https://github.com/Carthage/Carthage), and [ClangFormat](https://clang.llvm.org/docs/ClangFormat.html). It will also create a pre-commit hook that uses ClangFormat for linting.

After running `scripts/setup`, you should be able to open `Wikipedia.xcodeproj` and run the app on the iOS Simulator (using the **Wikipedia** scheme and target). If you encounter any issues, please don't hesitate to let us know via a [bug report](https://phabricator.wikimedia.org/maniphest/task/edit/form/1/?title=[BUG]&projects=wikipedia-ios-app-product-backlog,ios-app-bugs&description=%3D%3D%3D+How+many+times+were+you+able+to+reproduce+it?%0D%0A%0D%0A%3D%3D%3D+Steps+to+reproduce%0D%0A%23+%0D%0A%23+%0D%0A%23+%0D%0A%0D%0A%3D%3D%3D+Expected+results%0D%0A%0D%0A%3D%3D%3D+Actual+results%0D%0A%0D%0A%3D%3D%3D+Screenshots%0D%0A%0D%0A%3D%3D%3D+Environments+observed%0D%0A**App+version%3A+**+%0D%0A**OS+versions%3A**+%0D%0A**Device+model%3A**+%0D%0A**Device+language%3A**+%0D%0A%0D%0A%3D%3D%3D+Regression?+%0D%0A%0D%0A+Tag++task+with+%23Regression+%0A) or messaging us on IRC in #wikimedia-mobile on Freenode.

### Required dependencies
If you'd rather install the development prerequisites yourself without our script:

* [Xcode](https://itunes.apple.com/us/app/xcode/id497799835) - The easiest way to get Xcode is from the [App Store](https://itunes.apple.com/us/app/xcode/id497799835?mt=12), but you can also download it from [developer.apple.com](https://developer.apple.com/) if you have an AppleID registered with an Apple Developer account.
* [Carthage](https://github.com/Carthage/Carthage) - We check in prebuilt dependencies to simplify the initial build and run experience but you'll still need Carthage installed to allow Xcode to properly copy the frameworks into the built app. After you add, remove, or upgrade a dependency, you should run `scripts/carthage_update` to update the built dependencies.
* [ClangFormat](https://clang.llvm.org/docs/ClangFormat.html) - We use this for linting

