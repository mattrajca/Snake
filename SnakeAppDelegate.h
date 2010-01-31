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
    NSWindow *_window;
	GameView *_gameView;
	NSTextField *_pointsField;
	NSTextField *_statusField;
	
	HighScoresWindowController *_highScoresWC;
	int _counter;
}

@property (nonatomic, assign) IBOutlet NSWindow *window;
@property (nonatomic, assign) IBOutlet GameView *gameView;
@property (nonatomic, assign) IBOutlet NSTextField *pointsField;
@property (nonatomic, assign) IBOutlet NSTextField *statusField;

- (IBAction)newGame:(id)sender;
- (IBAction)showHighScores:(id)sender;

@end
