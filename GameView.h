//
//  GameView.h
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "Types.h"

@class Food, Snake;
@protocol GameViewDelegate;

typedef enum {
	GameViewStatePaused = 0,
	GameViewStateInProgress
} GameViewState;

@interface GameView : NSView {
  @private
	Snake *snake;
	Food *food;
	Direction nextDirection;
	NSTimer *gameTimer;
	NSDate *lastFoodDate;
	BOOL isPaused;
	BOOL isReady;
	int points;
	
	id < GameViewDelegate > delegate;
}

@property (nonatomic, assign) BOOL ready;

@property (nonatomic, assign) IBOutlet id < GameViewDelegate > delegate;

- (IBAction)pause:(id)sender;
- (IBAction)resume:(id)sender;

- (void)newGame;

@end


@protocol GameViewDelegate < NSObject >

- (void)gameView:(GameView *)view didUpdatePoints:(int)points;
- (void)gameView:(GameView *)view didEndWithPoints:(int)points;
- (void)gameView:(GameView *)view didChangeState:(GameViewState)state;

@end
