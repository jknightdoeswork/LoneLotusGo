//
//  PlayLayer.h
//  FirstCoco
//
//  Created by Brendan King on 13-01-19.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "Board.h"
#import "Scoreboard.h"

@interface PlayLayer : CCScene {
    Board *board;

}
// Returns a CCScene with only this layer added
+(CCScene *) scene;

// Advance the current player
//-(void) nextTurn;
@end
