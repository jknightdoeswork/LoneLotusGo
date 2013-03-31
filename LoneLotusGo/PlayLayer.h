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

@interface PlayLayer : CCLayer<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CCTargetedTouchDelegate>
    @property(retain) OnlineBoard* board;

// Returns a CCScene with only this layer added
+(CCScene *) scene;
+(CCScene*) loadExistingGame:(NSString*)boardId;
+(CCScene*) startNewOnlineGame:(NSString*)otherUsersId;
    
// Advance the current player
//-(void) nextTurn;
@end
