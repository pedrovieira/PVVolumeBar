//
//  AppDelegate.m
//  PVVolumeBar Example
//
//  Created by Pedro Vieira on 02/03/14.
//  Copyright (c) 2014 Pedro Vieira. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _volumeBar.currentVolume = 0.5;
    _volumeBar.delegate = self;
    _volumeBar.showsLateralVolumePads = YES;
    _volumeBar.volumeForLateralVolumePads = 0.75;
    _volumeBarPercentageTXT.stringValue = @"50%";
}

- (IBAction)hasBorderChanged:(id)sender {
    if ([sender state] == NSOnState){
        _volumeBar.hasBorder = YES;
        [_borderColorWell setEnabled:YES];
        
    }else{
        _volumeBar.hasBorder = NO;
        [_borderColorWell setEnabled:NO];
    }
}

- (IBAction)borderColorChanged:(id)sender {
    _volumeBar.borderColor = [sender color];
}

- (IBAction)barColorChanged:(id)sender {
    _volumeBar.barColor = [sender color];
}

- (IBAction)spaceBetweenBorderAndBarChanged:(id)sender {
    _volumeBar.spaceBetweenBorderAndBar = [sender doubleValue];
    _spaceBetweenBorderAndBarTXT.stringValue = [NSString stringWithFormat:@"%.02f", [sender doubleValue]];
}

- (IBAction)showLateralVolumePads:(id)sender {
    if ([sender state] == NSOnState){
        _volumeBar.showsLateralVolumePads = YES;
        [_volumeForLateralVolumePadsSlider setEnabled:YES];
        
    }else{
        _volumeBar.showsLateralVolumePads = NO;
        [_volumeForLateralVolumePadsSlider setEnabled:NO];
    }
}

- (IBAction)volumeForVolumePadsChanged:(id)sender {
    _volumeBar.volumeForLateralVolumePads = [sender doubleValue];
    _volumePadsTXT.stringValue = [NSString stringWithFormat:@"%.02f", [sender doubleValue]];
}

- (IBAction)currentVolumeChanged:(id)sender {
    _volumeBar.currentVolume = [sender doubleValue];
    _currentVolumeTXT.stringValue = [NSString stringWithFormat:@"%.02f", [sender doubleValue]];
}

- (IBAction)generateRandomVolumes:(id)sender {
    if ([[sender title] isEqualToString:@"Generate Random Volumes"]){
        [_currentVolumeSlider setEnabled:NO];
        [(NSButton *)sender setTitle:@"Stop Generating Random Values"];
        randomVolumesTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(randomVolume:) userInfo:nil repeats:YES];
        
    }else{
        [_currentVolumeSlider setEnabled:YES];
        [(NSButton *)sender setTitle:@"Generate Random Volumes"];
        [randomVolumesTimer invalidate];
    }
}

- (void)randomVolume:(NSTimer *)timer {
    float randomVolume = (arc4random() % 100) / 100.0;
    [_volumeBar setCurrentVolume:randomVolume animated:(_randomVolumesAnimated.state == NSOnState)];
    
    _currentVolumeTXT.stringValue = [NSString stringWithFormat:@"%f", randomVolume];
    _currentVolumeSlider.doubleValue = randomVolume;
}

- (void)volumeDidChangeInVolumeBar:(PVVolumeBar *)volumeBar {
    _volumeBarPercentageTXT.stringValue = [NSString stringWithFormat:@"%li%%", volumeBar.currentVolumePercentage];
}



@end
