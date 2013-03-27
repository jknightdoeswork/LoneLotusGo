//
//  Board.h
//  FirstCoco
//
//  Created by Brendan King on 13-01-20.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "cocos2d.h"
#import "PlayerFlag.h"
#import "Chain.h"
#import "Scoreboard.h"
@class Stone;

@interface Board : CCSprite <CCStandardTouchDelegate>
@property(atomic) int score;
@property(atomic) PlayerFlag currentPlayer;
@property(nonatomic, retain) NSMutableDictionary* b; // mapping of (Index) -> (Stone) or (NSNull)
@property(nonatomic) float ws;  // Width of the boxes
@property(nonatomic) int n;     // Size of board
@property(nonatomic, retain) Scoreboard* scoreboard;

/**
 * Returns the piece stored at the given index or nil if bad index or no piece.
 */
-(Stone*)getPieceAt:(int)x_index y_index:(int)y_index;

/**
 * Initializes a board with enough room for nxn pieces.
 */
-(id)initBoard:(int) n s_board:(Scoreboard*)s_board;

/**
 * Returns the neighbour of the point if availible, or nil if that's spot's empty or off the board.
 */
-(Stone*) getLeftNeighbour:(int)i j:(int)j;
-(Stone*) getRightNeighbour:(int)i j:(int)j;
-(Stone*) getTopNeighbour:(int)i j:(int)j;
-(Stone*) getBottomNeighbour:(int)i j:(int)j;

/**
 * Removes a stone from the game.
 */
-(void)removeStone:(Stone*)stone;

/**
 * Returns a 1D index using the size of the board for the 2D piece location.
 */
-(int)get_index:(int)i j:(int)j;
@end
