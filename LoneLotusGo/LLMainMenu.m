//
//  LLMainMenu.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-24.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "LLMainMenu.h"
#define PLAY_ONLINE_SUBMENU_TAG 1

@implementation LLMainMenu
-(id)init {
    if (self == [super init]){
        // BEGIN CUSTOM CODE
        CCMenuItem* itemPlay = [CCMenuItemFont itemWithString:@"Play Local" block:^(id sender) {
            
            [[CCDirector sharedDirector] pushScene: [PlayLayer scene]];
            
        }];
        
        // Play Online Sub Menu
        CCMenuItem* playOnlineChallengeFriend = [CCMenuItemFont itemWithString:@"Challenge a friend" block:^(id sender) {
            NSLog(@"Challenged a friend");
        }];
        CCMenuItem* playOnlineMatchmaking = [CCMenuItemFont itemWithString:@"Matchmaking" block:^(id sender) {
            NSLog(@"Entered Matchmaking");
        }];
        CCMenu *playOnlineMenu = [CCMenu menuWithItems:playOnlineChallengeFriend, playOnlineMatchmaking, nil];
        [playOnlineMenu alignItemsVerticallyWithPadding:5];
        
        CCMenuItem* itemPlayOnline = [CCMenuItemFont itemWithString:@"Play Online" block:^(id sender) {
//            [[CCDirector sharedDirector] presentViewController:logInController animated:YES completion:nil];
        }];
        
        
        
        // END CUSTOM CODE
        
        CCMenu *menu = [CCMenu menuWithItems:itemPlay, itemPlayOnline, nil];
        
        [menu alignItemsVerticallyWithPadding:10];
//        [menu setPosition:ccp( size.width/2, size.height/2 - 50)];
//        [playOnlineMenu setPosition:ccp(poX, size.height/2 - 50)];
        // Add the menu to the layer
        [self addChild:menu];
        [self addChild:playOnlineMenu z:5 tag:PLAY_ONLINE_SUBMENU_TAG];
    }
    return self;
}
@end
