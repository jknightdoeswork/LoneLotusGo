//
//  PlayLayer.m
//  FirstCoco
//
//  Created by Brendan King on 13-01-19.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "PlayLayer.h"
#import <Parse/Parse.h>

@interface PlayLayer ()
@property(retain) NavBar* navbar;
@end
@implementation PlayLayer
    float v_sw;
	float v_sh;

-(void)dealloc {
    NSLog(@"PlayLayer being deallocated");
    [self.board release];
    [self.navbar release];
    // TODO RELEASE EVERYHTING
    [super dealloc];
}

+(CCScene*) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayLayer *layer = [PlayLayer node];
    scene.anchorPoint = ccp(0.5, 0.5);
    layer.anchorPoint = ccp(0.5, 0.5);
    
	// add layer as a child to scene
	[scene addChild: layer];

	// return the scene
	return scene;
}

+(CCScene*) loadExistingGame:(NSString*)boardId {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayLayer *layer = [PlayLayer node];
    [[layer board] load:boardId];
    scene.anchorPoint = ccp(0.5, 0.5);
    layer.anchorPoint = ccp(0.5, 0.5);
    
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

+(CCScene*) startNewOnlineGame:(NSString*)otherUsersId {
    if (![PFUser currentUser]) {
        NSLog(@"No logged in user. Starting regular game.");
        return [PlayLayer scene];
    }
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
    PlayLayer *layer = [PlayLayer node];
    [scene addChild:layer];
    
    PFQuery* otherUserQuery = [PFUser query];
    [otherUserQuery getObjectInBackgroundWithId:otherUsersId block:^(PFObject* other_user, NSError* error){
        if (!error) {
            [[layer board] setWhite_player:other_user];
            [[layer board] setBlack_player:[PFUser currentUser]];
            [[layer board] save];
        }
        else {
            NSLog(@"%@ %@\nError in startNewOnlineGame.otherUserQuery:withUserId:%@", error, [error userInfo], otherUsersId);
            
        }
    }];

//    NSString* boardId = [[layer board] getBoardId];
//    [[PFUser currentUser] addObject:boardId forKey:@"boardIds"];
//    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
//        if(!error) {
//            NSLog(@"User Saved With Board Id: %@", boardId);
//        }
//        else {
//            NSLog(@"%@ %@\nError saving user with board id: %@", error, [error userInfo], boardId);
//        }
//    }];
    scene.anchorPoint = ccp(0.5, 0.5);
    layer.anchorPoint = ccp(0.5, 0.5);
    
	// add layer as a child to scene

    
	// return the scene
	return scene;
}

-(id) init
{
	if(self = [super init]) {
        // Screen size
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        v_sw = screenSize.width;
        v_sh = screenSize.height;
        NSLog(@"%fx%f Screen", v_sw,v_sh);
        
        Scoreboard* scoreboard = [[Scoreboard alloc] initWithScores:0 black:0];
        [self addChild:scoreboard z:2];
        
        // add board
        self.board = [[OnlineBoard alloc] initBoard:19 s_board:scoreboard];
        [self.board setDelegate:self];
        [self addChild:self.board z:1];

        self.navbar = [[NavBar alloc]init];
        [[self.navbar logInController] setDelegate:self];
        [[[self.navbar logInController] signUpController] setDelegate:self];
        [self.navbar setDelegate:self];
        [self.navbar setScreenSize:screenSize];
        self.navbar.anchorPoint = ccp(0.0f, 0.0f);
        [self.navbar setPosition:ccp(0.0f, 0.0f)];
        [self addChild:self.navbar z:5];
    }
    return self;
}

-(void)nextTurn {
    [[self.navbar score_atlas] setString:[NSString stringWithFormat:@"%d", [self.board getScore]]];
    [[self.navbar score_atlas] visit];
}

-(void)receivedPushedBoardId:(NSString*)pushedBoardId {
    if ([[self.board getBoardId] isEqualToString:pushedBoardId]) {
        NSLog(@"Updating visible board.");
        [self.board load:pushedBoardId];
    }
    else {
        NSLog(@"Updating navbar");
        [self.navbar updateNavBarMenu];
    }
}

-(void)clickedNavBarBoardId:(NSString*)boardId {
    [self.board load:boardId];
}

-(void)clickedRefresh {
    [self.board refresh];
}

-(void)clickedPass {
    [self.board pass];
}

-(void)screenSizeChangedTo:(CGSize)size {
    [self.navbar setScreenSize:size];
    [self.board setPosition:ccp(size.width/2, size.height/2)];
}

//-(void) registerWithTouchDispatcher
//{
////	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	//    [[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:0];
//}
//- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//	CGPoint location = [touch locationInView:[touch view]];
//    
//	location = [[CCDirector sharedDirector] convertToGL:location];
//	[self tapDownAt:location];
//	return NO;
//}
//
//- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
//	CGPoint location = [touch locationInView:[touch view]];
//	location = [[CCDirector sharedDirector] convertToGL:location];
//	[self tapMoveAt:location];
//}
//
//- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
//	CGPoint location = [touch locationInView:[touch view]];
//	location = [[CCDirector sharedDirector] convertToGL:location];
//	[self tapUpAt:location];
//}
//
//- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
//	CGPoint location = [touch locationInView:[touch view]];
//	location = [[CCDirector sharedDirector] convertToGL:location];
//	[self tapUpAt:location];
//}
//
//- (BOOL)ccMouseDown:(NSEvent *)event {
//	CGPoint location = [[CCDirector sharedDirector] convertEventToGL:event];
//	[self tapDownAt:location];
//	return YES;
//}
//
//- (BOOL)ccMouseDragged:(NSEvent *)event {
//	CGPoint location = [[CCDirector sharedDirector] convertEventToGL:event];
//	[self tapMoveAt:location];
//	return YES;
//}
//
//- (BOOL)ccMouseUp:(NSEvent *)event {
//	CGPoint location = [[CCDirector sharedDirector] convertEventToGL:event];
//	[self tapUpAt:location];
//	return YES;
//}

#pragma mark PFLogInViewControllerDelegate Methods
/*! @name Responding to Actions */
/// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"Logged in!");
    [self.navbar updateNavBarMenu];
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
}

/// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Error Logging in!");
}

/// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"Cancel Logging In!");
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
}
// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"Signed up user");
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:NULL];
}

@end
