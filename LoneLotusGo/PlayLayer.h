//
//  PlayLayer.h
//  FirstCoco
//
//  Created by Brendan King on 13-01-19.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "OnlineBoard.h"
#import "Scoreboard.h"
#import "NavBar.h"

@interface PlayLayer : CCScene {
    OnlineBoard *board;

}
// Returns a CCScene with only this layer added
+(CCScene *) scene;

// Advance the current player
//-(void) nextTurn;
@end
