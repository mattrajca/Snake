//
//  GameObject.h
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "Types.h"

@interface GameObject : NSObject {
  @private
	uint8_t x;
	uint8_t y;
}

@property (nonatomic, assign) uint8_t x;
@property (nonatomic, assign) uint8_t y;

- (id)initWithX:(uint8_t)aX y:(uint8_t)aY;

- (void)draw;

- (BOOL)intersects:(GameObject *)anotherObject;
- (NSRect)toRect;

@end
