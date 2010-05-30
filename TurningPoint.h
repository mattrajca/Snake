//
//  TurningPoint.h
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "Types.h"

@interface TurningPoint : NSObject {
  @private
	uint8_t x;
	uint8_t y;
	Direction direction;
}

@property (nonatomic, readonly) uint8_t x;
@property (nonatomic, readonly) uint8_t y;
@property (nonatomic, readonly) Direction direction;

- (id)initWithX:(uint8_t)aX y:(uint8_t)aY direction:(Direction)aDirection;

@end
