//
//  NSColor+Snake.m
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "NSColor+Snake.h"

@implementation NSColor (Snake)

+ (NSColor *)levelBackgroundColor {
	return [NSColor colorWithCalibratedRed:0.79f green:0.9f blue:0.77f alpha:1.0f];
}

+ (NSColor *)foodColor {
	return [NSColor colorWithCalibratedRed:0.79f green:0.2f blue:0.15f alpha:1.0];
}

@end
