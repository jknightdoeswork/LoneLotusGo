//
//  Stone.h
//  FirstCoco
//
//  Created by Jason W. Knight, Saskatoon, Canada on 13-01-26.
//  Permission is granted to use my code provided you leave my name in.
//

#import "CCSprite.h"
#import "PlayerFlag.h"

@class Board;

#define INITIAL_SCALE 0.5f

@interface Stone : CCSprite
@property(nonatomic) int i;
@property(nonatomic) int j;

/**
 * Initializes this stone sprite under the supplied board at the given index location.
 */
-(id)initForGoGame:(Board*) board for_player:(PlayerFlag)pf x_index:(int)x_index y_index:(int)y_index;

/**
 * Updates all the neighbours of this stone, and this stone, to make sure they can live on the board.
 */
-(void)updateNeighbours;

@end
