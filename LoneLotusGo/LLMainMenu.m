//
//  LLMainMenu.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-24.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "LLMainMenu.h"
#define PLAY_ONLINE_SUBMENU_TAG 1

@interface LLMainMenu () {
    CCMenu* menu;
    CCMenu* playOnlineMenu;
    bool playOnlineIsShown;
}
@end

@implementation LLMainMenu
-(id)initWithScreenSize:(CGSize)size {
    if (self == [super init]){
        
        [CCMenuItemFont setFontName:@"Zapfino"];
        [CCMenuItemFont setFontSize:18];

        // Top Level Menu Items
        CCMenuItem* itemPlay = [CCMenuItemFont itemWithString:@"Play Local" block:^(id sender) {
            [playOnlineMenu setVisible:NO];
            [[CCDirector sharedDirector] pushScene: [PlayLayer scene]];
        }];
//        [itemPlay setAnchorPoint:ccp(0.0f,0.5f)];
        CCMenuItem* itemPlayOnline = [CCMenuItemFont itemWithString:@"Play Online" block:^(id sender) {
            NSLog(@"Play Online Moving!");
            CGSize currentSize = [[CCDirector sharedDirector] winSize];
            if (playOnlineIsShown) {
                [menu runAction:[CCMoveTo actionWithDuration:0.33f position:ccp(currentSize.width/2.0f, currentSize.height/2.0f)]];
                [playOnlineMenu runAction:[CCFadeOut actionWithDuration:0.33f]];
                playOnlineIsShown = NO;
            }
            else {
                [menu runAction:[CCMoveTo actionWithDuration:0.33f position:ccp(currentSize.width*0.15, currentSize.height/2.0f)]];
                [playOnlineMenu runAction:[CCFadeIn actionWithDuration:0.33f]];
                playOnlineIsShown = YES;
            }
        }];
        // [itemPlayOnline setAnchorPoint:ccp(0.0f,0.5f)];

        // Play Online Sub Menu Items
        CCMenuItem* playOnlineChallengeFriend = [CCMenuItemFont itemWithString:@"Challenge" block:^(id sender) {
            NSLog(@"Challenged a friend");
        }];
        // [playOnlineChallengeFriend setAnchorPoint:ccp(0.0f, 0.5f)];
        CCMenuItem* playOnlineMatchmaking = [CCMenuItemFont itemWithString:@"Matchmaking" block:^(id sender) {
            NSLog(@"Entered Matchmaking");
        }];
        // [playOnlineMatchmaking setAnchorPoint:ccp(0.0f, 0.5f)];

        menu = [CCMenu menuWithItems:itemPlayOnline, itemPlay, nil];
        playOnlineMenu = [CCMenu menuWithItems:playOnlineChallengeFriend, playOnlineMatchmaking, nil];
        [playOnlineMenu setOpacity:0];
        playOnlineIsShown = NO;
        
        [playOnlineMenu alignItemsVerticallyWithPadding:10];
        [menu alignItemsVerticallyWithPadding:10];

        // Add the menu to the layer
        [self addChild:playOnlineMenu z:1];
        [self addChild:menu z:2];
        [self setScreenSize:size];
    }
    return self;
}

-(void)setScreenSize:(CGSize)size {
    [self setContentSize:size];
    [menu setPosition:ccp(size.width/2.0, size.height/2.0)];
    [playOnlineMenu setPosition:ccp(size.width/2.0, size.height/2.0)];
}

@end
