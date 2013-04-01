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
-(void)clickedNavBarBoardId:(NSString*)boardId;
@end


@interface NavBar : CCLayer
@property(retain) PFLogInViewController* logInController;
@property(retain) CCLabelAtlas* score_atlas;
@property(assign) CCNode<NavBarDelegate>* delegate;

/**
 * Adjusts the children's position to a screensize.
 */
-(void)setScreenSize:(CGSize)size;

-(void) updateNavBarMenu;
@end
