//
//  LLMenu.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-04-04.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "LLMenu.h"
#import <Parse/Parse.h>
#import "PlayerFlag.h"
#import "CCMenuAdvanced.h"

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

@property(retain)CCLayer* matchmakingLayer;
@property(retain)CCLabelTTF* matchmakingLabel;
@property(retain)CCMenuItemToggle* toggleMatchmaking;
@property(assign)CCMenu* matchmakingMenu;

@end
@implementation LLMenu

-(void)dealloc {
    [self.play release];
    [self.signIn release];
    [self.signOut release];
    [self.gamesLayer release];
    [self.matchmakingLayer release];
    [self.matchmakingLabel release];
    [self.toggleMatchmaking release];
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
    self.gamesPage = [CCMenuAdvanced menuWithItems:nil];
//    [self.gamesPage setBoundaryRect:CGRectMake(0, 0, [self.gamesPage boundingBox].size.width, 300)];
//    [self.gamesPage setDebugDraw:YES];
//    [self.gamesPage fixPosition];
    
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

    //matchmaking
    self.matchmakingLayer = [CCLayer node];
    CCMenuItem* enterMatchmaking = [CCMenuItemFont itemWithString:@"Recieve Game Invites: No" block:^(id sender) {
        [[self menuDelegate] enterMatchmaking];
    }];
    CCMenuItem* exitMatchmaking = [CCMenuItemFont itemWithString:@"Recieve Game Invites: Yes" block:^(id sender) {
        [[self menuDelegate] exitMatchmaking];
    }];
    self.toggleMatchmaking = [CCMenuItemToggle itemWithItems:[NSArray arrayWithObjects:enterMatchmaking,exitMatchmaking, nil] block:^(id sender){
        if([sender selectedIndex] == 1) {
            [[self menuDelegate] enterMatchmaking];
        }
        else {
            [[self menuDelegate] exitMatchmaking];
        }
        NSLog(@"toggled matchmaking");
    }];
    self.matchmakingMenu = [CCMenu menuWithItems:self.toggleMatchmaking, nil];
    [self.matchmakingLayer addChild:self.matchmakingMenu];
    self.matchmakingLabel = [CCLabelTTF labelWithString:@"Matchmaking" fontName:@"Zapfino" fontSize:24];
    [self.matchmakingLabel setAnchorPoint:ccp(0.5f, 1.0f)];
    [self.matchmakingLayer addChild:self.matchmakingLabel];

    [layers addObject:self.mainLayer];
    [layers addObject:self.gamesLayer];
    [layers addObject:self.matchmakingLayer];
    if(self = [super initWithLayers:layers widthOffset:0]) {
        [self onUserChange];
    }
    

    return self;
}

-(void)setIsInMatchmaking:(BOOL)inMatchmaking {
    if (inMatchmaking) {
        [self.toggleMatchmaking setSelectedIndex:1];
    }
    else {
        [self.toggleMatchmaking setSelectedIndex:0];
    }
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
        if(![self.pages containsObject:self.matchmakingLayer]){
            [self addPage:self.matchmakingLayer];
        }
        [self setIsInMatchmaking:[[[PFUser currentUser] objectForKey:@"inMatchmaking"]boolValue]];
    }
    
    else {
        [self removePage:self.gamesLayer];
        [self removePage:self.matchmakingLayer];
        [self.mainPage addChild:self.signIn];
    }
    [self setVisible:self.visible];// Will make the pages indicator visible if the users logged in and self is visible
    [self.mainPage alignItemsVerticallyWithPadding:5.0f];
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
        PlayerFlag currentTurn = [[board objectForKey:@"currentTurn"] charValue];
        
        CCMenuItem* item = [CCMenuItemFont itemWithString:boardName block:^(id sender) {
            [[self menuDelegate] load:boardId];
        }];

        if(isCurrentPlayersTurn) {
            CCSprite* turnSprite = [CCSprite spriteWithFile:@"exclaim.png"];
            [turnSprite setAnchorPoint:ccp(1.0f, 0.0f)];
            [turnSprite setPosition:ccp(-10.0f, 0.0f)];
            [item addChild:turnSprite z:2];

        }
        if(currentTurn == P_BLACK) {
            CCSprite* stoneSprite = [CCSprite spriteWithFile:@"stone_black.png"];
            [stoneSprite setAnchorPoint:ccp(1.0f, 0.0f)];
            [stoneSprite setPosition:ccp(-10.0f, 0.0f)];
            [item addChild:stoneSprite z:1];
        }
        else if (currentTurn == P_WHITE) {
            CCSprite* stoneSprite = [CCSprite spriteWithFile:@"stone_white.png"];
            [stoneSprite setAnchorPoint:ccp(1.0f, 0.0f)];
            [stoneSprite setPosition:ccp(-10.0f, 0.0f)];
            [item addChild:stoneSprite z:1];
        }
        if(isOnline) {
            CCSprite* onlineSprite = [CCSprite spriteWithFile:@"onlineicon.png"];
            [onlineSprite setAnchorPoint:ccp(1.0f, 0.0f)];
            [onlineSprite setPosition:ccp(-42.0f, 0.0f)];
            [item addChild:onlineSprite z:2];
        }
        [self.gamesPage addChild:item];
        [item setAnchorPoint:ccp(0.0f, 0.5f)];
    }
    [[self gamesPage] alignItemsVerticallyWithPadding:5.0f];
    
}

-(void)othersInMatchmakingDidUpdate:(NSArray*)others {
    [CCMenuItemFont setFontName:@"HelveticaNeue-UltraLightItalic"];
    [CCMenuItemFont setFontSize:24];
    [self.matchmakingMenu removeChild:self.toggleMatchmaking cleanup:NO];
    [self.matchmakingMenu removeAllChildrenWithCleanup:YES];
    [self.matchmakingMenu addChild:self.toggleMatchmaking];
    
    for(PFObject* otherUser in others) {
        CCMenuItem* item = [CCMenuItemFont itemWithString:[otherUser objectForKey:@"username"] block:^(id sender) {
            [[self menuDelegate] challengeOtherUser:[otherUser objectId] otherUserName:[otherUser objectForKey:@"username"]];
        }];
        [item setAnchorPoint:ccp(0.5f, 2.0f)];
        [self.matchmakingMenu addChild:item];
    }
}

-(void)setScreenSizeChangedTo:(CGSize)size {
    [self.mainPage setPosition:ccp(size.width/2.0, size.height/2.0 - 40)];
    [self.gamesPage setPosition:ccp(size.width/2.0, size.height/2.0)];
    [self.matchmakingLabel setPosition:ccp(size.width/2.0, size.height)];
    [self.matchmakingMenu setPosition:ccp(size.width/2.0, size.height-66)];
//    [self.gamesPage fixPosition];
    [self.logo setPosition:ccp(size.width/2.0f, size.height)];
    [self.gamesText setPosition:ccp(size.width/2.0f, size.height)];
    [self setPagesIndicatorPosition:ccp(size.width/2, 20)];
    [self updatePages];
}

-(void)setVisible:(BOOL)visible {
    if (visible) {
        [self setIsTouchEnabled:YES];
        [self.gamesPage setIsTouchEnabled:YES];
        [self.mainPage setIsTouchEnabled:YES];
        if([PFUser currentUser]) {
            self.showPagesIndicator = YES;
        }
        else {
            self.showPagesIndicator = NO;
        }
    }
    else {
        [self setIsTouchEnabled:NO];
        [self.gamesPage setIsTouchEnabled:NO];
        [self.mainPage setIsTouchEnabled:NO];
        self.showPagesIndicator = NO;
    }
    [super setVisible:visible];
}
@end
