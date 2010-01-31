//
//  Snake.m
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "Snake.h"

#import "SnakePart.h"
#import "TurningPoint.h"

@interface Snake ()

- (void)addHeadPart;
- (void)addPart;
- (void)grow;
- (void)updatePartDirections;

@end


@implementation Snake

@synthesize parts = _parts;
@dynamic headPart;
@synthesize direction = _direction;

#pragma mark -
#pragma mark Initialization

- (id)init {
	self = [super init];
	if (self) {
		_direction = DirectionDown;
		_parts = [[NSMutableArray alloc] init];
		_turningPoints = [[NSMutableArray alloc] init];
		
		[self addHeadPart];
		
		for (uint8_t i = 0; i < 3; i++) {
			[self addPart];
		}
	}
	return self;
}

#pragma mark -
#pragma mark Actions

- (void)changeDirection:(Direction)direction {
	_direction = direction;
	
	TurningPoint *tp = [[TurningPoint alloc] initWithX:self.headPart.x y:self.headPart.y
											 direction:direction];
	
	[_turningPoints addObject:tp];
}

- (void)getProposedLocationWithPart:(SnakePart *)part direction:(Direction)direction x:(int8_t *)ox y:(int8_t *)oy {
	int x = part.x;
	int y = part.y;
	
	if (direction == DirectionUp) {
		y++;
		
		if (y == kMaxRows) {
			y = -1;
		}
	}
	else if (direction == DirectionRight) {
		x++;
		
		if (x == kMaxColumns) {
			x = -1;
		}
	}
	else if (direction == DirectionDown) {
		y--;
		
		if (y < 0) {
			y = -1;
		}
	}
	else if (direction == DirectionLeft) {
		x--;
		
		if (x < 0) {
			x = -1;
		}
	}
	
	*ox = x;
	*oy = y;
}

- (void)beginGrowth {
	_growsLeft += 4;
}

- (void)update {
	if (_growsLeft > 0)
		[self grow];
		
	[self updatePartDirections];
	
	for (SnakePart *part in _parts) {
		int8_t x;
		int8_t y;
		
		[self getProposedLocationWithPart:part direction:part.direction x:&x y:&y];
		
		part.x = x;
		part.y = y;
	}
}

#pragma mark -
#pragma mark Properties

- (SnakePart *)headPart {
	return [_parts objectAtIndex:0];
}

#pragma mark -
#pragma mark Helpers

- (void)addHeadPart {
	SnakePart *head = [[SnakePart alloc] initWithX:14 y:13];
	head.isHead = YES;
	
	[_parts addObject:head];
}

- (void)addPart {
	SnakePart *lastPart = [_parts lastObject];
	
	uint8_t newX = lastPart.x;
	uint8_t newY = lastPart.y + 1;
	
	SnakePart *newPart = [[SnakePart alloc] initWithX:newX y:newY];
	
	[_parts addObject:newPart];
}

- (void)grow {
	SnakePart *lastPart = [_parts lastObject];
	
	uint8_t x = lastPart.x;
	uint8_t y = lastPart.y;
	
	if (lastPart.direction == DirectionUp) {
		y--;
	}
	else if (lastPart.direction == DirectionRight) {
		x--;
	}
	else if (lastPart.direction == DirectionDown) {
		y++;
	}
	else if (lastPart.direction == DirectionLeft) {
		x++;
	}
	
	SnakePart *newPart = [[SnakePart alloc] initWithX:x y:y direction:lastPart.direction];
	
	[_parts addObject:newPart];
	
	_growsLeft--;
}

- (void)updatePartDirections {
	NSMutableArray *pointsToRemove = [[NSMutableArray alloc] init];
	
	for (TurningPoint *point in _turningPoints) {
		BOOL overlapsPart = NO;
		
		for (SnakePart *part in _parts) {
			if (part.x == point.x && part.y == point.y) {
				part.direction = point.direction;
				
				overlapsPart = YES;
			}
		}
		
		if (!overlapsPart) {
			[pointsToRemove addObject:point];
		}
	}
	
	[_turningPoints removeObjectsInArray:pointsToRemove];
}

- (void)draw {
	for (SnakePart *part in _parts) {
		[part draw];
	}
}

#pragma mark -

@end
