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
@property(assign)CCLayer* gamesLayer;
@property(assign)CCMenu* mainPage;
@property(retain)CCMenuItem* play;
@property(retain)CCMenuItem* signIn;
@property(retain)CCMenuItem* signOut;
@property(assign)CCMenu* gamesPage;
@end
@implementation LLMenu

-(void)dealloc {
    [self.play release];
    [self.signIn release];
    [self.signOut release];
    [super dealloc];
}
-(id)init {
    
    NSMutableArray* layers = [NSMutableArray arrayWithCapacity:2];
    // Top Level Menu Items
    self.play = [CCMenuItemFont itemWithString:@"Play" block:^(id sender) {
        NSLog(@"Resume");
        [[self menuDelegate] resume];
    }];
    self.signOut = [CCMenuItemFont itemWithString:@"Sign Out" block:^(id sender) {
        NSLog(@"Sign out");
        [[self menuDelegate] signOut];
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

    [self.mainLayer addChild:self.mainPage];
    [self.gamesLayer addChild:self.gamesPage];

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
    if([PFUser currentUser]) {
        [self.mainPage addChild:self.signOut];
    }
    else {
        [self.mainPage addChild:self.signIn];
    }
    
    [self.mainPage alignItemsVerticallyWithPadding:5.0f];
    
    // Update games page
    [self.gamesPage removeAllChildrenWithCleanup:YES];
    if([PFUser currentUser]) {
        PFQuery* white_query = [PFQuery queryWithClassName:@"Board"];
        [white_query whereKey:@"white_player" equalTo:[PFUser currentUser]];
        
        PFQuery* black_query = [PFQuery queryWithClassName:@"Board"];
        [black_query whereKey:@"black_player" equalTo:[PFUser currentUser]];
        
        NSArray* queries = [NSArray arrayWithObjects:white_query, black_query, nil];
        PFQuery* both_query = [PFQuery orQueryWithSubqueries:queries];
        
        [both_query includeKey:@"white_player"]; // Fetch the player entities, as well.
        [both_query includeKey:@"black_player"];
        
        [both_query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error){
            if(!error) {
                NSLog(@"Query for players board ids successful. %d found.", [objects count]);
                [self.gamesPage removeAllChildrenWithCleanup:NO];
                for(PFObject* board in objects) {
                    PFUser* w = [board objectForKey:@"white_player"];
                    PFUser* b = [board objectForKey:@"black_player"];
                    NSString* saveName = [board objectForKey:@"savename"];
                    if (saveName == nil) {
                        saveName = [[w objectId] isEqualToString:[[PFUser currentUser] objectId]] ? [b username] : [w username];
                    }
                    CCMenuItem* item = [CCMenuItemFont itemWithString:saveName block:^(id sender) {
                        [[self menuDelegate] load:[board objectId]];
                    }];
                    [item setAnchorPoint:ccp(0.5f, 0.5f)];
                    [self.gamesPage addChild:item];
                }
            }
            else {
                NSLog(@"GetGamesList Error %@ %@", error, [error userInfo]);
            }
            [self.gamesPage alignItemsVerticallyWithPadding:5.0f];
        }];
    }
    [self updatePages];
}

-(void)setScreenSizeChangedTo:(CGSize)size {
    [self.mainPage setPosition:ccp(size.width/2.0, size.height/2.0)];
    [self.gamesPage setPosition:ccp(size.width/2.0, size.height/2.0)];
    [self updatePages];
}
@end
