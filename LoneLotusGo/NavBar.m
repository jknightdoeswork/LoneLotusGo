//
//  NavBar.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-27.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "NavBar.h"
#import "CCSprite.h"
#import "CCMenu.h"
#import "CCDirector.h"
#import "CGPointExtension.h"

@interface NavBar ()
@property(retain) CCMenu* menu;
@property(retain) CCMenuItem* load;
@property(retain) CCMenuItem* save;
@property(retain) CCSprite* bg;
@end
@implementation NavBar
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self=[super init])) {
        [CCMenuItemFont setFontName:@"Zapfino"];
        [CCMenuItemFont setFontSize:18];
        
        // Top Level Menu Items
        self.save = [CCMenuItemFont itemWithString:@"Save" block:^(id sender) {
            NSLog(@"Save");
            [[self board] save];
        }];

        self.load = [CCMenuItemFont itemWithString:@"Load" block:^(id sender) {
            NSLog(@"Load");
            [[self board] load:@"HRpcOF0Gye"];
        }];
        
        [self.save setAnchorPoint:ccp(1.0f, 1.0f)];
        [self.load setAnchorPoint:ccp(1.0f, 1.0f)];
        
        self.menu = [CCMenu menuWithItems:self.save, self.load, nil];
        [self.menu setPosition:ccp(0.0f, 0.0f)];
        [self addChild:self.menu z:11];
        
        self.bg = [CCSprite spriteWithFile:@"navbarbg.png"];
        [self.bg setAnchorPoint:ccp(0.0f, 1.0f)];
        [self addChild:self.bg z:10];
	}
	return self;
}

-(void)setScreenSize:(CGSize)size {
    NSLog(@"navbar size: %f %f", size.width, size.height);
    int padding = 10;
    int save_x = size.width-padding;
    int load_x = save_x - self.save.contentSize.width - padding;
    [[self save] setPosition:ccp(save_x, size.height)];
    [[self load] setPosition:ccp(load_x, size.height)];
    [[self bg] setPosition:ccp(0.0f,size.height)];
}
@end
