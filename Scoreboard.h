//
//  Scoreboard.h
//  LoneLotusGo
//
//  Created by Brendan King on 13-02-16.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "cocos2d.h"

@interface Scoreboard : CCNode
-(id)initWithScores:(int)white black:(int)black;

-(void)setScores:(int)white black:(int)black;

-(void)setWhiteScore:(int)white;

-(void)setBlackScore:(int)black;

-(void)incrementWhiteScore:(int)with_value;

-(void)incrementBlackScore:(int)with_value;

-(void)incrementScores:(int)white_value black_value:(int)black_value;
@end
