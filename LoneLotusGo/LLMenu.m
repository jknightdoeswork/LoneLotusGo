//
//  LLMenu.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-04-04.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "LLMenu.h"
#import <Parse/Parse.h>
@interface LLMenu ()
@property(assign)CCLayer* mainLayer;
@property(assign)CCMenu* mainPage;
@property(assign)CCSprite* logo;
@property(assign)CCMenu* gamesPage;
@property(assign)CCLabelTTF* gamesText;

@property(retain)CCLayer* gamesLayer;
@property(retain)CCMenuItem* play;
@property(retain)CCMenuItem* newGame;
@property(retain)CCMenuItem* signIn;
@property(retain)CCMenuItem* signOut;
@end
@implementation LLMenu

-(void)dealloc {
    [self.play release];
    [self.signIn release];
    [self.signOut release];
    [self.gamesLayer release];
    [super dealloc];
}
-(id)init {
    
    NSMutableArray* layers = [NSMutableArray arrayWithCapacity:2];
    // Top Level Menu Items
    [CCMenuItemFont setFontName:@"Zapfino"];
    [CCMenuItemFont setFontSize:18];
    
    self.play = [CCMenuItemFont itemWithString:@"Play" block:^(id sender) {
        NSLog(@"Resume");
        [[self menuDelegate] resume];
    }];
    self.signOut = [CCMenuItemFont itemWithString:@"Sign Out" block:^(id sender) {
        NSLog(@"Sign out");
        [[self menuDelegate] signOut];
    }];
    self.newGame = [CCMenuItemFont itemWithString:@"New Game" block:^(id sender) {
        NSLog(@"Sign in");
        [[self menuDelegate] newGame];
    }];
    self.signIn = [CCMenuItemFont itemWithString:@"Sign In" block:^(id sender) {
        NSLog(@"Sign in");
        [[self menuDelegate] signIn];
    }];
    
    [self.play setAnchorPoint:ccp(0.5f, 0.5f)];
    [self.signIn setAnchorPoint:ccp(0.5f, 0.5f)];
    [self.signOut setAnchorPoint:ccp(0.5f, 0.5f)];
    
    self.mainPage = [CCMenu node];
    self.gamesPage = [CCMenu node];
    
    self.mainLayer = [CCLayer node];
    self.gamesLayer = [CCLayer node];

    self.logo = [CCSprite spriteWithFile:@"logo.png"];
    [self.logo setAnchorPoint:ccp(0.5f, 1.0f)];

    [self.mainLayer addChild:self.mainPage];
    [self.mainLayer addChild:self.logo];
    
    [self.gamesLayer addChild:self.gamesPage];

    self.gamesText = [CCLabelTTF labelWithString:@"Your Games" fontName:@"Zapfino" fontSize:24];
    [self.gamesText setAnchorPoint:ccp(0.5f, 1.0f)];
    [self.gamesLayer addChild:self.gamesText];
    
    [layers addObject:self.mainLayer];
    [layers addObject:self.gamesLayer];
    if(self = [super initWithLayers:layers widthOffset:0]) {
        [self onUserChange];
    }
    return self;
}

-(void)onUserChange {
    // Update main page
    [self.mainPage removeAllChildrenWithCleanup:NO];
    [self.mainPage addChild:self.play];
    [self.mainPage addChild:self.newGame];
    if([PFUser currentUser]) {
        [self.mainPage addChild:self.signOut];
        if(![self.pages containsObject:self.gamesLayer]) {
            [self addPage:self.gamesLayer];
        }
    }
    else {
        [self removePage:self.gamesLayer];
        [self.mainPage addChild:self.signIn];
    }
    [self setVisible:self.visible];// Will make the pages indicator visible if the users logged in and self is visible
    [self.mainPage alignItemsVerticallyWithPadding:5.0f];
    [self updateBoardList];
}
-(void)updateBoardList {
    [CCMenuItemFont setFontName:@"HelveticaNeue-UltraLightItalic"];
    [CCMenuItemFont setFontSize:24];
    NSArray* boards = [self.menuDelegate getBoardList];
    [self.gamesPage removeAllChildrenWithCleanup:YES];
    for (NSDictionary* board in boards) {
        NSString* boardName = [board objectForKey:@"name"];
        NSString* boardId = [board objectForKey:@"boardId"];
        BOOL isCurrentPlayersTurn = [[board objectForKey:@"isCurrentPlayersTurn"] boolValue];
        BOOL isOnline = [[board objectForKey:@"isOnlineGame"]boolValue];
        CCMenuItem* item = [CCMenuItemFont itemWithString:boardName block:^(id sender) {
            [[self menuDelegate] load:boardId];
        }];

        if(isCurrentPlayersTurn) {
            CCSprite* turnSprite = [CCSprite spriteWithFile:@"logo.png"];
            [turnSprite setScale:0.125f];
            [turnSprite setAnchorPoint:ccp(1.0f, 0.0f)];
            [turnSprite setPosition:ccp(-10.0f, 0.0f)];
            [item addChild:turnSprite];

        }
        if(isOnline) {
            CCSprite* onlineSprite = [CCSprite spriteWithFile:@"logo.png"];
            [onlineSprite setScale:0.125f];
            [onlineSprite setAnchorPoint:ccp(1.0f, 0.0f)];
            [onlineSprite setPosition:ccp(-42.0f, 0.0f)];
            [item addChild:onlineSprite];
        }
        [self.gamesPage addChild:item];
        [item setAnchorPoint:ccp(0.0f, 0.5f)];
    }
    [[self gamesPage] alignItemsVerticallyWithPadding:5.0f];
    
}

-(void)setScreenSizeChangedTo:(CGSize)size {
    [self.mainPage setPosition:ccp(size.width/2.0, size.height/2.0 - 40)];
    [self.gamesPage setPosition:ccp(size.width/2.0, size.height/2.0)];
    [self.logo setPosition:ccp(size.width/2.0f, size.height)];
    [self.gamesText setPosition:ccp(size.width/2.0f, size.height)];
    [self setPagesIndicatorPosition:ccp(size.width/2, 20)];
    [self updatePages];
}

-(void)setVisible:(BOOL)visible {
    if (visible) {
        if([PFUser currentUser]) {
            self.showPagesIndicator = YES;
        }
        else {
            self.showPagesIndicator = NO;
        }
    }
    else {
        self.showPagesIndicator = NO;
    }
    [super setVisible:visible];
}
@end
