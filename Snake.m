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

@synthesize parts, direction;
@dynamic headPart;

- (id)init {
	self = [super init];
	if (self) {
		direction = DirectionDown;
		parts = [[NSMutableArray alloc] init];
		turningPoints = [[NSMutableArray alloc] init];
		
		[self addHeadPart];
		
		for (uint8_t i = 0; i < 3; i++) {
			[self addPart];
		}
	}
	return self;
}

- (void)changeDirection:(Direction)aDirection {
	direction = aDirection;
	
	TurningPoint *tp = [[TurningPoint alloc] initWithX:self.headPart.x y:self.headPart.y
											 direction:direction];
	
	[turningPoints addObject:tp];
}

- (void)getProposedLocationWithPart:(SnakePart *)part direction:(Direction)aDirection x:(int8_t *)ox y:(int8_t *)oy {
	int x = part.x;
	int y = part.y;
	
	if (aDirection == DirectionUp) {
		y++;
		
		if (y == kMaxRows) {
			y = -1;
		}
	}
	else if (aDirection == DirectionRight) {
		x++;
		
		if (x == kMaxColumns) {
			x = -1;
		}
	}
	else if (aDirection == DirectionDown) {
		y--;
		
		if (y < 0) {
			y = -1;
		}
	}
	else if (aDirection == DirectionLeft) {
		x--;
		
		if (x < 0) {
			x = -1;
		}
	}
	
	*ox = x;
	*oy = y;
}

- (void)beginGrowth {
	growsLeft += 4;
}

- (void)update {
	if (growsLeft > 0)
		[self grow];
		
	[self updatePartDirections];
	
	for (SnakePart *part in parts) {
		int8_t x;
		int8_t y;
		
		[self getProposedLocationWithPart:part direction:part.direction x:&x y:&y];
		
		part.x = x;
		part.y = y;
	}
}

- (SnakePart *)headPart {
	return [parts objectAtIndex:0];
}

- (void)addHeadPart {
	SnakePart *head = [[SnakePart alloc] initWithX:14 y:13];
	head.isHead = YES;
	
	[parts addObject:head];
}

- (void)addPart {
	SnakePart *lastPart = [parts lastObject];
	
	uint8_t newX = lastPart.x;
	uint8_t newY = lastPart.y + 1;
	
	SnakePart *newPart = [[SnakePart alloc] initWithX:newX y:newY];
	
	[parts addObject:newPart];
}

- (void)grow {
	SnakePart *lastPart = [parts lastObject];
	
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
	
	[parts addObject:newPart];
	
	growsLeft--;
}

- (void)updatePartDirections {
	NSMutableArray *pointsToRemove = [[NSMutableArray alloc] init];
	
	for (TurningPoint *point in turningPoints) {
		BOOL overlapsPart = NO;
		
		for (SnakePart *part in parts) {
			if (part.x == point.x && part.y == point.y) {
				part.direction = point.direction;
				
				overlapsPart = YES;
			}
		}
		
		if (!overlapsPart) {
			[pointsToRemove addObject:point];
		}
	}
	
	[turningPoints removeObjectsInArray:pointsToRemove];
}

- (void)draw {
	for (SnakePart *part in parts) {
		[part draw];
	}
}

@end
