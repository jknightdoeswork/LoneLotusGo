//
//  Stone.m
//  FirstCoco
//
//  Created by Jason W. Knight, Saskatoon, Canada on 13-01-26.
//  Permission is granted to use my code provided you leave my name in.
//

#import "Stone.h"
#import "Board.h"

@implementation Stone {
    Board* parentBoard;
    PlayerFlag playerFlag;
}
@synthesize i;
@synthesize j;

/**
 * Initializes this stone sprite under the supplied board
 */
-(id)initForGoGame:(Board*) board for_player:(PlayerFlag)pf x_index:(int)x_index y_index:(int)y_index {
    self = [self initWithPlayerFlag:pf];
    if (self) {
        parentBoard     = board;
        self.i          = x_index;
        self.j          = y_index;
        
        [self setScale:INITIAL_SCALE];
        [self setPosition:CGPointMake(x_index * [board ws], y_index * [board ws])];
    }
    return self;
}

-(void)removeFromGame{
    [parentBoard removeStone:self];
}

/**
 * Counts the number of adjacent empty spaces and returns that count.
 */
-(int)countLiberties
{
    int to_return = 0;

    if ([self i] > 1 && [parentBoard getLeftNeighbour:[self i] j:[self j]] == nil) to_return++; //left
    if ([self i] < [parentBoard n]-1 && [parentBoard getRightNeighbour:[self i] j:[self j]] == nil) to_return++; //right
    if ([self j] < [parentBoard n]-1 && [parentBoard getTopNeighbour:[self i] j:[self j]] == nil) to_return++; //top
    if ([self j] > 1 && [parentBoard getBottomNeighbour:[self i] j:[self j]] == nil) to_return++; //bottom
    
    NSLog(@"%dx%d\tLib=%d", [self i], [self j], to_return);
    return to_return;
}

/**
 * Calls each 
 */
-(void)updateNeighbours {
    NSArray* neighbours = [self getNeighbours];
    [self shallILive];    
    for (Stone* neighbour in neighbours) {
        if ([neighbour playerFlag] != [self playerFlag]) {
            [neighbour shallILive];
        }
    }
}

-(BOOL)shallILive {
    NSSet* my_chain = [self getChain];
    BOOL i_shall_live = false;
    for (Stone* stone in my_chain) {
        if ([stone hasLiberty]) {
            i_shall_live = true;
            break;
        }
    }
    if (!i_shall_live) {
        for (Stone* stone in my_chain) {
            [stone removeFromGame];
        }
    }
    return i_shall_live;
}

/**
 * Returns an autoreleased NSSet of the stones connected to this stone
 */
-(NSSet*)getChain {
    NSMutableSet* chain = [NSMutableSet set];
    [self _getChainRecursive:chain];
    return chain;
}

/**
 * Uses depth first recursion to add all the pieces in this stones chain to the supplied set.
 **/
-(void)_getChainRecursive:(NSMutableSet*)set {
    [set addObject:self];
    for (Stone* neighbour in [self getNeighbours]) {
        if ([self playerFlag] == [neighbour playerFlag]) {
            if (![set containsObject:neighbour]) {
                [neighbour _getChainRecursive:set];
            }
        }
    }
}

-(NSArray*)getNeighbours {
    NSMutableArray* to_return = [NSMutableArray arrayWithCapacity:4];
    
    Stone* left_neighbour = [parentBoard getLeftNeighbour:[self i] j:[self j]];
    if (nil != left_neighbour) [to_return addObject:left_neighbour];
    
    Stone* right_neighbour = [parentBoard getRightNeighbour:[self i] j:[self j]];
    if (nil != right_neighbour) [to_return addObject:right_neighbour];
    
    Stone* top_neighbour = [parentBoard getTopNeighbour:[self i] j:[self j]];
    if (nil != top_neighbour) [to_return addObject:top_neighbour];
    
    Stone* bottom_neighbour = [parentBoard getBottomNeighbour:[self i] j:[self j]];
    if (nil != bottom_neighbour) [to_return addObject:bottom_neighbour];
    
    return to_return;
}

/**
 * Returns true on the first sight of an adjacent empty space.
 */
-(bool)hasLiberty
{
    return [self countLiberties] > 0;
}

-(PlayerFlag)playerFlag {
    return self.playerFlag;
}

-(void)setPlayerFlag:(PlayerFlag)flag {
    if (flag == P_BLACK) {
        playerFlag = flag;
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: @"stone_black.png"];
        [self setTexture:texture];
    }
    else if (flag == P_WHITE) {
        playerFlag = flag;
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: @"stone_white.png"];
        [self setTexture:texture];
    }
}
-(bool)isUnplacedStone {
    return i == -1 && j == -1;
}
-(id)initWithPlayerFlag:(PlayerFlag) flag {
    if (flag == P_BLACK) {
        playerFlag = flag;
        return [self initWithFile:@"stone_black.png"];
    }
    else if (flag == P_WHITE) {
        playerFlag = flag;
        return [self initWithFile:@"stone_white.png"];
    }
    else if (flag == P_UNDEFINED) {
        playerFlag = flag;
        return [super init];
    }
    else {
        NSLog(@"ERROR: Unrecognized Player Flag");
        return [super init];
    }
}

-(int)getXIndex {
    return i;
}
-(int)getYIndex {
    return j;
}
@end
