//
//  AppDelegate.h
//  PVVolumeBar Example
//
//  Created by Pedro Vieira on 02/03/14.
//  Copyright (c) 2014 Pedro Vieira. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PVVolumeBar.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, PVVolumeBarDelegate> {
    NSTimer *randomVolumesTimer;
}

@property (assign) IBOutlet NSWindow *window;
@property IBOutlet PVVolumeBar *volumeBar;
@property IBOutlet NSTextField *volumeBarPercentageTXT;
@property IBOutlet NSColorWell *borderColorWell;
@property IBOutlet NSTextField *volumePadsTXT;
@property IBOutlet NSSlider *volumeForLateralVolumePadsSlider;
@property IBOutlet NSTextField *spaceBetweenBorderAndBarTXT;
@property IBOutlet NSTextField *currentVolumeTXT;
@property IBOutlet NSSlider *currentVolumeSlider;
@property IBOutlet NSButton *randomVolumesAnimated;

- (IBAction)hasBorderChanged:(id)sender;
- (IBAction)borderColorChanged:(id)sender;
- (IBAction)barColorChanged:(id)sender;
- (IBAction)spaceBetweenBorderAndBarChanged:(id)sender;
- (IBAction)showLateralVolumePads:(id)sender;
- (IBAction)volumeForVolumePadsChanged:(id)sender;
- (IBAction)currentVolumeChanged:(id)sender;
- (IBAction)generateRandomVolumes:(id)sender;

@end
