//
//  NavBar.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-27.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "NavBar.h"
#import "ClickableSprite.h"
#import "LLMainMenu.h"
#import "CCDirector.h"
#import "CGPointExtension.h"

@interface NavBar ()
@property(retain) CCSprite* bg;
@property(retain) ClickableSprite* menuIcon;
@property(retain) ClickableSprite* pass;
@property(retain) ClickableSprite* refresh;
@property(retain) ClickableSprite* save;
@property(retain) CCSprite* blackStone;
@property(retain) CCSprite* whiteStone;
@end
@implementation NavBar
{
    ccColor3B unactivePlayerColor;
    ccColor3B activePlayerColor;
}
-(void)dealloc {
    [self.bg release];
    [self.menuIcon release];
    [self.menuIcon release];
    [self.pass release];
    [self.score_atlas release];
    [self.blackcaps release];
    [self.whitecaps release];
    [super dealloc];
}
-(id) init
{
	if(self=[super init]) {
        self.isTouchEnabled = YES;
        
        unactivePlayerColor = ccc3(140, 140, 140);
        activePlayerColor = ccc3(15, 222, 210);
        
        //BG
        self.bg = [CCSprite spriteWithFile:@"navbarbg.png"];
        [self.bg setAnchorPoint:ccp(0.0f, 1.0f)];

        // Icon
        self.menuIcon = [ClickableSprite spriteWithFile:@"navbaricon.png"];
        [self.menuIcon registerTouch];
        [self.menuIcon setTouchBegan:^BOOL(UITouch* touch, UIEvent* event) {
            if (self.isTouchEnabled) {
                NSLog(@"navbar.menuIcon clicked");
                [self.delegate clickedNavIcon];
                return YES;
            }
            return NO;
        }];
        [self.menuIcon setAnchorPoint:ccp(1.0f,1.0f)];
        
        // Pass
        self.pass = [ClickableSprite spriteWithFile:@"skip.png"];
        [self.pass setAnchorPoint:ccp(0.0f, 1.0f)];
        [self.pass setScale:0.9f];
        [self.pass setTouchBegan:^BOOL(UITouch* touch, UIEvent* event) {
            if (self.isTouchEnabled) {
                NSLog(@"clicked pass");
                [self.delegate clickedPass];
                return YES;
            }
            return NO;
        }];
        [self.pass registerTouch];
        
        // Refresh
        self.refresh = [ClickableSprite spriteWithFile:@"refresh.png"];
        [self.refresh setAnchorPoint:ccp(0.0f, 1.0f)];
        [self.refresh setScale:0.9f];
        [self.refresh setTouchBegan:^BOOL(UITouch* touch, UIEvent* event) {
            if (self.isTouchEnabled) {
                NSLog(@"clicked refresh");
                [self.delegate clickedRefresh];
                return YES;
            }
            return NO;
        }];
        [self.refresh registerTouch];
        // Score
        self.score_atlas = [[[CCLabelAtlas alloc]  initWithString:@"0" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'] autorelease];
        [self.score_atlas setAnchorPoint:ccp(0.0f, 1.0f)];
        //Add
        [self addChild:self.bg z:10];
        [self addChild:self.score_atlas z:11];
        [self addChild:self.menuIcon z:12];
        [self addChild:self.refresh z:13];
        [self addChild:self.pass z:14];
        
        
        // Player names
        self.blackPlayerName = [[CCLabelTTF alloc] initWithString:@"Black" fontName:@"HelveticaNeue" fontSize:14];
        [self.blackPlayerName setColor:unactivePlayerColor];
        [self.blackPlayerName setAnchorPoint:ccp(0.5f, 1.0f)];
        [self addChild:self.blackPlayerName z:16];
        
        self.whitePlayerName = [[CCLabelTTF alloc] initWithString:@"White" fontName:@"HelveticaNeue" fontSize:14];
        [self.whitePlayerName setColor:unactivePlayerColor];
        [self.whitePlayerName setAnchorPoint:ccp(0.5f, 1.0f)];
        [self addChild:self.whitePlayerName z:17];
        
        [self setActivePlayer:P_BLACK];
        
        
        //Stones
        self.whiteStone = [CCSprite spriteWithFile:@"stone_white.png"];
        [self.whiteStone setAnchorPoint:ccp(0.5f, 1.0f)];
        [self.whiteStone setScale:0.5f];
        [self addChild:self.whiteStone z:15];
        self.blackStone = [CCSprite spriteWithFile:@"stone_black.png"];
        [self.blackStone setAnchorPoint:ccp(0.5f, 1.0f)];
        [self.blackStone setScale:0.5f];
        [self addChild:self.blackStone z:15];

        // Capture scores
        self.blackcaps = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"HelveticaNeue" fontSize:16];
        [self.blackcaps setAnchorPoint:ccp(0.5, 1.0f)];
        [self addChild:self.blackcaps z:18];
        self.whitecaps = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"HelveticaNeue" fontSize:16];
        [self.whitecaps setAnchorPoint:ccp(0.5f, 1.0f)];
        [self addChild:self.whitecaps z:18];
        
        //save
        self.save = [ClickableSprite spriteWithFile:@"saveicon.png"];
        [self.save setAnchorPoint:ccp(0.0f, 1.0f)];
        [self.save setScale:0.9f];
        [self.save setTouchBegan:^BOOL(UITouch* touch, UIEvent* event) {
            if (self.isTouchEnabled) {
                NSLog(@"clicked save");
                [self.delegate clickedSave];
                return YES;
            }
            return NO;
        }];
        [self.save registerTouch];
        
        [self addChild:self.save z:14];
	}
	return self;
}

-(void)setScreenSize:(CGSize)size {
    NSLog(@"navbar size: %f %f", size.width, size.height);
    [self.score_atlas setPosition:ccp(0.0f, size.height)];

    [self.menuIcon setPosition:ccp(size.width, size.height)];
    [self.save setPosition:ccp(0.0f, size.height)];
    [self.pass setPosition:ccp(32, size.height)];
    [self.refresh setPosition:ccp(64, size.height)];
    [self.blackPlayerName setPosition:ccp(158,size.height-10)];
    [self.blackStone setPosition:ccp(158, size.height-10)];
    [self.blackcaps setPosition:ccp(182, size.height-10)];
    [self.whitePlayerName setPosition:ccp(235, size.height-10)];
    [self.whiteStone setPosition:ccp(235, size.height-10)];
    [self.whitecaps setPosition:ccp(259, size.height-10)];
    [self.bg setPosition:ccp(0.0f,size.height)];
}

-(void)setActivePlayer:(PlayerFlag)flag {
    if (flag == P_BLACK) {
        [self.blackPlayerName setColor:activePlayerColor];
        [self.whitePlayerName setColor:unactivePlayerColor];
    }
    else if (flag == P_WHITE) {
        [self.blackPlayerName setColor:unactivePlayerColor];
        [self.whitePlayerName setColor:activePlayerColor];
    }
}
@end
