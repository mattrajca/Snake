//
//  SnakeAppDelegate.h
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "GameView.h"

@class HighScoresWindowController;

@interface SnakeAppDelegate : NSObject < NSApplicationDelegate, GameViewDelegate > {
  @private
	NSWindow *window;
	GameView *gameView;
	NSTextField *pointsField;
	NSTextField *statusField;
	
	HighScoresWindowController *highScoresWC;
	int counter;
}

@property (nonatomic, assign) IBOutlet NSWindow *window;
@property (nonatomic, assign) IBOutlet GameView *gameView;
@property (nonatomic, assign) IBOutlet NSTextField *pointsField;
@property (nonatomic, assign) IBOutlet NSTextField *statusField;

- (IBAction)newGame:(id)sender;
- (IBAction)showHighScores:(id)sender;

@end
