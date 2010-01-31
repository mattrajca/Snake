//
//  Food.m
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "Food.h"

#import "NSColor+Snake.h"
#import "Snake.h"
#import "SnakePart.h"
#import "Types.h"

@implementation Food

- (void)draw {
	NSRect bounds = [self toRect];
	
	[[NSColor foodColor] set];
	[[NSBezierPath bezierPathWithOvalInRect:bounds] fill];
}

- (void)relocateWithSnake:(Snake *)snake {
	uint8_t x = random() % kMaxColumns;
	uint8_t y = random() % kMaxRows;
	
	NSArray *parts = snake.parts;
	
	for (uint8_t i = 0; i < [parts count]; i++) {
		SnakePart *part = [parts objectAtIndex:i];
		
		if (part.x == x && part.y == y) {
			if (x == (kMaxColumns - 1)) {
				x--;
			}
			else {
				x++;
			}
			
			i = 0;
		}
	}
	
	self.x = x;
	self.y = y;
}

@end
