//
//  Tweak.xm
//
//  Created by Cole Cabral on 2015-09-06.
//  Copyright (c) 2015 Cole Cabral. All rights reserved.
//
//  Thanks angelXwind for the examples in PreferenceOrganizer2!


#import "MapsCommon.h"



#define MapsPreferencePath @"/User/Library/Preferences/com.cabralcole.mapssbhidden.plist"

#define MapsObserver(funcToCall, listener) CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)funcToCall, CFSTR(listener), NULL, CFNotificationSuspensionBehaviorCoalesce);


static BOOL MapsSBHiddenOption;

static void mapsInitPrefs() {
	NSDictionary *mapsSettings = [NSDictionary dictionaryWithContentsOfFile:MapsPreferencePath];
	NSNumber *mapsOptionKey = mapsSettings[@"enabled"];
	MapsSBHiddenOption = mapsOptionKey ? [mapsOptionKey boolValue] :1;
}

static void killMaps() {
	system("/usr/bin/killall -9 Maps");
}

%ctor {
	mapsInitPrefs();
	MapsObserver (mapsInitPrefs, "com.cabralcole.mapssbhidden-PreferencesChanged");
}


%hook MainChromeViewController

- (_Bool)prefersStatusBarHidden {	// Hides status bar
	if (MapsSBHiddenOption) {
			return 1;
		}	else {
			return 0;
	}
}

%end