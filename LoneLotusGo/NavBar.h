//
//  NavBar.h
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-27.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//
#import "CCLayer.h"
#import "OnlineBoard.h"
#import "CCLabelAtlas.h"

@protocol NavBarDelegate <NSObject>
-(void)clickedNavIcon;
-(void)clickedPass;
-(void)clickedRefresh;
-(void)clickedSave;
@end

@interface NavBar : CCLayer
@property(retain) CCLabelTTF* blackPlayerName;
@property(retain) CCLabelTTF* whitePlayerName;
@property(retain) CCLabelAtlas* score_atlas;
@property(retain) CCLabelTTF* blackcaps;
@property(retain) CCLabelTTF* whitecaps;
@property(assign) int notifCount;
@property(assign) CCNode<NavBarDelegate>* delegate;

/**
 * Adjusts the children's position to a screensize.
 */
-(void)setScreenSize:(CGSize)size;

/**
 * Changes the color of player names, indicating whos turn it is.
 */
-(void)setActivePlayer:(PlayerFlag)flag;

/**
 * Updates the count of notifications by filtering the list of boardDisplayDicts and counting
 * games that are the current players turn and are online, ignoring the active board from the count.
 */
-(void)countNotifications:(NSArray*)boardDisplayDicts ignoreBoardId:(NSString*)activeBoard;
@end
