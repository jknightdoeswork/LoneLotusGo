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
}
@end

@implementation LLMainMenu
-(id)init {
    if (self == [super init]){
        
        [CCMenuItemFont setFontName:@"Zapfino"];
        [CCMenuItemFont setFontSize:18];

        // Top Level Menu Items
        CCMenuItem* play = [CCMenuItemFont itemWithString:@"Play Local" block:^(id sender) {
            [[self delegate] play];
        }];
        CCMenuItem* signIn = [CCMenuItemFont itemWithString:@"Log In" block:^(id sender) {
            [[self delegate] signIn];
        }];
        CCMenuItem* signOut = [CCMenuItemFont itemWithString:@"Log Out" block:^(id sender) {
            [[self delegate] signOut];
        }];
        CCMenuItem* matchmaking = [CCMenuItemFont itemWithString:@"Matchmaking" block:^(id sender) {
            [[self delegate] matchmaking];
        }];

//        CCMenuItem* challenge = [CCMenuItemFont itemWithString:@"Challenge" block:^(id sender) {
//            [[self delegate] challenge];
//        }];

        menu = [CCMenu menuWithItems:play, signIn, matchmaking, signOut, nil];
        
        [menu alignItemsVerticallyWithPadding:10];

        // Add the menu to the layer
        [self addChild:menu z:2];
    }
    return self;
}

-(void)setScreenSize:(CGSize)size {
    [self setContentSize:size];
    [menu setPosition:ccp(size.width/2.0, size.height/2.0)];
}

@end
