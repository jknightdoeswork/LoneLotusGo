//
//  LLMainMenu.h
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-24.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#import "PlayLayer.h"

@protocol LLMainMenuDelegate <NSObject>

-(void)play;
-(void)signIn;
-(void)signOut;
-(void)matchmaking;
@end
@interface LLMainMenu : CCNode
@property(assign) NSObject<LLMainMenuDelegate>* delegate;
-(void)setScreenSize:(CGSize)size;
-(void) onUserChange;
@end
