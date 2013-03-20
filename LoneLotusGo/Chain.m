//
//  Chain.m
//  LoneLotusGo
//
//  Created by Brendan King on 13-02-06.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "Chain.h"
#import "Stone.h"
@interface Chain ()
@property(nonatomic, retain) NSMutableSet* set;
@end

@implementation Chain
{
}
@synthesize set;

-(id)init {
    self = [super init];
    if (self) {
        self.set = [NSMutableSet set];
    }
    return self;
}

-(void)dealloc {
    [set release];
    [super dealloc];
}

-(void)addStone:(Stone*)stone {
    [[self set] addObject:stone];
}

/**
 * Returns true if one of the stones has liberty.
 */
-(BOOL) hasLiberty {
    for (Stone *item in [self set]) {
        if ([item hasLiberty]) {
            return true;
        }
    }
    return false;
}

/**
 * Gets Liberties and prunes if it is zero.
 */
-(void) prune {
    if(![self hasLiberty]) {
        for (Stone* stone in [self set]) {
            [stone removeFromGame];
        }
        [[self set] removeAllObjects];
    }
}

/**
 * Merges 2 chains together, keeping a unique property, returning a new, autoreleased chain.
 */
-(void)mergeChains:(Stone*)other {
    Chain* other_chain = [other chain];
    for (Stone* stone in other_chain) {
        [[self set] addStone:stone];
    }
    [other_chain removeAllObjects];
    [other setChain:self];
    NSLog(@"Merged Chain Length:\t%d", [[self set] count]);
}

@end
