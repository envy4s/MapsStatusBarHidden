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

-(void) killMaps{
	UIAlertView *suicidalMaps = [[UIAlertView alloc] initWithTitle:@"Note"
		message:@"The Maps app will now kill itself to apply changes."
		delegate:self
		cancelButtonTitle:@"OK"
		otherButtonTitles:nil];
	[suicidalMaps show];
	[suicidalMaps release];
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		system("/usr/bin/killall -9 Maps");
	}
}

@interface PSTableCell : UITableViewCell
@end
 
@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(PSSpecifier *)specifier;
- (CGFloat)preferredHeightForWidth:(CGFloat)width;
@end
 
@interface CustomCell : PSTableCell <PreferencesTableCustomView> {
	UILabel *_label;
	UIImage *backImage = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/MapsSBHiddenPreferences.bundle/mapsstatusbarhiddenpreferences@2x.png"];
}
@end
 
@implementation CustomCell
- (id)initWithSpecifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
	if (self) {
		_label = [[UILabel alloc] initWithFrame:[self frame]];
		[_label setLineBreakMode:UILineBreakModeWordWrap];
		[_label setNumberOfLines:0];
		[_label setText:@"MapsSBHidden"];
		[_label setBackgroundColor:[UIColor clearColor]];
		[_label setShadowColor:[UIColor whiteColor]];
		[_label setShadowOffset:CGSizeMake(0,1)];
		[_label setTextAlignment:UITextAlignmentCenter];
 
		[self addSubview:_label];
		[_label release];
	}
	return self;
}
 
- (CGFloat)preferredHeightForWidth:(CGFloat)width {
	// Return a custom cell height.
	return 60.f;
}
@end
