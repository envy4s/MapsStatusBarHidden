#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

#define MapsPreferencePath @"/User/Library/Preferences/com.cabralcole.mapssbhidden.plist"

#define MapsStringPref(var, key, default) do { \
	NSString *key = MapsSettings[@STRINGIFY(key)]; \
	var = key ? key : default; \
} while (0)

#define MapsSyncPrefs() \
	NSLog(@"MapsSBHidden: [INFO] MapsSBHidden (C) 2015 cole cabral (ca13ra1)"); \
	NSDictionary *MapsSettings = [NSDictionary dictionaryWithContentsOfFile:MapsPreferencePath];