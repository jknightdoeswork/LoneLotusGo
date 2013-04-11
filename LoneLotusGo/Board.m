//
//  Board.m
//  FirstCoco
//
//  Created by Brendan King on 13-01-20.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "Board.h"
#import "Stone.h"
#import "scoring.c"
#define TOP_DIRECTION       't'
#define BOTTOM_DIRECTION    'b'
#define LEFT_DIRECTION      'l'
#define RIGHT_DIRECTION     'r'

@implementation Board{
    float previous_double_touch_distance;
    CGPoint previous_double_touch_center;
    char* board_as_string;
    int score;
    BOOL isMoving;
}
@synthesize currentPlayer;
@synthesize n;
@synthesize ws;
@synthesize unplacedStone;
@synthesize justpassed;
@synthesize gameOver;

-(id)initBoard:(int) cap {
    if(self = [self initWithFile:@"board.gif"]) {
        [[[CCDirector sharedDirector]touchDispatcher] addStandardDelegate:self priority:2];
        self.isTouchEnabled = YES;
        self.n = cap;

        // set rendering params
        CGSize size = [[CCDirector sharedDirector] winSize];

        // Scale
        float x_scale = size.width / self.contentSize.width;    
        float y_scale = size.height / self.contentSize.height;
        [self setScale:MIN(x_scale, y_scale)];
        NSLog(@"Initial Scale: %f", MIN(x_scale, y_scale));

        // Position
        [self setPosition:ccp(size.width/2, size.height/2)];
        NSLog(@"Board texture size: %.2f x %.2f", self.contentSize.width, self.contentSize.height);
        
        // Initial player
        [self setCurrentPlayer:P_BLACK];

        // width of boxes
        self.ws = floorf((self.contentSize.width) / (n-1));
        NSLog(@"WS: %.2f", ws);
                
        // pass
        self.justpassed = NO;
        self.gameOver = NO;
        
        //caps
        [self setBlackcaps:0];
        [self setWhitecaps:0];

        self.unplacedStone = [[Stone alloc] initForGoGame:self for_player:[self currentPlayer] x_index:-1 y_index:-1];
        [self.unplacedStone setVisible:NO];
        [self addChild:self.unplacedStone z:2];
        
        // Sent to scorer.
        board_as_string = malloc(sizeof(char)* (n*n + 1));
        for(int t = 0; t < n*n; t++) {
            board_as_string[t] = P_UNDEFINED;
        }
        board_as_string[n*n] = '\0';
    }
    return self;
}

-(void) reset {
    // TODO make use of reset in init
    [self removeAllChildrenWithCleanup:YES];
    [[self unplacedStone] setVisible:NO];
    [self addChild:self.unplacedStone z:2];
    [self setCurrentPlayer:P_BLACK];
    [self setJustpassed:NO];
    [self setGameOver:NO];
    [self setBlackcaps:0];
    [self setWhitecaps:0];
}

-(void) pass {
    if([self justpassed]) {
        NSLog(@"Game over");
        [self setCurrentPlayer:P_UNDEFINED];
        [self setGameOver:YES];
        [self.delegate gameOver];
    }
    [self setJustpassed:YES];
    [self nextTurn];
}

-(int)getScore {
    return score;
}

-(void)dealloc {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    NSLog(@"Board being deallocated");
    [super dealloc];
}

/**
 * Returns true if the touch was for this board. Used to prevent the board using navbar touches to place pieces.
 */
-(BOOL) claimTouches:(NSSet*)touches {
    if([touches count] == 1) {
        return [self claimTouch:[touches anyObject]];
    }
    else if([touches count] == 2) {
        NSArray* touchesArray = [touches allObjects];
        return [self claimTouch:[touchesArray objectAtIndex:0]] && [self claimTouch:[touchesArray objectAtIndex:1]];
    }
    else {
        return NO;
    }
}

/**
 * Helper function with hard coded nav bar sizes to avoid claiming nav bar touches as piece entries.
 */
-(BOOL)claimTouch:(UITouch*) touch {
    float max_y                         = [[CCDirector sharedDirector] winSize].height - 32; // nav bar is 32 pixels high
    float max_nav_icon_y                = [[CCDirector sharedDirector] winSize].height - 50; // top right icon is 50 x 50
    float max_nav_icon_x                = [[CCDirector sharedDirector] winSize].width - 50;
    CGPoint touchLocation = [self getScreenTouchLocation:touch];
    if (touchLocation.x < max_nav_icon_x) {
        return touchLocation.y < max_y;
    } else {
        return touchLocation.y < max_nav_icon_y;
    }
}

-(CGPoint)getScreenTouchLocation:(UITouch*)touch {
    return [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
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
    if(!self.isTouchEnabled) return;
    if(![self claimTouches:touches]) return;
	if ([touches count] == 1) {
        NSLog(@"Single Touch Start");
        // reset double touch in case touches are at different times
        previous_double_touch_distance      = 0;
		UITouch *touch                      = [touches anyObject];
        CGPoint transformed_location        = [self getBoardTouchLocation:touch];
        int i                               = round(transformed_location.x / (ws));
        int j                               = round(transformed_location.y / (ws));

        if ([self canPutPieceAt:i y_index:j]) {
            [unplacedStone setPlayerFlag:[self currentPlayer]];
            [unplacedStone setPosition:CGPointMake(i * ws, j * ws)];
            [unplacedStone setVisible:YES];
        }
	} else if ([touches count] == 2) {
        NSLog(@"Double Touch Start");
        previous_double_touch_distance = [self getDoubleTouchDistance:touches];
        previous_double_touch_center = [self getDoubleTouchCenter:touches];
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.isTouchEnabled) return;
    if(![self claimTouches:touches]) return;
	if ([touches count] == 1) {
        NSLog(@"Single Touch Moved: %d", [touches count]);
        // reset double touch in case touches are at different times
        previous_double_touch_distance      = 0;
        CGPoint transformed_location        = [self getBoardTouchLocation:[touches anyObject]];
        int i                               = round(transformed_location.x / (ws));
        int j                               = round(transformed_location.y / (ws));
        if ([self canPutPieceAt:i y_index:j]) {
            [unplacedStone setPlayerFlag:[self currentPlayer]];
            [unplacedStone setPosition:CGPointMake(i * ws, j * ws)];
            [unplacedStone setVisible:YES];
        }
	} else if ([touches count] == 2) {
        // Move board
        [unplacedStone setVisible:NO];
        CGPoint double_touch_center = [self getDoubleTouchCenter:touches];
        CGPoint to_move = ccpSub(double_touch_center, previous_double_touch_center);
        to_move = ccpMult(to_move, [self scale]);
        CGPoint current_position = [self position];
        CGPoint new_position = ccpAdd(current_position, to_move);
        NSLog(@"POS: %.1f x %.1f", new_position.x, new_position.y);
        CGSize maxSize = [[CCDirector sharedDirector] winSize];
        if (new_position.x > maxSize.width * 0.75){
            NSLog(@"clamping max X");
            new_position.x = maxSize.width * 0.75;
        }
        if (new_position.x < 0){
            NSLog(@"clamping min X");
            new_position.x = 0;
        }
        if (new_position.y > maxSize.height * 0.75){
            NSLog(@"clamping max Y");
            new_position.x = maxSize.height * 0.75;
        }
        if (new_position.y < 0){
            NSLog(@"clamping min y");
            new_position.y = 0;
        }
        
        [self setPosition:new_position];
        
        // Zoom Board
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
			if (self.scale > 0.80f) {
				self.scale *= 0.95f;
			}
			previous_double_touch_distance = currentDistance;
		}
	}
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.isTouchEnabled) return;
    if(![self claimTouches:touches]) return;
    if ([touches count] == 1) {
        [unplacedStone setVisible:NO];
        CGPoint transformed_location        = [self getBoardTouchLocation:[touches anyObject]];
        int i                               = round(transformed_location.x / (ws));
        int j                               = round(transformed_location.y / (ws));
        if ([self canPutPieceAt:i y_index:j]) {
            Stone* new_stone = [[Stone alloc] initForGoGame:self for_player:[self currentPlayer] x_index:i y_index:j];
            int index =[self get_index:i j:j];
            [self addChild:new_stone z:1.0 tag:index];
            board_as_string[index] = [self currentPlayer];
            score = score_input(board_as_string);
            NSLog(@"Score: %d", score);
            [new_stone updateNeighbours];
            [new_stone release]; // we retain through addChild
            [self setJustpassed:NO];
            [self nextTurn];
        }
	}
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        [unplacedStone setVisible:NO];
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
    if([stone playerFlag] == P_WHITE) {
        [self setBlackcaps:self.blackcaps+1];
    }else if([stone playerFlag] == P_BLACK) {
        [self setWhitecaps:self.whitecaps+1];
    }
    int stone_key = [self get_index:[stone i] j:[stone j]];
    [self removeChildByTag:stone_key cleanup:TRUE];
}

/**
 * Return true if a user can place a piece at a given point.
 */
-(BOOL)canPutPieceAt:(int)x_index y_index:(int)y_index {
    if (x_index < 0 || x_index >= self.n || y_index < 0 || y_index >= self.n) {
        return NO;
    }
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
    if (x_index >= 0 && x_index <= n && y_index >= 0 && y_index <= n)
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
    [self.delegate nextTurn];
}
@end