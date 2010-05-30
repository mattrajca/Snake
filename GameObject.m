//
//  GameObject.m
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize x, y;

- (id)initWithX:(uint8_t)aX y:(uint8_t)aY {
	self = [super init];
	if (self) {
		x = aX;
		y = aY;
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
	return NSMakeRect(x * kGameObjectWidth, y * kGameObjectWidth, kGameObjectWidth, kGameObjectWidth);
}

@end
