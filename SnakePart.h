//
//  SnakePart.h
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "GameObject.h"
#import "Types.h"

@interface SnakePart : GameObject {
  @private
	Direction _direction;
	BOOL _isHead;
}

@property (nonatomic, assign) Direction direction;
@property (nonatomic, assign) BOOL isHead;

- (id)initWithX:(uint8_t)x y:(uint8_t)y direction:(Direction)direction;

@end
