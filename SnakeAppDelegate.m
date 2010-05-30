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

@synthesize window, gameView, pointsField, statusField;

- (void)awakeFromNib {
	[self newGame:nil];
}

- (void)gameView:(GameView *)view didUpdatePoints:(int)points {
	[pointsField setIntValue:points];
}

- (void)gameView:(GameView *)view didEndWithPoints:(int)points {
	[self recordPoints:points];
	
	NSBeginAlertSheet(@"Whoa!", @"New Game", @"Quit", @"High Scores", window,
					  self, @selector(sheetDidEnd:returnCode:contextInfo:), NULL, NULL,
					  @"You collided with another game object!");
}

- (void)gameView:(GameView *)view didChangeState:(GameViewState)state {
	[statusField setStringValue:state == GameViewStatePaused ? @"Paused" : @"In Progress"];
}

- (IBAction)newGame:(id)sender {
	counter = 4;
	gameView.ready = NO;
	
	[self launchCounterTick:nil];
	
	NSTimer *tmr = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self 
												  selector:@selector(launchCounterTick:) userInfo:nil repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:tmr forMode:NSRunLoopCommonModes];
}

- (IBAction)showHighScores:(id)sender {
	if (!highScoresWC) {
		highScoresWC = [[HighScoresWindowController alloc] init];
	}
	
	[highScoresWC showWindow:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

- (void)launchCounterTick:(NSTimer *)tmr {
	[statusField setStringValue:[NSString stringWithFormat:@"Starting in %i...", counter]];
	
	if (counter > 0) {
		[statusField setStringValue:[NSString stringWithFormat:@"Starting in %i...", counter]];
		
		counter--;
		
		return;
	}
	
	[tmr invalidate];
	
	gameView.ready = YES;
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	if ([menuItem action] == @selector(newGame:)) {
		return counter == 0;
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
		[gameView newGame];
		
		[self showHighScores:self];
	}
	else if (returnCode == NSAlertAlternateReturn) {
		[window close];
	}
}

@end
