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
@property(assign) CCNode<NavBarDelegate>* delegate;

/**
 * Adjusts the children's position to a screensize.
 */
-(void)setScreenSize:(CGSize)size;

/**
 * Changes the color of player names, indicating whos turn it is.
 */
-(void)setActivePlayer:(PlayerFlag)flag;
@end
