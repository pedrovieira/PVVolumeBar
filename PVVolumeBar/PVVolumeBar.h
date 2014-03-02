//
//  PVVolumeBar.h
//
//  Created by Pedro Vieira on 21/2/14.
//  Copyright (c) 2014 Pedro Vieira ( http://pedrovieira.me/ ). All rights reserved.
//

#import <Cocoa/Cocoa.h>

//NSAnimation subclass used in PVVolumeBar
@class PVVolumeBarAnimation;
@protocol PVVolumeBarAnimationDelegate
- (void)animationCurrentProgressDidChangeToValue:(float)value;
@end

@interface PVVolumeBarAnimation : NSAnimation
@property (nonatomic, assign) id<PVVolumeBarAnimationDelegate> customDelegate;
@end


@class PVVolumeBar;
@protocol PVVolumeBarDelegate <NSObject>
@required
- (void)volumeDidChangeInVolumeBar:(PVVolumeBar *)volumeBar;
@optional
- (void)volumeBarAnimationDidEnd:(PVVolumeBar *)volumeBar;
@end

@interface PVVolumeBar : NSView <PVVolumeBarAnimationDelegate, NSAnimationDelegate> {
    NSBezierPath *_volumeBorder;
    NSBezierPath *_volumeBar;
    NSColor *_borderColor;
    NSColor *_barColor;
    
    PVVolumeBarAnimation *_animation;
    
    BOOL _hasBorder;
    BOOL _isAnimating;
    BOOL _showsVolumeTicker;
    double _volumeOfLateralVolumePads;
    
    float _borderWidth;
    float _spaceBetweenBorderAndBar;
    double _minVolume;
    double _maxVolume;
    double _currentVolume;
    double _volumeDifferenceWhileAnimating;
}

@property (nonatomic, assign) id<PVVolumeBarDelegate> delegate; //PVVolumeBar's delegate

//Method used to show/hide the volume bar border, default is YES
- (void)setHasBorder:(BOOL)flag;
- (BOOL)hasBorder;

//Volume bar border color, default is [NSColor whiteColor] (VLC's default)
- (void)setBorderColor:(NSColor *)color;
- (NSColor *)borderColor;

//Volume bar border width, default is 1.0 (VLC's default)
- (void)setBorderWidth:(CGFloat)width;
- (CGFloat)borderWidth;

//Volume bar color, default is [NSColor whiteColor] (VLC's default)
- (void)setBarColor:(NSColor *)color;
- (NSColor *)barColor;

//Space between the volume bar border and the volume bar, default is 1.0 (VLC's default)
- (void)setSpaceBetweenBorderAndBar:(CGFloat)space;
- (CGFloat)spaceBetweenBorderAndBar;

//Method to show/hide the lateral volume pads like you see in VLC (you can notice a small square, in each side of the volume bar, at 100% volume in VLC)
//NOTE: if the volume bar doesn't have a border, the lateral volume pads won't be displayed
//Default is NO (which means the volume pads are not displayed)
- (void)setShowsLateralVolumePads:(BOOL)flag;
- (BOOL)showsLateralVolumePads;

//Method to choose where to show the lateral volume pads given a volume. For example, if your minVolume is 0.0 and maxVolume is 1.0 and if you set the 0.5 as the volume for the lateral volume pads, the pads will be displayed right in the center of the volume bar
//Default is -1.0 (which means the volume pads are not visible)
- (void)setVolumeForLateralVolumePads:(double)aDouble;
- (double)volumeForLateralVolumePads;



//Duration of the volume bar animations, default is 0.25 seconds
- (void)setAnimationDuration:(NSTimeInterval)duration;
- (NSTimeInterval)animationDuration;

//Animations curve, default is NSAnimationEaseInOut
- (void)setAnimationCurve:(NSAnimationCurve)animCurve;
- (NSAnimationCurve)animationCurve;

- (BOOL)isAnimating;



//The minimum volume of the volume bar, default is 0.0
- (void)setMinVolume:(double)aDouble;
- (double)minVolume;

//The maximum volume of the volume bar, default is 1.0
- (void)setMaxVolume:(double)aDouble;
- (double)maxVolume;

- (void)setCurrentVolume:(double)aDouble;
- (void)setCurrentVolume:(double)aDouble animated:(BOOL)flag;
- (void)increaseCurrentVolumeBy:(double)aDouble;
- (void)increaseCurrentVolumeBy:(double)aDouble animated:(BOOL)flag;
- (void)decreaseCurrentVolumeBy:(double)aDouble;
- (void)decreaseCurrentVolumeBy:(double)aDouble animated:(BOOL)flag;
- (double)currentVolume;

//Current volume percentage, for example, if max maxVolume is 1.0, minVolume is 0.0 and currentVolume is 0.1, this method will return 10 (%)
- (NSInteger)currentVolumePercentage;

@end