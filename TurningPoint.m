//
//  TurningPoint.m
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "TurningPoint.h"

@implementation TurningPoint

@synthesize x, y, direction;

- (id)initWithX:(uint8_t)aX y:(uint8_t)aY direction:(Direction)aDirection {
	self = [super init];
	if (self) {
		x = aX;
		y = aY;
		direction = aDirection;
	}
	return self;
}

@end
