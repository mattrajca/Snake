//
//  SnakeAppDelegate.m
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "SnakeAppDelegate.h"

#import "HighScoresWindowController.h"

@interface SnakeAppDelegate ()

- (void)launchCounterTick:(NSTimer *)tmr;
- (void)recordPoints:(int)points;

@end


@implementation SnakeAppDelegate

@synthesize window = _window;
@synthesize gameView = _gameView;
@synthesize pointsField = _pointsField;
@synthesize statusField = _statusField;

#pragma mark -
#pragma mark UI

- (void)awakeFromNib {
	[self newGame:nil];
}

#pragma mark -
#pragma mark Game View Delegate

- (void)gameView:(GameView *)view didUpdatePoints:(int)points {
	[_pointsField setIntValue:points];
}

- (void)gameView:(GameView *)view didEndWithPoints:(int)points {
	[self recordPoints:points];
	
	NSBeginAlertSheet(@"Whoa!", @"New Game", @"Quit", @"High Scores", _window, 
					  self, @selector(sheetDidEnd:returnCode:contextInfo:), NULL, NULL, 
					  @"You collided with another game object!");
}

- (void)gameView:(GameView *)view didChangeState:(GameViewState)state {
	[_statusField setStringValue:state == GameViewStatePaused ? @"Paused" : @"In Progress"];
}

#pragma mark -
#pragma mark Actions

- (IBAction)newGame:(id)sender {
	_counter = 4;
	_gameView.ready = NO;
	
	[self launchCounterTick:nil];
	
	NSTimer *tmr = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self 
												  selector:@selector(launchCounterTick:) userInfo:nil repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:tmr forMode:NSRunLoopCommonModes];
}

- (IBAction)showHighScores:(id)sender {
	if (!_highScoresWC) {
		_highScoresWC = [[HighScoresWindowController alloc] init];
	}
	
	[_highScoresWC showWindow:self];
}

#pragma mark -
#pragma mark App Delegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

#pragma mark -
#pragma mark Helpers

- (void)launchCounterTick:(NSTimer *)tmr {
	[_statusField setStringValue:[NSString stringWithFormat:@"Starting in %i...", _counter]];
	
	if (_counter > 0) {
		[_statusField setStringValue:[NSString stringWithFormat:@"Starting in %i...", _counter]];
		
		_counter--;
		
		return;
	}
	
	[tmr invalidate];
	
	_gameView.ready = YES;
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	if ([menuItem action] == @selector(newGame:)) {
		return _counter == 0;
	}
	
	return YES;
}

- (void)recordPoints:(int)points {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *scores = [[defaults arrayForKey:@"highScores"] mutableCopy];
	
	if (!scores)
		scores = [[NSMutableArray alloc] init];
	
	NSDictionary *entry = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:points], @"points",
						   [NSDate date], @"date", nil];
	
	[scores addObject:entry];
	
	NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"points" ascending:NO];
	[scores sortUsingDescriptors:[NSArray arrayWithObject:sd]];
	
	if ([scores count] > 10) {
		[scores removeObjectsInRange:NSMakeRange(10, [scores count] - 10)];
	}
	
	[defaults setObject:scores forKey:@"highScores"];
	[defaults synchronize];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	if (returnCode == NSAlertDefaultReturn) {
		[self newGame:self];
	}
	else if (returnCode == NSAlertOtherReturn) {
		[_gameView newGame];
		
		[self showHighScores:self];
	}
	else if (returnCode == NSAlertAlternateReturn) {
		[_window close];
	}
}

#pragma mark -

@end
