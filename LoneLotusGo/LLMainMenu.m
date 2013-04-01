//
//  LLMainMenu.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-24.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "LLMainMenu.h"
#define PLAY_ONLINE_SUBMENU_TAG 1

@interface LLMainMenu ()
@property(retain) CCMenu* menu;

@property(retain) CCMenuItem* signIn;
@property(retain) CCMenuItem* signOut;
@property(retain) CCMenuItem* play;
@property(retain) CCMenuItem* matchmaking;
@end

@implementation LLMainMenu
-(void) dealloc {
    [[self menu] release];
    [[self signIn] release];
    [[self signOut] release];
    [[self play] release];
    [[self matchmaking] release];
    [super dealloc];
}

-(id)init {
    if (self == [super init]){
        
        [CCMenuItemFont setFontName:@"Zapfino"];
        [CCMenuItemFont setFontSize:18];

        // Top Level Menu Items
        self.play = [CCMenuItemFont itemWithString:@"Play Local" block:^(id sender) {
            [[self delegate] play];
        }];
        self.signIn = [CCMenuItemFont itemWithString:@"Log In" block:^(id sender) {
            [[self delegate] signIn];
        }];
        self.signOut = [CCMenuItemFont itemWithString:@"Log Out" block:^(id sender) {
            [[self delegate] signOut];
        }];
        self.matchmaking = [CCMenuItemFont itemWithString:@"Matchmaking" block:^(id sender) {
            [[self delegate] matchmaking];
        }];

//        CCMenuItem* challenge = [CCMenuItemFont itemWithString:@"Challenge" block:^(id sender) {
//            [[self delegate] challenge];
//        }];
        
        self.menu = [[CCMenu alloc]init];
        [self onUserChange];
        // Add the menu to the layer
        [self addChild:self.menu z:2];
    }
    return self;
}

-(void)setScreenSize:(CGSize)size {
    [self setContentSize:size];
    [self.menu setPosition:ccp(size.width/2.0, size.height/2.0)];
}

-(void) onUserChange {
    [self.menu removeAllChildrenWithCleanup:NO]; // cleanup dumps the function blocks of menu items
    if ([PFUser currentUser]) {
        [self.menu addChild:self.play];
        [self.menu addChild:self.matchmaking];
        [self.menu addChild:self.signOut];
    }
    else {
        [self.menu addChild:self.signIn];
        [self.menu addChild:self.play];
        [self.menu addChild:self.matchmaking];
    }
    [self.menu alignItemsVerticallyWithPadding:10];
}

@end
