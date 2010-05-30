//
//  SnakePart.m
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "SnakePart.h"

@implementation SnakePart

@synthesize direction, isHead;

- (id)initWithX:(uint8_t)x y:(uint8_t)y direction:(Direction)aDirection {
	self = [super initWithX:x y:y];
	if (self) {
		direction = aDirection;
	}
	return self;
}

- (void)draw {
	NSRect bounds = [self toRect];
	
	[[NSColor blackColor] set];
	NSRectFill(bounds);
	
	if (isHead) {
		NSRect faceRect = NSInsetRect(bounds, 4.0f, 4.0f);
		
		[[NSColor orangeColor] set];
		NSRectFill(faceRect);
	}
}

@end
