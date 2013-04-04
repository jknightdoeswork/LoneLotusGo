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
@property(retain) ClickableSprite* pass;
@property(retain) ClickableSprite* refresh;
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
    [self.menuIcon release];
    [self.pass release];
    [self.score_atlas release];
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
            PFInstallation* currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation removeObject:[PFUser currentUser].objectId forKey:@"userid"];
            [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
                if(succeeded && !error) {
                    NSLog(@"Installation saved.");
                }else {
                    NSLog(@"%@ %@\nInstallation Save Error.", error, [error userInfo]);
                }
            }];

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
        [self.menu alignItemsVerticallyWithPadding:5.0f];
        return;
    }
//    [[self menu] removeAllChildrenWithCleanup:YES];
    [[self menu] addChild:[self signOut]];

    PFQuery* white_query = [PFQuery queryWithClassName:@"Board"];
    [white_query whereKey:@"white_player" equalTo:currentUser];

    PFQuery* black_query = [PFQuery queryWithClassName:@"Board"];
    [black_query whereKey:@"black_player" equalTo:currentUser];

    NSArray* queries = [NSArray arrayWithObjects:white_query, black_query, nil];
    PFQuery* both_query = [PFQuery orQueryWithSubqueries:queries];
    
    [both_query includeKey:@"white_player"]; // Fetch the player entities, as well.
    [both_query includeKey:@"black_player"];
    
    [both_query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error){
        if(!error) {
            NSLog(@"Query for players board ids successful. %d found.", [objects count]);
            [[self menu] removeAllChildrenWithCleanup:NO];
            for(PFObject* board in objects) {
                PFUser* w = [board objectForKey:@"white_player"];
                PFUser* b = [board objectForKey:@"black_player"];
                NSString* saveName = [board objectForKey:@"savename"];
                if (saveName == nil) {
                    saveName = [[w objectId] isEqualToString:[currentUser objectId]] ? [b username] : [w username];
                }
                CCMenuItem* item = [CCMenuItemFont itemWithString:saveName block:^(id sender) {
                    [[self delegate] clickedNavBarBoardId:[board objectId]];
                }];
                [item setAnchorPoint:ccp(1.0f, 1.0f)];
                [[self menu] addChild:item];
            }
        }
        else {
            NSLog(@"GetGamesList Error %@ %@", error, [error userInfo]);
        }
        [self.menu alignItemsVerticallyWithPadding:5.0f];
    }];
}

-(void)setScreenSize:(CGSize)size {
    NSLog(@"navbar size: %f %f", size.width, size.height);
    [self.score_atlas setPosition:ccp(0.0f, size.height)];
    [self.menu setPosition:ccp(size.width-10, size.height-50)];
    [self.menuIcon setPosition:ccp(size.width, size.height)];
    [self.pass setPosition:ccp(50, size.height)];
    [self.refresh setPosition:ccp(92, size.height)];
    [[self bg] setPosition:ccp(0.0f,size.height)];
}
@end
