//
//  Chain.h
//  LoneLotusGo
//
//  Created by Brendan King on 13-02-06.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import <Foundation/Foundation.h>
@class Stone;

@interface Chain : NSObject
/**
 * Adds a stone to this chain.
 */

-(void)addStone:(Stone*)stone;
/**
 * Returns true if the chain has an adjacent empty space.
 */
-(BOOL) hasLiberty;

/**
 * Check's liberty and deletes all stones if it is zero.
 */
-(void) prune;

/**
 * Merges 2 chains together retaining uniqueness among the elements.
 */
-(void)mergeChains:(Stone*)other;

@end
