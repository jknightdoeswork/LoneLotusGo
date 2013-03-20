//
//  Player.m
//  FirstCoco
//
//  Created by Brendan King on 13-01-26.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize flag;
+(Player*) playerWithFlag:(PlayerFlag)flag {
    Player* new_player = [Player new];
    if (new_player != nil) {
        [new_player setFlag:flag];
    }
    return [new_player autorelease];
}
@end
