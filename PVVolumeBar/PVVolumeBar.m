//
//  PVVolumeBar.m
//
//  Created by Pedro Vieira on 21/2/14.
//  Copyright (c) 2014 Pedro Vieira ( http://pedrovieira.me/ ). All rights reserved.
//

#import "PVVolumeBar.h"

@implementation PVVolumeBarAnimation
@synthesize customDelegate;

- (void)setCurrentProgress:(NSAnimationProgress)progress {
    //[super setCurrentProgress:progress];
    [customDelegate animationCurrentProgressDidChangeToValue:progress];
}
@end


#define DEFAULT_COLOR [NSColor whiteColor]
#define DEFAULT_MIN_VOLUME 0.0
#define DEFAULT_MAX_VOLUME 1.0
#define DEFAULT_VOLUME_TICKER_VOLUME_UNKNOWN -1.0

//VLC's default aspects
#define DEFAULT_VOLUME_BAR_BORDER_WIDTH 1.0
#define DEFAULT_SPACE_BETWEEN_BORDER_AND_BAR 1.0

@implementation PVVolumeBar
@synthesize delegate;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _hasBorder = YES;
        _isAnimating = NO;
        _showsVolumeTicker = NO;
        
        _borderColor = DEFAULT_COLOR;
        _borderWidth = DEFAULT_VOLUME_BAR_BORDER_WIDTH;
        _barColor = DEFAULT_COLOR;
        _spaceBetweenBorderAndBar = DEFAULT_SPACE_BETWEEN_BORDER_AND_BAR;
        _volumeOfLateralVolumePads = DEFAULT_VOLUME_TICKER_VOLUME_UNKNOWN;
        
        _minVolume = DEFAULT_MIN_VOLUME;
        _maxVolume = DEFAULT_MAX_VOLUME;
        _currentVolume = 0;
        
        _animation = [[PVVolumeBarAnimation alloc] init];
        _animation.customDelegate = self;
        _animation.delegate = self;
        _animation.duration = 0.25;
        _animation.animationBlockingMode = NSAnimationNonblocking;
        _animation.animationCurve = NSAnimationEaseInOut;
    }
    
    return self;
}


#pragma mark -
#pragma mark PVVolumeBar visual changing/accessing methods
- (void)setHasBorder:(BOOL)flag {
    _hasBorder = flag;
    [self display];
}

- (BOOL)hasBorder {
    return _hasBorder;
}

- (void)setBorderColor:(NSColor *)color {
    _borderColor = color;
    [self display];
}

- (NSColor *)borderColor {
    return _borderColor;
}

- (void)setBorderWidth:(CGFloat)width {
    _borderWidth = width < 0.0 ? 0.0 : width;
    [self display];
}

- (CGFloat)borderWidth {
    return _borderWidth;
}

- (void)setBarColor:(NSColor *)color {
    _barColor = color;
    [self display];
}

- (NSColor *)barColor {
    return _barColor;
}

- (void)setSpaceBetweenBorderAndBar:(CGFloat)space {
    _spaceBetweenBorderAndBar = space < 0.0 ? 0.0 : space;
    [self display];
}

- (CGFloat)spaceBetweenBorderAndBar {
    return _spaceBetweenBorderAndBar;
}

- (void)setShowsLateralVolumePads:(BOOL)flag {
    _showsVolumeTicker = flag;
    [self display];
}

- (BOOL)showsLateralVolumePads {
    return _showsVolumeTicker;
}

- (void)setVolumeForLateralVolumePads:(double)aDouble {
    _volumeOfLateralVolumePads = aDouble;
    [self display];
}

- (double)volumeForLateralVolumePads{
    return _volumeOfLateralVolumePads;
}


#pragma mark -
#pragma mark PVVolumeBar animation methods
- (void)setAnimationDuration:(NSTimeInterval)duration {
    _animation.duration = duration;
}

- (NSTimeInterval)animationDuration {
    return _animation.duration;
}

- (void)setAnimationCurve:(NSAnimationCurve)animCurve {
    _animation.animationCurve = animCurve;
}

- (NSAnimationCurve)animationCurve {
    return _animation.animationCurve;
}

- (BOOL)isAnimating {
    return _isAnimating;
}


#pragma mark -
#pragma mark PVVolumeBar volume changing/accessing methods
- (void)setMinVolume:(double)aDouble {
    _minVolume = aDouble;
    
    if (_minVolume > _maxVolume) {
        [self switchMinVolumeWithMaxVolume];
    }
    
    _currentVolume = [self checkIfDoubleIsOutOfVolumeBoundsAndFixIt:aDouble];
    [self display];
}

- (double)minVolume {
    return _minVolume;
}

- (void)setMaxVolume:(double)aDouble {
    _maxVolume = aDouble;
    
    if (_maxVolume < _minVolume) {
        [self switchMinVolumeWithMaxVolume];
    }
    
    _currentVolume = [self checkIfDoubleIsOutOfVolumeBoundsAndFixIt:aDouble];
    [self display];
}

- (double)maxVolume {
    return _maxVolume;
}

- (void)switchMinVolumeWithMaxVolume {
    //private method: if the minValue is higher than maxVolume, or vice-versa, switch values between them
    double tempVolume = _minVolume;
    _minVolume = _maxVolume;
    _maxVolume = tempVolume;
}

- (void)setCurrentVolume:(double)aDouble {
    [self setCurrentVolume:aDouble animated:NO];
}

- (void)setCurrentVolume:(double)aDouble animated:(BOOL)flag {
    if (_currentVolume != aDouble) {
        [_animation stopAnimation];
        
        if (flag) {
            _isAnimating = YES;
            aDouble = [self checkIfDoubleIsOutOfVolumeBoundsAndFixIt:aDouble];
            _volumeDifferenceWhileAnimating = aDouble - _currentVolume;
            [_animation startAnimation];
            
        }else{
            _currentVolume = [self checkIfDoubleIsOutOfVolumeBoundsAndFixIt:aDouble];
            [self display];
            [delegate volumeDidChangeInVolumeBar:self];
        }
    }
}

- (void)increaseCurrentVolumeBy:(double)aDouble {
    [self setCurrentVolume:self.currentVolume + aDouble animated:NO];
}

- (void)increaseCurrentVolumeBy:(double)aDouble animated:(BOOL)flag {
    [self setCurrentVolume:self.currentVolume + aDouble animated:flag];
}

- (void)decreaseCurrentVolumeBy:(double)aDouble {
    [self setCurrentVolume:self.currentVolume - aDouble animated:NO];
}

- (void)decreaseCurrentVolumeBy:(double)aDouble animated:(BOOL)flag {
    [self setCurrentVolume:self.currentVolume - aDouble animated:flag];
}

- (double)currentVolume {
    return _currentVolume;
}

- (double)checkIfDoubleIsOutOfVolumeBoundsAndFixIt:(double)aDouble {
    //private method: checks if the given double is out of bounds (higher than maxVolume or lower than minVolume) and fix it
    if (aDouble > _maxVolume){
        return _maxVolume;
    }else if (aDouble < _minVolume){
        return _minVolume;
    }else{
        return aDouble;
    }
}

- (NSInteger)currentVolumePercentage {
    return round(((_currentVolume - _minVolume) / (_maxVolume - _minVolume)) * 100);
}


#pragma mark -
#pragma mark PVVolumeBar drawing method
- (void)drawRect:(NSRect)dirtyRect {
    if (_hasBorder) {
        //Draw Border
        _volumeBorder = [NSBezierPath bezierPathWithRect:NSInsetRect(self.bounds, _borderWidth/2, _borderWidth/2)];
        _volumeBorder.lineWidth = _borderWidth;
        [_borderColor set];
        [_volumeBorder stroke];
        
        if (_showsVolumeTicker && _volumeOfLateralVolumePads != DEFAULT_VOLUME_TICKER_VOLUME_UNKNOWN) {
            float placeToDrawLateralVolumePads = ((_volumeOfLateralVolumePads - _minVolume) / (_maxVolume - _minVolume)) * (self.frame.size.height - (_hasBorder ? _borderWidth : 0) * 2 - (_hasBorder ? _spaceBetweenBorderAndBar : 0) * 2);
            
            //Draw left ticker
            NSRectFill(NSMakeRect(_hasBorder ? _borderWidth : 0,
                                  _hasBorder ? placeToDrawLateralVolumePads + _borderWidth : placeToDrawLateralVolumePads,
                                  1,
                                  1));
            
            //Draw right ticker
            NSRectFill(NSMakeRect(_hasBorder ? self.frame.size.width - _borderWidth - 1 : self.frame.size.width - 1,
                                  _hasBorder ? placeToDrawLateralVolumePads + _borderWidth : placeToDrawLateralVolumePads,
                                  1,
                                  1));
        }
    }
    
    
    float volumeBarSizeNeededToDraw = ((_currentVolume - _minVolume) / (_maxVolume - _minVolume)) * (self.frame.size.height - (_hasBorder ? _borderWidth : 0) * 2 - (_hasBorder ? _spaceBetweenBorderAndBar : 0) * 2);
    
    [_barColor set];
    
    //Draw Volume bar according to the actual volume
    NSRectFill(NSMakeRect(_hasBorder ? _borderWidth + _spaceBetweenBorderAndBar : 0,
                          _hasBorder ? _borderWidth + _spaceBetweenBorderAndBar : 0,
                          self.frame.size.width - (_hasBorder ? _borderWidth : 0) * 2 - (_hasBorder ? _spaceBetweenBorderAndBar : 0) * 2,
                          volumeBarSizeNeededToDraw));
}


#pragma mark -
#pragma mark PVVolumeBarAnimation & NSAnimation Delegate methods
- (void)animationCurrentProgressDidChangeToValue:(float)value {
    if (_isAnimating) {
        double tempValue = _volumeDifferenceWhileAnimating * value;
        
        _currentVolume += tempValue;
        _volumeDifferenceWhileAnimating -= tempValue;
        
        [self display];
        [delegate volumeDidChangeInVolumeBar:self];
    }
}

- (void)animationDidStop:(NSAnimation *)animation {
    _isAnimating = NO;
}

- (void)animationDidEnd:(NSAnimation *)animation {
    [delegate volumeDidChangeInVolumeBar:self];
    
    if ([delegate respondsToSelector:@selector(volumeBarAnimationDidEnd:)]) {
        [delegate volumeBarAnimationDidEnd:self];
    }
    
    [self animationDidStop:nil];
}

@end
