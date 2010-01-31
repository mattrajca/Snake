//
//  TurningPoint.m
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "TurningPoint.h"

@implementation TurningPoint

@synthesize x = _x;
@synthesize y = _y;
@synthesize direction = _direction;

- (id)initWithX:(uint8_t)x y:(uint8_t)y direction:(Direction)direction {
	self = [super init];
	if (self) {
		_x = x;
		_y = y;
		_direction = direction;
	}
	return self;
}

@end
