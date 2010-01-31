//
//  GameObject.h
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "Types.h"

@interface GameObject : NSObject {
  @private
	uint8_t _x;
	uint8_t _y;
}

@property (nonatomic, assign) uint8_t x;
@property (nonatomic, assign) uint8_t y;

- (id)initWithX:(uint8_t)x y:(uint8_t)y;

- (void)draw;

- (BOOL)intersects:(GameObject *)anotherObject;
- (NSRect)toRect;

@end
