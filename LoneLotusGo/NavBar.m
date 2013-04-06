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
@end
@implementation NavBar
-(void)dealloc {
    [self.bg release];
    [self.menuIcon release];
    [self.menuIcon release];
    [self.pass release];
    [self.score_atlas release];
    [super dealloc];
}
-(id) init
{
	if(self=[super init]) {
        //BG
        self.bg = [CCSprite spriteWithFile:@"navbarbg.png"];
        [self.bg setAnchorPoint:ccp(0.0f, 1.0f)];

        // Icon
        self.menuIcon = [ClickableSprite spriteWithFile:@"navbaricon.png"];
        [self.menuIcon registerTouch];
        [self.menuIcon setTouchBegan:^BOOL(UITouch* touch, UIEvent* event) {
            NSLog(@"navbar.menuIcon clicked");
            [self.delegate clickedNavIcon];
            return YES;
        }];
        [self.menuIcon setAnchorPoint:ccp(1.0f,1.0f)];
        
        // Pass
        self.pass = [ClickableSprite spriteWithFile:@"skip.png"];
        [self.pass setAnchorPoint:ccp(0.0f, 1.0f)];
        [self.pass setScale:0.9f];
        [self.pass setTouchBegan:^BOOL(UITouch* touch, UIEvent* event) {
            NSLog(@"clicked pass");
            [self.delegate clickedPass];
            return YES;
        }];
        [self.pass registerTouch];
        
        // Refresh
        self.refresh = [ClickableSprite spriteWithFile:@"refresh.png"];
        [self.refresh setAnchorPoint:ccp(0.0f, 1.0f)];
        [self.refresh setScale:0.9f];
        [self.refresh setTouchBegan:^BOOL(UITouch* touch, UIEvent* event) {
            NSLog(@"clicked refresh");
            [self.delegate clickedRefresh];
            return YES;
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
	}
	return self;
}

-(void)setScreenSize:(CGSize)size {
    NSLog(@"navbar size: %f %f", size.width, size.height);
    [self.score_atlas setPosition:ccp(0.0f, size.height)];
    [self.menuIcon setPosition:ccp(size.width, size.height)];
    [self.pass setPosition:ccp(50, size.height)];
    [self.refresh setPosition:ccp(92, size.height)];
    [[self bg] setPosition:ccp(0.0f,size.height)];
}
@end
