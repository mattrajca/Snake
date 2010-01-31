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
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self newGame];
    }
    return self;
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect {
	[[NSColor levelBackgroundColor] set];
	NSRectFill(dirtyRect);
	
	[_snake draw];
	[_food draw];
}

#pragma mark -
#pragma mark Responder Chain

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
	[self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)moveRight:(id)sender {
	if (_snake.direction == DirectionLeft)
		return;
	
	_nextDirection = DirectionRight;
}

- (void)moveLeft:(id)sender {
	if (_snake.direction == DirectionRight)
		return;
	
	_nextDirection = DirectionLeft;
}

- (void)moveUp:(id)sender {
	if (_snake.direction == DirectionDown)
		return;
	
	_nextDirection = DirectionUp;
}

- (void)moveDown:(id)sender {
	if (_snake.direction == DirectionUp)
		return;
	
	_nextDirection = DirectionDown;
}

- (void)insertText:(id)insertString {
	if ([insertString isEqualToString:@" "]) {
		if (_isPaused && _isReady) {
			[self resume:nil];
		}
		else if (!_isPaused && _isReady) {
			[self pause:nil];
		}
	}
}

#pragma mark -
#pragma mark Properties

- (BOOL)ready {
	return _isReady;
}

- (void)setReady:(BOOL)r {
	if (_isReady != r) {
		_isReady = r;
	
		if (r) {
			[self resume:self];
		}
		else {
			[self pause:self];
			[self newGame];
		}
	}
}

#pragma mark -
#pragma mark Actions

- (IBAction)pause:(id)sender {
	if (_isPaused)
		return;
	
	[_gameTimer invalidate];
	
	_isPaused = YES;
	
	if ([_delegate respondsToSelector:@selector(gameView:didChangeState:)])
		[_delegate gameView:self didChangeState:GameViewStatePaused];
}

- (IBAction)resume:(id)sender {
	if (!_isPaused)
		return;
	
	if (!_lastFoodDate)
		_lastFoodDate = [NSDate date];
	
	_gameTimer = [NSTimer scheduledTimerWithTimeInterval:kGameTimerInterval 
												  target:self selector:@selector(updateWorld:)
												userInfo:nil repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:_gameTimer forMode:NSRunLoopCommonModes];
	
	_isPaused = NO;
	
	if ([_delegate respondsToSelector:@selector(gameView:didChangeState:)])
		[_delegate gameView:self didChangeState:GameViewStateInProgress];
}

- (void)newGame {
	srandom(time(NULL));
	
	_snake = nil;
	_food = nil;
	
	_snake = [[Snake alloc] init];
	_food = [[Food alloc] init];
	_nextDirection = DirectionDown;
	_isPaused = YES;
	_points = 0;
	
	if ([_delegate respondsToSelector:@selector(gameView:didUpdatePoints:)])
		[_delegate gameView:self didUpdatePoints:_points];
	
	[_food relocateWithSnake:_snake];
	
	[self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark Helpers

- (void)gameEnded {
	if ([_delegate respondsToSelector:@selector(gameView:didEndWithPoints:)]) {
		[_delegate gameView:self didEndWithPoints:_points];
	}
	
	[self pause:self];	
}

- (void)updateWorld:(id)sender {	
	int8_t x;
	int8_t y;
	
	[_snake getProposedLocationWithPart:_snake.headPart direction:_nextDirection x:&x y:&y];
	
	if (x == -1 || y == -1) {
		[self gameEnded];
		
		return;
	}
	
	NSRect snakeArea = NSZeroRect;
	
	for (SnakePart *part in _snake.parts) {
		snakeArea = NSUnionRect(snakeArea, [part toRect]);
		
		if (part.x == x && part.y == y) {
			[self gameEnded];
			
			return;
		}
	}
	
	snakeArea = NSInsetRect(snakeArea, -kGameObjectWidth, -kGameObjectWidth);
	
	if (_nextDirection != _snake.direction)
		[_snake changeDirection:_nextDirection];
	
	[_snake update];
	
	if ([_snake.headPart intersects:_food]) {
		int seconds = 6 - abs((int) [_lastFoodDate timeIntervalSinceNow]);
		
		if (seconds < 0)
			seconds = 0;
		
		_points += 4 + seconds;
		
		_lastFoodDate = [NSDate date];
		
		if ([_delegate respondsToSelector:@selector(gameView:didUpdatePoints:)])
			[_delegate gameView:self didUpdatePoints:_points];
		
		[_snake beginGrowth];
		[_food relocateWithSnake:_snake];
		
		[self setNeedsDisplayInRect:[_food toRect]];
	}
	
	[self setNeedsDisplayInRect:snakeArea];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	if ([menuItem action] == @selector(pause:)) {
		return !_isPaused && _isReady;
	}
	else if ([menuItem action] == @selector(resume:)) {
		return _isPaused && _isReady;
	}
	
	return NO;
}

#pragma mark -

@end
