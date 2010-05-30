//
//  GameView.m
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "GameView.h"

#import "Food.h"
#import "NSColor+Snake.h"
#import "Snake.h"
#import "SnakePart.h"

@implementation GameView

@dynamic ready;
@synthesize delegate;

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self newGame];
	}
	return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	[[NSColor levelBackgroundColor] set];
	NSRectFill(dirtyRect);
	
	[snake draw];
	[food draw];
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
	[self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)moveRight:(id)sender {
	if (snake.direction == DirectionLeft)
		return;
	
	nextDirection = DirectionRight;
}

- (void)moveLeft:(id)sender {
	if (snake.direction == DirectionRight)
		return;
	
	nextDirection = DirectionLeft;
}

- (void)moveUp:(id)sender {
	if (snake.direction == DirectionDown)
		return;
	
	nextDirection = DirectionUp;
}

- (void)moveDown:(id)sender {
	if (snake.direction == DirectionUp)
		return;
	
	nextDirection = DirectionDown;
}

- (void)insertText:(id)insertString {
	if ([insertString isEqualToString:@" "]) {
		if (isPaused && isReady) {
			[self resume:nil];
		}
		else if (!isPaused && isReady) {
			[self pause:nil];
		}
	}
}

- (BOOL)ready {
	return isReady;
}

- (void)setReady:(BOOL)r {
	if (isReady != r) {
		isReady = r;
		
		if (r) {
			[self resume:self];
		}
		else {
			[self pause:self];
			[self newGame];
		}
	}
}

- (IBAction)pause:(id)sender {
	if (isPaused)
		return;
	
	[gameTimer invalidate];
	
	isPaused = YES;
	
	if ([delegate respondsToSelector:@selector(gameView:didChangeState:)])
		[delegate gameView:self didChangeState:GameViewStatePaused];
}

- (IBAction)resume:(id)sender {
	if (!isPaused)
		return;
	
	if (!lastFoodDate)
		lastFoodDate = [NSDate date];
	
	gameTimer = [NSTimer scheduledTimerWithTimeInterval:kGameTimerInterval 
												 target:self selector:@selector(updateWorld:)
											   userInfo:nil repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:gameTimer forMode:NSRunLoopCommonModes];
	
	isPaused = NO;
	
	if ([delegate respondsToSelector:@selector(gameView:didChangeState:)])
		[delegate gameView:self didChangeState:GameViewStateInProgress];
}

- (void)newGame {
	srandom(time(NULL));
	
	snake = nil;
	food = nil;
	
	snake = [[Snake alloc] init];
	food = [[Food alloc] init];
	nextDirection = DirectionDown;
	isPaused = YES;
	points = 0;
	
	if ([delegate respondsToSelector:@selector(gameView:didUpdatePoints:)])
		[delegate gameView:self didUpdatePoints:points];
	
	[food relocateWithSnake:snake];
	
	[self setNeedsDisplay:YES];
}

- (void)gameEnded {
	if ([delegate respondsToSelector:@selector(gameView:didEndWithPoints:)]) {
		[delegate gameView:self didEndWithPoints:points];
	}
	
	[self pause:self];	
}

- (void)updateWorld:(id)sender {
	int8_t x;
	int8_t y;
	
	[snake getProposedLocationWithPart:snake.headPart direction:nextDirection x:&x y:&y];
	
	if (x == -1 || y == -1) {
		[self gameEnded];
		
		return;
	}
	
	NSRect snakeArea = NSZeroRect;
	
	for (SnakePart *part in snake.parts) {
		snakeArea = NSUnionRect(snakeArea, [part toRect]);
		
		if (part.x == x && part.y == y) {
			[self gameEnded];
			
			return;
		}
	}
	
	snakeArea = NSInsetRect(snakeArea, -kGameObjectWidth, -kGameObjectWidth);
	
	if (nextDirection != snake.direction)
		[snake changeDirection:nextDirection];
	
	[snake update];
	
	if ([snake.headPart intersects:food]) {
		int seconds = 6 - abs((int) [lastFoodDate timeIntervalSinceNow]);
		
		if (seconds < 0)
			seconds = 0;
		
		points += 4 + seconds;
		
		lastFoodDate = [NSDate date];
		
		if ([delegate respondsToSelector:@selector(gameView:didUpdatePoints:)])
			[delegate gameView:self didUpdatePoints:points];
		
		[snake beginGrowth];
		[food relocateWithSnake:snake];
		
		[self setNeedsDisplayInRect:[food toRect]];
	}
	
	[self setNeedsDisplayInRect:snakeArea];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	if ([menuItem action] == @selector(pause:)) {
		return !isPaused && isReady;
	}
	else if ([menuItem action] == @selector(resume:)) {
		return isPaused && isReady;
	}
	
	return NO;
}

@end
