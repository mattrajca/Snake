//
//  Food.h
//  Snake
//
//  Copyright Matt Rajca 2009. All rights reserved.
//

#import "GameObject.h"

@class Snake;

@interface Food : GameObject {

}

- (void)relocateWithSnake:(Snake *)snake;

@end
