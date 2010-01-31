//
//  GameObject.m
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize x = _x;
@synthesize y = _y;

- (id)initWithX:(uint8_t)x y:(uint8_t)y {
	self = [super init];
	if (self) {
		_x = x;
		_y = y;
	}
	return self;
}

- (void)draw {
	/* to be implemented in subclasses */
}

- (BOOL)intersects:(GameObject *)anotherObject {
	return NSIntersectsRect([self toRect], [anotherObject toRect]);
}

- (NSRect)toRect {
	return NSMakeRect(_x * kGameObjectWidth, _y * kGameObjectWidth, kGameObjectWidth, kGameObjectWidth);
}

@end
