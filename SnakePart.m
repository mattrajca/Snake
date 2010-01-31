//
//  SnakePart.m
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "SnakePart.h"

@implementation SnakePart

@synthesize direction = _direction;
@synthesize isHead = _isHead;

- (id)initWithX:(uint8_t)x y:(uint8_t)y direction:(Direction)direction {
	self = [super initWithX:x y:y];
	if (self) {
		_direction = direction;
	}
	return self;
}

- (void)draw {
	NSRect bounds = [self toRect];

	[[NSColor blackColor] set];
	NSRectFill(bounds);
	
	if (_isHead) {
		NSRect faceRect = NSInsetRect(bounds, 4.0f, 4.0f);
		
		[[NSColor orangeColor] set];
		NSRectFill(faceRect);
	}
}

@end
