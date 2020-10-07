# Localization and Internationalization
As you'd expect, given [Wikipedia's mission](https://foundation.wikimedia.org/wiki/Mission_statement) and [core values](https://wikimediafoundation.org/about/jobs/our-values/), making the iOS app accessible & usable in as many languages as possible is very important to us.  This document is a quick overview of how we localize strings as well as the app itself.

## Localized strings
Localized strings which are used by the app are all kept in **Localizable.strings**.  We do not use localized string entries generated by Interface Builder.
### Adding a new localized string
**Please don't copy the code formatting on this page into source. It's formatted for readability on the web, not a source file.**
 
TL;DR: `WMFLocalizedStringWithDefaultValue` in Obj-C, `WMFLocalizedString` in Swift. 
 
Use keys that match this convention: `"places-filter-saved-articles-count"` - `"feature-name-info-about-the-string"`. **Do not change the keys for localized strings.** Unless absolutely necessary, keys should remain the same to prevent complications when syncing with TWN. 
 
**ALWAYS USE ORDERED STRING FORMAT SPECIFIERS** even if there's only one format specifier - For example: `%1$@` instead of `%@`, `%1$d` instead of `%d`, etc. For strings with multiple specifiers, increment the number: 
 
```swift
WMFLocalizedString(
	"places-search-articles-that-match",
	value:"%1$@ matching “%2$@”",
	comment:"A search suggestion for filtering the articles in the area by the search string. %1$@ is replaced by the filter ('Top articles' or 'Saved articles'). %2$@ is replaced with the search string"
)
````
 
#### Obj-C
`WMFLocalizedStringWithDefaultValue` matches the signature of `NSLocalizedStringWithDefaultValue` with one exception: the second parameter is an optional `siteURL` which will cause the returned localization to be in the language of the Wikipedia site at `siteURL`. For example, if `siteURL`'s host is `fr.wikipedia.org`, the returned string will be in French, even if the user's default language is English. This method matches the naming convention and number of parameters of `NSLocalizedStringWithDefaultValue` so that we can use the tools provided with Xcode for extracting string values from code automatically. Bundle should always be nil.

To get a string localized to the user's system default locale:
 
```objc
WMFLocalizedStringWithDefaultValue(
	@"article-about-title",
	nil,
	nil,
	@"About this article",
	@"The text that is displayed before the 'about' section at the bottom of an article"
);
```
 
To get a string localized to the language of the Wikipedia site indicated by `siteURL`:
 
```objc
WMFLocalizedStringWithDefaultValue(
	@"article-about-title",
	siteURL,
	nil,
	@"About this article",
	@"The text that is displayed before the 'about' section at the bottom of an article"
);
```
 
Plural string. Note the use of `localizedStringWithFormat` instead of `stringWithFormat`:
 
```objc
[NSString localizedStringWithFormat:
	WMFLocalizedStringWithDefaultValue(
		@"places-filter-saved-articles-count",
		nil,
		nil,
		@"{{PLURAL:%1$d|0=No saved places|%1$d place|%1$d places}} found",
		@"Describes how many saved articles are found in the saved articles filter - %1$d is replaced with the number of articles"
	),
	savedCount
)
```
 

#### Swift
In Swift, `WMFLocalizedString` matches the signature of `NSLocalizedString` with one exception - the second parameter is an optional `siteURL` which will cause the returned localization to be in the language of the Wikipedia site at `siteURL`. For example, if `siteURL`'s host is `fr.wikipedia.org`, the returned string will be in French, even if the user's default language is English. This method matches the naming convention and number of parameters of `NSLocalizedString` so that we can use the tools provided with Xcode for extracting string values from code automatically. You should always omit `bundle:`.

To get a string localized to the user's system default locale:
 
```swift
WMFLocalizedString(
	"places-filter-saved-articles",
	value:"Saved articles",
	comment:"Title of places search filter that searches saved articles"
)
```
 
To get a string localized to the language of the Wikipedia site indicated by `siteURL`:
 
```swift
WMFLocalizedString(
	"places-filter-saved-articles",
	siteURL:siteURL,
	value:"Saved articles",
	comment:"Title of places search filter that searches saved articles"
)
```
 
Plural string. Note the use of `localizedStringWithFormat` instead of `stringWithFormat`:
 
```swift
String.localizedStringWithFormat(
	WMFLocalizedString(
		"places-filter-saved-articles-count",
		value:"{{PLURAL:%1$d|0=No saved places|%1$d place|%1$d places}} found",
		comment:"Describes how many saved articles are found in the saved articles filter - %1$d is replaced with the number of articles"
	),
	savedCount
)
```
 

#### Plural syntax
Ensure the last variant is the "other" or "default" variant - in these cases it's %1$d places. Ensure the format specifier appears in the "other" variant. For example, `%1$d {{PLURAL:%1$d|place|places}}` is invalid, `{{PLURAL:%1$d|one place|%1$d places}}` is valid. **Plural strings can only contain one format specifier and only one plural per string at the moment (can be fixed by updating the localization script localization.swift).**

Without "zero" value:
```
{{PLURAL:%1$d|%1$d place|%1$d places}}
```

With "zero" value:
```
{{PLURAL:%1$d|0=You have no saved places|%1$d place|%1$d places}}
```

iOS doesn't support arbitrary numerals, only `0=`. For example, the `12=` translation in `{{PLURAL:%1$d|12=a dozen places|one place|%1$d places}}` can't be utilized on iOS. We allow users on Translatewiki to enter arbitrary numeral translations should there ever be a way to support it on iOS. 

For some languages, the singular form only applies to `n=1`. In these languages, we can map the Translatewiki's `1=` translations to the `one` key on iOS. For example, if n is 'years ago' and the translation is `1=Last year`, this works for languages where `one` is only ever used for `n=1`. For other languages, like Russian, the value for the `one` translation is used for certain numbers ending in 1. If we mapped the Russian Translatewiki value for `1=` to iOS's `one`, it would use the Russian equivalent of `Last year` for `n=1,11,21,31,...` years ago.

More information about iOS plural support can be found in [Apple's documentation for the stringsdict file format](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/StringsdictFileFormat/StringsdictFileFormat.html#//apple_ref/doc/uid/10000171i-CH16-SW1).

More information about MediaWiki plural support can be found [on Translatewiki's page for plural handling](https://translatewiki.net/wiki/Plural#Plural_in_MediaWiki).

 
### Translation workflow
1. Developer adds localized strings & comments to source using the methods described above.
2. Developer builds & runs the app. The app has two run script build phases that automatically extracts the strings from source and adds them to the appropriate localization bundles (for both the app `Wikipedia/iOS Native Localizations` & TWN `Wikipedia/Localizations`)
3. A script maintained by Translatewiki pulls the repo, reads the new strings from `Wikipedia/Localizations`, and adds them to Translatewiki
4. Volunteer translators translate the strings
5. The same script maintained by Translatewiki adds the new translations to the `Wikipedia/Localizations` folder in the TWN format and pushes the changes to the `twn` branch.
6. Our Jenkins `localization` job notices the changes to the twn branch, runs `scripts/localization import` which adds the iOS-formatted strings to `Wikipedia/iOS Native Localizations` and submits a PR.

### Script specifics
`scripts/localization_extract` extracts those strings from source, generates the `en` translation inside of `Wikipedia/iOS Native Localizations`.

`scripts/localization export` creates translatewiki-formatted `qqq` (comments only) and `en` (translations) inside of  `Wikipedia/Localizations` for Translatewiki to read.

Translatewiki's script reads the `Wikipedia/Localizations` `qqq` and `en` files, imports them to the wiki, and writes updated translations for other languages to `Wikipedia/Localizations`

`scripts/localization import` reads localizations from `Wikipedia/Localizations` and converts them into the iOS native format for `Wikipedia/iOS Native Localizations`

### Updating the localization script

Inside the main project, there's a `localization` target that is a Mac command line tool. You can edit the swift files used by this target (inside `Command Line Tools/Update Localizations/`) to update the localization script. Once you make changes, you can build and run the localization target through the `Update Localizations` scheme to re-run localizations and verify the output. Once you're done making changes, you need to archive the `localization` target which should copy the binary to `scripts/localizations` where it will be run with every build. Commit the changes to the script and the updated binary to the repo.

### Testing the app
#### Indications for international testing
Some important things to test across different locales (and operating systems):

- View layout in LTR & RTL environments
- custom `NSDateFormatter`
- Data models for horizontal navigation which need to be reversed when app is RTL (e.g. image gallery data sources)

Text overflow is also an important consideration when designing and implementing views, but doesn't require exhaustive locale testing.  Typically, it's sufficient to pass short, medium, and long strings to the test subject and verify proper wrapping, truncating, and/or layout behavior. See [`WMFArticleListCellVisualTests`](../WikipediaUnitTests/Code/WMFArticleListCellVisualTests.m) for an example.

#### Internationalization testing strategies
We run a certain set of tests across multiple operating systems and locales to verify business logic, and especially views, exhibit proper conditional behavior & appearance.  From a project setup standpoint, this involves:

- Running LTR tests on the main scheme on iOS 8 & 9 simulators
- Running RTL tests in a separate, **Wikipedia RTL** scheme on iOS 8 & 9 simulators

> The RTL locale & writing direction are forced in the scheme using launch arguments as described in the [Testing Right-to-Left Layouts](https://developer.apple.com/library/ios/documentation/MacOSX/Conceptual/BPInternational/TestingYourInternationalApp/TestingYourInternationalApp.html) section of Apple's "Internationalization and Localization Guide."

##### Unit tests
Ideally, the code should be factored in such a way that the relevant inputs (i.e. OS version and/or layout direction) can be passed explicitly during tests.  For example, given a method that returns a different value based on a layout direction:
``` objc
// Method invoked in unit tests w/ different layout directions
- (BOOL)methodDoingSomethingForWritingDirection:(UIUserInterfaceLayoutDirection)layoutDirection;

// Method invoked in application code, which passes the `[[UIApplication sharedApplication] userInterfaceLayoutDirection]`
// to the first argument of the first method signature.
- (BOOL)methodDoingSomethingForApplicationWritingDirection;
```

In other cases where this isn't feasible, you'll need to add your test class to the **WikipediaRTL** scheme so that the application itself is in RTL.  Also, you'll need to write assertions based on the writing direction and/or OS at runtime (see [`WMFGalleryDataSourceTests`](../WikipediaUnitTests/Code/WMFGalleryDataSourceTests.m#L36) for an example). [`NSDate+WMFPOTDTitleTests`](../WikipediaUnitTests/Code/NSDate+WMFPOTDTitleTests.m) are another example that rely on the application state, and verify that the date is not affected by the current locale—which `NSDateFormatter` implicitly uses when computing strings from dates.

##### Visual tests
Visual tests can be incredibly useful when verifying LTR & RTL responsiveness across multiple OS versions.  Write you visual test as you normally would, ensure it's added to the **WikipediaRTL** scheme, and use the `WMFSnapshotVerifyViewForOSAndWritingDirection` convenience macro to record & compare your view with a reference image dedicated to a specific OS version and writing direction.  See [`WMFTextualSaveButtonLayoutVisualTests`](../WikipediaUnitTests/Code/WMFTextualSaveButtonLayoutVisualTests.m) for an example.
