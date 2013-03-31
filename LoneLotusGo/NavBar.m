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
@property(retain) CCMenu* menu;
@property(retain) CCSprite* bg;
@property(retain) ClickableSprite* menuIcon;
@property(retain) CCMenuItem* signOut;
@property(retain) CCMenuItem* signIn;
@end
@implementation NavBar
-(void)dealloc {
    [self.menu release];
    [self.bg release];
    [self.menuIcon release];
    [self.signIn release];
    [self.signOut release];
    [super dealloc];
}
-(id) init
{
	if(self=[super init]) {
        //Parse Login Controller
        self.logInController = [[[PFLogInViewController alloc] init]autorelease];
        
        // Menu
        self.menu = [CCMenu node];
        //        [self.menu setEnabled:NO];
        [self.menu setVisible:NO];
        //Menu Items
        self.signOut = [CCMenuItemFont itemWithString:@"Sign Out" block:^(id sender){
            NSLog(@"NavBar LogOut Clicked.");
            [PFUser logOut];
            [self updateNavBarMenu];
            [[self menu] setVisible:NO];
            [[CCDirector sharedDirector] popScene];
        }];
        self.signIn = [CCMenuItemFont itemWithString:@"Sign In" block:^(id sender) {
            [[self menu] setVisible:NO];
            [[CCDirector sharedDirector] presentViewController:self.logInController animated:YES completion:nil];
        }];
        [self.signOut setAnchorPoint:ccp(1.0f, 1.0f)];
        [self.signIn setAnchorPoint:ccp(1.0f, 1.0f)];
        [self updateNavBarMenu];
        
        //BG
        self.bg = [CCSprite spriteWithFile:@"navbarbg.png"];
        [self.bg setAnchorPoint:ccp(0.0f, 1.0f)];

        // Icon
        self.menuIcon = [ClickableSprite spriteWithFile:@"navbaricon.png"];
        [self.menuIcon registerTouch];
        [self.menuIcon setTouchBegan:^BOOL(UITouch* touch, UIEvent* event) {
            NSLog(@"navbar.menuIcon clicked");
            [self.menu setVisible:![self.menu visible]];
            return YES;
        }];
        [self.menuIcon setAnchorPoint:ccp(1.0f,1.0f)];

        //Add
        [self addChild:self.bg z:10];
        [self addChild:self.menuIcon z:12];
        [self addChild:self.menu z:20];
	}
	return self;
}

-(void) updateNavBarMenu {
    NSLog(@"Updating Nav Bar Menu");
    PFUser* currentUser = [PFUser currentUser];
    if (!currentUser) {
        NSLog(@"getGamesList: No User Logged In.");
        [[self menu] removeAllChildrenWithCleanup:NO];
        [[self menu] addChild:[self signIn]];
        [self.menu alignItemsVerticallyWithPadding:10.0f];
        return;
    }
//    [[self menu] removeAllChildrenWithCleanup:YES];
    [[self menu] addChild:[self signOut]];
    NSString* uid = currentUser.objectId;
    NSString* username = currentUser.username;

    PFQuery* white_query = [PFQuery queryWithClassName:@"Board"];
    [white_query whereKey:@"white_player" equalTo:uid];

    PFQuery* black_query = [PFQuery queryWithClassName:@"Board"];
    [black_query whereKey:@"black_player" equalTo:uid];

    NSArray* queries = [NSArray arrayWithObjects:white_query, black_query, nil];
    PFQuery* both_query = [PFQuery orQueryWithSubqueries:queries];

    [both_query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error){
        if(!error) {
            NSLog(@"Query for players board ids successful. %d found.", [objects count]);
            [[self menu] removeAllChildrenWithCleanup:NO];
            for(PFObject* board in objects) {
                NSString* w = [board objectForKey:@"white_player"];
                NSString* b = [board objectForKey:@"black_player"];
                NSString* itemName = w == username ? w: b;
                CCMenuItem* item = [CCMenuItemFont itemWithString:itemName block:^(id sender) {
                    NSLog(@"click!");
                }];
                [item setAnchorPoint:ccp(1.0f, 1.0f)];
                [[self menu] addChild:item];
            }
        }
        else {
            NSLog(@"GetGamesList Error %@ %@", error, [error userInfo]);
        }
        [[self menu] addChild:[self signOut]];
    }];
}

-(void)setScreenSize:(CGSize)size {
    NSLog(@"navbar size: %f %f", size.width, size.height);
    [self.menu setPosition:ccp(size.width-10, size.height-40)];
    [self.menuIcon setPosition:ccp(size.width, size.height)];
    [[self bg] setPosition:ccp(0.0f,size.height)];
}
@end