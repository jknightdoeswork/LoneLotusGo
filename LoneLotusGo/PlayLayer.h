//
//  PlayLayer.h
//  FirstCoco
//
//  Created by Brendan King on 13-01-19.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "LLBaseLayer.h"
#import "LLMenu.h"
#import "cocos2d.h"
#import "OnlineBoard.h"
#import "NavBar.h"
#import "Matchmaker.h"

@interface PlayLayer : LLBaseLayer<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, NextTurnDelegate, NavBarDelegate, LLMenuDelegate, OnlineBoardDelegate, MatchmakerDelegate>
    @property(retain) OnlineBoard* board;

// Returns a CCScene with only this layer added
+(CCScene *) scene;
+(CCScene*) loadExistingGame:(NSString*)boardId;
+(CCScene*) startNewOnlineGame:(NSString*)otherUsersId;
-(void)receivedPushedBoardId:(NSString*)pushedBoardId;
@end
