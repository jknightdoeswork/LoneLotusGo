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

@class Stone;
@protocol NextTurnDelegate <NSObject>
-(void)nextTurn;
-(void)gameOver;
@end
@interface Board : CCSprite <CCStandardTouchDelegate>
@property(atomic) PlayerFlag currentPlayer;
@property(nonatomic) float ws;  // Width of the boxes
@property(nonatomic) int n;     // Size of board
@property(nonatomic) BOOL justpassed;
@property(nonatomic) BOOL gameOver;
@property(retain) Stone* unplacedStone; // holds the stone that floats around when touching
@property(assign) CCNode<NextTurnDelegate>* delegate;
@property(nonatomic, assign) BOOL isTouchEnabled;
@property(assign) int blackcaps;
@property(assign) int whitecaps;

/**
 * Returns the piece stored at the given index or nil if bad index or no piece.
 */
-(Stone*)getPieceAt:(int)x_index y_index:(int)y_index;

-(BOOL)canPutPieceAt:(int)x_index y_index:(int)y_index;
    
/**
 * Initializes a board with enough room for nxn pieces.
 */
-(id)initBoard:(int) n;
/**
 * Resets a board to a starting state.
 */
-(void) reset;

-(void) pass;
    
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

-(int)getScore;

-(void) nextTurn;
@end
