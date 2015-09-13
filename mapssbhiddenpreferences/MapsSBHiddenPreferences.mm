#import "../MapsCommon.h"
#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>

@interface MapsSBHiddenPreferencesListController: PSListController
@end

@implementation MapsSBHiddenPreferencesListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"MapsSBHiddenPreferences" target:self] retain];
	}
	return _specifiers;
}

-(id) readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *mapsSettings = [NSDictionary dictionaryWithContentsOfFile:MapsPreferencePath];
	if (!mapsSettings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return mapsSettings[specifier.properties[@"key"]];
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:MapsPreferencePath]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:MapsPreferencePath atomically:YES];
	NSDictionary *mapsSettings = [NSDictionary dictionaryWithContentsOfFile:MapsPreferencePath];
	CFStringRef Post = (CFStringRef)specifier.properties[@"PostNotification"];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), Post, NULL, NULL, YES);
}
@end