//
//  Board.m
//  FirstCoco
//
//  Created by Brendan King on 13-01-20.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "Board.h"
#import "Stone.h"

#define TOP_DIRECTION       't'
#define BOTTOM_DIRECTION    'b'
#define LEFT_DIRECTION      'l'
#define RIGHT_DIRECTION     'r'

@implementation Board{
    Stone*  unplacedStone;
    float previous_double_touch_distance;
    CGPoint previous_double_touch_center;
}
@synthesize b;
@synthesize score;
@synthesize currentPlayer;
@synthesize n;
@synthesize ws;
@synthesize scoreboard;

-(id)initBoard:(int) cap s_board:(Scoreboard*)s_board {
    if(self = [self initWithFile:@"go.gif"]) {
        self.n = cap;
        self.scoreboard = s_board;
        // set rendering params
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // Scale
        float x_scale = size.width / self.contentSize.width;    
        float y_scale = size.height / self.contentSize.height;
        [self setScale:MIN(x_scale, y_scale)];

        // Position
        [self setPosition:ccp(size.width/2, size.height/2)];
        NSLog(@"Board texture size: %.2f x %.2f", self.contentSize.width, self.contentSize.height);
        
        // Initial player
        [self setCurrentPlayer:P_BLACK];
        
        // width of boxes
        self.ws = floorf((self.contentSize.width) / n);
        NSLog(@"WS: %.2f", ws);
        
        // init board data
        self.b = [NSMutableDictionary dictionaryWithCapacity:n*n];

        [[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:0];
        
        unplacedStone = nil;
    }
    return self;
}

-(void)dealloc {
    NSLog(@"Board being deallocated");
    [[self b] removeAllObjects];
    [super dealloc];
}

// Handle input a half square outside the board
-(BOOL) claimTouch:(UITouch*)touch {
    CGPoint transformed_location = [self getBoardTouchLocation:touch];
    float max_size                      = ([self n]+0.499f) * [self ws];
    float min_size                      = (-0.499f) * [self ws];
    return (min_size < transformed_location.x && transformed_location.x < max_size &&
            min_size < transformed_location.y && transformed_location.y < max_size);

}

-(CGPoint)getBoardTouchLocation:(UITouch*)touch {
    return [self convertToNodeSpace: [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]]];
}

-(float)getDoubleTouchDistance:(NSSet*)touches {
    NSArray *twoTouch = [touches allObjects];
    UITouch *tOne = [twoTouch objectAtIndex:0];
    UITouch *tTwo = [twoTouch objectAtIndex:1];
    CGPoint firstTouch = [tOne locationInView:[tOne view]];
    CGPoint secondTouch = [tTwo locationInView:[tTwo view]];
    return sqrt(pow(firstTouch.x - secondTouch.x, 2.0f) + pow(firstTouch.y - secondTouch.y, 2.0f));
}

-(CGPoint)getDoubleTouchCenter:(NSSet*)touches {
    NSArray *twoTouch = [touches allObjects];
    UITouch *tOne = [twoTouch objectAtIndex:0];
    UITouch *tTwo = [twoTouch objectAtIndex:1];
    CGPoint firstTouch = [tOne locationInView:[tOne view]];
    CGPoint secondTouch = [tTwo locationInView:[tTwo view]];
    return ccpLerp(firstTouch, secondTouch, 0.5f);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([touches count] == 1) {
        // reset double touch in case touches are at different times
        previous_double_touch_distance      = 0;
		UITouch *touch                      = [touches anyObject];
        CGPoint transformed_location        = [self getBoardTouchLocation:touch];
        int i                               = round(transformed_location.x / (ws));
        int j                               = round(transformed_location.y / (ws));

        if ([self canPutPieceAt:i y_index:j]) {
            if (nil == unplacedStone) {
                NSLog(@"TapDown New Child");
                unplacedStone = [[Stone alloc] initForGoGame:self for_player:[self currentPlayer] x_index:i y_index:j];
                [self addChild:unplacedStone];
            }
            else {
                NSLog(@"WARNING SingleTapDown. Removing stone.");
                // Weird error case where touch began before proper touch ending
                [self removeChild:unplacedStone cleanup:YES];
                [unplacedStone release];
                unplacedStone = nil;
            }
        }
	} else if ([touches count] == 2) {
        NSLog(@"Double Touch Start");
        previous_double_touch_distance = [self getDoubleTouchDistance:touches];
        previous_double_touch_center = [self getDoubleTouchCenter:touches];
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([touches count] == 1) {
        // reset double touch in case touches are at different times
        previous_double_touch_distance      = 0;
        CGPoint transformed_location        = [self getBoardTouchLocation:[touches anyObject]];
        int i                               = round(transformed_location.x / (ws));
        int j                               = round(transformed_location.y / (ws));
        if ([self canPutPieceAt:i y_index:j]) {
            if (nil == unplacedStone) {
                NSLog(@"WARNING TapMove new child");
                // Weird error case where touch moved without touch began
                // unplacedStone = [[Stone alloc] initForGoGame:self for_player:[self currentPlayer] x_index:i y_index:j];
                // [self addChild:unplacedStone];
            } else {
                NSLog(@"TapMove Move Stone");
                // move unplaced stone
                [unplacedStone setPosition:CGPointMake(i * ws, j * ws)];
            }
        }
	} else if ([touches count] == 2) {
        NSLog(@"ccTouchesMoved double touch");
        
        // Move board
        CGPoint double_touch_center = [self getDoubleTouchCenter:touches];
        CGPoint to_move = ccpSub(double_touch_center, previous_double_touch_center);
        to_move = ccpMult(to_move, [self scale]);
        CGPoint current_position = [self position];
        CGPoint new_position = ccpAdd(current_position, to_move);
        NSLog(@"POS: %.1f x %.1f", new_position.x, new_position.y);
        // TODO: Clamp new position, min_x, min_y etc
        [self setPosition:new_position];
        previous_double_touch_center = double_touch_center;
        
        float currentDistance = [self getDoubleTouchDistance:touches];
		if (previous_double_touch_distance == 0) {
			previous_double_touch_distance = currentDistance;
		} else if (currentDistance - previous_double_touch_distance > 0) {
            // zoom in
			if (self.scale < 2.0f) {
				self.scale *=  1.05f;
			}
			previous_double_touch_distance = currentDistance;
		} else if (currentDistance - previous_double_touch_distance < 0) {
            // zoom out
			if (self.scale > 0.5f) {
				self.scale *= 0.95f;
			}
			previous_double_touch_distance = currentDistance;
		}
	}
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        CGPoint transformed_location        = [self getBoardTouchLocation:[touches anyObject]];
        int i                               = round(transformed_location.x / (ws));
        int j                               = round(transformed_location.y / (ws));
        if (nil == unplacedStone) {
            NSLog(@"WARNING TapUp New Child");
            // Weird error case where touch ended without proper touch began
            unplacedStone = [[Stone alloc] initForGoGame:self for_player:[self currentPlayer] x_index:i y_index:j];
            [self addChild:unplacedStone z:1.0 tag:[self get_index:i j:j]];
            [self nextTurn];
            [unplacedStone updateNeighbours];
            [unplacedStone release]; // we retain through addChild
            unplacedStone = nil;
        } else {
            NSLog(@"TapUp Placing Child");
            // place the unplaced stone by retagging it advancing turn, updating board state
            [self removeChild:unplacedStone cleanup:YES];
            [self addChild:unplacedStone z:1.0 tag:[self get_index:i j:j]];
            [self nextTurn];
            [unplacedStone updateNeighbours];
            [unplacedStone release]; // we retain through addChild
            unplacedStone = nil;
        }
//        [self updateScores];
	}
}

//-(void)updateScores {
//    int black_score = 0;
//    int white_score = 0;
//    PlayerFlag left_color, right_color, bottom_color, top_color, currentColor;
//    for (int x=0; x<[self n]; x++) {
//        for(int y=0; y<[self n]; y++) {
//            if ([self getPieceAt:x y_index:y] == nil) {
//                currentColor = left_color = [self _getNearestNeighbourColorRecursive:LEFT_DIRECTION x:x-1 y:y];
//                right_color = [self _getNearestNeighbourColorRecursive:RIGHT_DIRECTION x:x+1 y:y];
//                if (right_color == currentColor) {
//                    top_color = [self _getNearestNeighbourColorRecursive:TOP_DIRECTION x:x y:y+1];
//                    if (top_color == right_color) {
//                        bottom_color = [self _getNearestNeighbourColorRecursive:BOTTOM_DIRECTION x:x y:y-1];
//                        if (bottom_color == right_color) {
//                            // This means this is an empty space surrounded by a single color
//                            if (current_color == P_WHITE) {
//                                white_score++;
//                            }else {
//                                black_score++;
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    [[self scoreboard] setScores:white_score black:black_score];
//}
/**
 * Returns the nearest playerflag in the given direction for the specified spot, 
 */
-(PlayerFlag)_getNearestNeighbourColorRecursive:(char)direction x:(int)x y:(int)y {
    if (!(0 <= x && x < [self n] && 0 <= y && y < [self n])) {
        return P_UNDEFINED;
    }
    Stone* current = [self getPieceAt:x y_index:y];
    if (current != nil) {
        return [current playerFlag];
    }
    
    switch (direction) {
        case TOP_DIRECTION:
            return [self _getNearestNeighbourColorRecursive:TOP_DIRECTION x:x y:y+1];
        case BOTTOM_DIRECTION:
            return [self _getNearestNeighbourColorRecursive:BOTTOM_DIRECTION x:x y:y-1];
        case LEFT_DIRECTION:
            return [self _getNearestNeighbourColorRecursive:LEFT_DIRECTION x:x-1 y:y];
        case RIGHT_DIRECTION:
            return [self _getNearestNeighbourColorRecursive:RIGHT_DIRECTION x:x+1 y:y];
        default:
            NSLog(@"ERROR: _getNeighbourColorRecursive Unknown Direction %c", direction);
            break;
    }
    return P_UNDEFINED;
}


/**
 * Removes the stone from the dictionary representation.
 */
-(void)removeStone:(Stone*)stone {
    int stone_key = [self get_index:[stone i] j:[stone j]];
    [self removeChildByTag:stone_key cleanup:TRUE];
}

/**
 * Return true if a user can place a piece at a given point.
 */
-(BOOL)canPutPieceAt:(int)x_index y_index:(int)y_index {
    int stone_key = [self get_index:x_index j:y_index];
    return ([self getChildByTag:stone_key] == nil);
}

/**
 * Return true if a user can place a piece at a given point.
 */
-(int)get_index:(int)i j:(int)j {
    return (i*n)+j;
}

/**
 * Returns the piece stored at the given index or nil if bad index or no piece.
 */
-(Stone*)getPieceAt:(int)x_index y_index:(int)y_index
{
    if (x_index > 0 && x_index < n && y_index > 0 && y_index < n)
    {
        return (Stone*)[self getChildByTag:[self get_index:x_index j:y_index]];
    }
    return nil;
}
/**
 * Calculates the index of the specified neighbour and returns it or nil if there is no neighbour.
 */
-(Stone*) getLeftNeighbour:(int)i j:(int)j
{
    return [self getPieceAt:(i-1) y_index:j];
}
-(Stone*) getRightNeighbour:(int)i j:(int)j
{
    return [self getPieceAt:(i+1) y_index:j];
}
-(Stone*) getTopNeighbour:(int)i j:(int)j
{
    return [self getPieceAt:i y_index:(j+1)];
}
-(Stone*) getBottomNeighbour:(int)i j:(int)j
{
    return [self getPieceAt:i y_index:(j-1)];
}

/**
 * Advances the turn to the next player.
 */
-(void) nextTurn {
    if ([self currentPlayer] == P_WHITE) {
        [self setCurrentPlayer:P_BLACK];
    }else if([self currentPlayer] == P_BLACK) {
        [self setCurrentPlayer:P_WHITE];
    }else {
        NSLog(@"ERROR: Unrecognized current player");
    }
    NSLog(@"Next Turn: %c", [self currentPlayer]);
}
@end