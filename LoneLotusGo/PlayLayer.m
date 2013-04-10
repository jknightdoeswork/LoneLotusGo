//
//  PlayLayer.m
//  FirstCoco
//
//  Created by Brendan King on 13-01-19.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "PlayLayer.h"
#import <Parse/Parse.h>
#import "LLLogInViewController.h"
#import "LLSignupViewController.h"

@interface PlayLayer ()
@property(retain) NavBar* navbar;
@property(retain) LLMenu* llmenu;
@property(retain) LLLogInViewController* loginController;
@property(retain) CCSprite* background;
@property(retain) CCLabelTTF* gameOverLabel;
@property(retain) Matchmaker* matchmaker;
@property(retain) CCLayer* challengeRecievedUI;
@property(retain) CCLayer* challengeAcceptedUI;
@property(assign) CCLabelTTF* challengeAcceptedOtherUserName;
@property(assign) CCLabelTTF* challengeAcceptedText;
@property(retain) NSString* challengedBoardId;
@end
@implementation PlayLayer
    float v_sw;
	float v_sh;

-(void)dealloc {
    NSLog(@"PlayLayer being deallocated");
    [self.board release];
    [self.navbar release];
    [self.background release];
    [self.gameOverLabel release];
    [self.matchmaker release];
    [self.challengeAcceptedUI release];
    [self.challengeRecievedUI release];
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
    [layer clickedNavIcon]; // Open up the menu
	// return the scene
	return scene;
}

+(CCScene*) loadExistingGame:(NSString*)boardId {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayLayer *layer = [PlayLayer node];
    [[layer board] load:boardId callmeback:YES];
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
        
        // add board
        self.board = [[[OnlineBoard alloc] initBoard:19]autorelease];
        [self.board setDelegate:self];
        [self.board setLoadDelegate:self];
        [self addChild:self.board z:1];
        
        self.llmenu = [[[LLMenu alloc] init]autorelease];
        [self addChild:self.llmenu z:11];
        [self.llmenu setVisible:NO];
        [self.llmenu setShowPagesIndicator:NO];
        [self.llmenu setMenuDelegate:self];
        [self.llmenu setPagesIndicatorNormalColor:ccc4(140, 140, 140, 255)];
        [self.llmenu setPagesIndicatorSelectedColor:ccc4(15, 222, 210, 255)];

        self.loginController = [[[LLLogInViewController alloc] init]autorelease];
        [self.loginController setDelegate:self];
        LLSignupViewController* signUp = [[[LLSignupViewController alloc]init]autorelease];
        [self.loginController setSignUpController:signUp];
        [[self.loginController signUpController] setDelegate:self];

        self.navbar = [[[NavBar alloc]init]autorelease];
        [self.navbar setDelegate:self];
        self.navbar.anchorPoint = ccp(0.0f, 0.0f);
        [self.navbar setPosition:ccp(0.0f, 0.0f)];
        [self addChild:self.navbar z:5];
        
        //BG
        self.background = [CCSprite spriteWithFile:@"black.bmp"];
        [self.background setAnchorPoint:ccp(0,0)];
        [self.background setPosition:ccp(0,0)];
        [self.background setOpacity:200];
        [self.background setVisible:NO];
        [self addChild:self.background z:9];
        
        // Game Over text
        self.gameOverLabel = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Zapfino" fontSize:32];
        [self.gameOverLabel setVisible:NO];
        [self.gameOverLabel setAnchorPoint:ccp(0.5f, 0.5f)];
        [self addChild:self.gameOverLabel z:8];
        [self.gameOverLabel setColor:ccc3(15, 222, 210)];
        [self screenSizeChangedTo:screenSize];
        
        //Matchmaker
        self.matchmaker = [[[Matchmaker alloc] init] autorelease];
        [self.matchmaker setDelegate:self];
        
        [self schedule:@selector(updateMatchmaker) interval:10.0f];
        [self schedule:@selector(clickedRefresh) interval:5.0f];
        
        //challenge UIs
        self.challengeAcceptedUI = [CCLayer node];
        CCLabelTTF* challengeAcceptedLabel = [CCLabelTTF labelWithString:@"Challenge Accepted" fontName:@"Zapfino" fontSize:24];
        [challengeAcceptedLabel setAnchorPoint:ccp(0.5f, 1.0f)];
        [self.challengeAcceptedUI addChild:challengeAcceptedLabel];
        self.challengeAcceptedOtherUserName = [CCLabelTTF labelWithString:@"" fontName:@"HelveticaNeue-UltraLightItalic" fontSize:24];
        [self.challengeAcceptedUI addChild:self.challengeAcceptedOtherUserName];
        
        [self.challengeAcceptedOtherUserName setAnchorPoint:ccp(0.5f, 1.0f)];
        self.challengeAcceptedText = [CCLabelTTF labelWithString:@"You've been challenged by" fontName:@"Zapfino" fontSize:18];
        [self.challengeAcceptedText setAnchorPoint:ccp(0.5, 1.0f)];
        [self.challengeAcceptedUI addChild:self.challengeAcceptedText];
        [CCMenuItemFont setFontName:@"Zapfino"];
        [CCMenuItemFont setFontSize:18];
        CCMenuItem* playTheChallenge = [CCMenuItemFont itemWithString:@"Play" block:^(id sender) {
            [self playChallenge];
        }];
        [self.challengeAcceptedUI addChild:playTheChallenge];
        
    }
    return self;
}
-(void)playChallenge {
    [self load:[self challengedBoardId]];
}
-(void)onEnter {
    [super onEnter];
    [self updateMatchmaker];
}

-(void) updateMatchmaker {
    NSLog(@"Updating matchmaker");
    [self.matchmaker updateIncomingChallenges];
    [self.matchmaker updateOutgoingChallenges];
    [self.matchmaker updateCurrentUsersBoards];
 }

-(void)challengeRecieved:(PFObject *)challenge {
    NSLog(@"Challenge Recieved.");
}
-(void)challengeWasAccepted:(PFObject *)challenge {
    NSLog(@"Challenge Accepted.");
}

-(void)boardsDidUpdate {
    if([self.llmenu visible]) {
        [self.llmenu updateBoardList];
    }
    [self.navbar countNotifications:[self.matchmaker currentUsersBoards] ignoreBoardId:[self.board getBoardId]];
}
-(NSArray*)getBoardList {
    return [self.matchmaker currentUsersBoards];
}
-(void)matchFound:(NSString *)otherUserId {
    NSLog(@"Match found: %@", otherUserId);
}

-(void)enterMatchmaking {
    [self.matchmaker enterMatchmaking];
}
-(void)exitMatchmaking {
    [self.matchmaker exitMatchmaking];
}
-(void)othersInMatchmakingDidUpdate {
    [self.llmenu othersInMatchmakingDidUpdate:[self.matchmaker othersInMatchmaking]];
}
-(void)challengeOtherUser:(NSString*)otherUserId otherUserName:(NSString *)otherUserName {
    [self.matchmaker challengeOtherUser:otherUserId otherPlayerName:otherUserName];
}

-(void)nextTurn {
    [[self.navbar score_atlas] setString:[NSString stringWithFormat:@"%d", [self.board getScore]]];
    [[self.navbar score_atlas] visit];
    [self.navbar.whitecaps setString:[NSString stringWithFormat:@"%d", [self.board whitecaps]]];
    [self.navbar.blackcaps setString:[NSString stringWithFormat:@"%d", [self.board blackcaps]]];
    [self.navbar setActivePlayer:self.board.currentPlayer];
}

-(void)receivedPushedBoardId:(NSString*)pushedBoardId {
    if ([[self.board getBoardId] isEqualToString:pushedBoardId]) {
        NSLog(@"Updating visible board.");
        [self load:pushedBoardId];
    }
    else {
        NSLog(@"Updating navbar");
        // TODO: Make this more efficient.
        [self.llmenu onUserChange];
    }
}

//LLMenu
-(void)load:(NSString *)boardId {
    [self.board load:boardId callmeback:YES];
}
-(void)boardDidLoad {
    if(self.board.black_player) {
        [self.navbar.blackPlayerName setString:[self.board.black_player objectForKey:@"username"]];
    }
    else {
        [self.navbar.blackPlayerName setString:@"Black"];
    }
    if(self.board.white_player) {
        [self.navbar.whitePlayerName setString:[self.board.white_player objectForKey:@"username"]];
    }
    else {
        [self.navbar.whitePlayerName setString:@"White"];
    }
    [self.gameOverLabel setVisible:self.board.gameOver];
    [self nextTurn];
    [self resume];
}
-(void)resume {
    [self.board setIsTouchEnabled:YES];
    [self.navbar setIsTouchEnabled:YES];
    [self.llmenu setVisible:NO];
//    [self.llmenu setIsTouchEnabled:NO];
    [self.background setVisible:NO];
}

-(void)signIn {
    [[CCDirector sharedDirector] presentViewController:self.loginController animated:YES completion:nil];
}
-(void) signOut {
//    PFInstallation* currentInstallation = [PFInstallation currentInstallation];
//    if ([currentInstallation objectForKey:@"channels"]) {
//        [currentInstallation removeObject:[PFUser currentUser].objectId forKey:@"channels"];
//        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
//            if(succeeded && !error) {
//                NSLog(@"Installation saved.");
//            }else {
//                NSLog(@"%@ %@\nInstallation Save Error.", error, [error userInfo]);
//            }
//        }];        
//    }
    [self.board reset];
    [self nextTurn]; // updates nav bar
    [PFUser logOut];
    [self.llmenu onUserChange];
    [self updateMatchmaker];
}

-(void)newGame {
    [self.board reset];
    [self.gameOverLabel setVisible:NO];
    [self nextTurn]; // Updates nav bar
    [self resume];
}

//Nav bar
-(void)clickedNavIcon {
    [self.llmenu onUserChange];
    [self.llmenu setVisible:YES];
    [self.background setVisible:YES];
    [self.board setIsTouchEnabled:NO];
    [self.navbar setIsTouchEnabled:NO];
    [self updateMatchmaker];
    [[self matchmaker] updateOthersInMatchmaking];
}
-(void)clickedRefresh {
    if (![self.board isCurrentPlayersTurn]) {
        [self.board refresh];
    }
}

-(void)clickedSave {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Name this board";
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* detailString = [[alertView textFieldAtIndex:0] text];
    NSLog(@"String is: %@", detailString);
    if([detailString length] <= 0 || buttonIndex == 0) {
        NSLog(@"Cancelled");
    }

    else{
        [[self board] saveWithName:detailString];
        return; //If cancel or 0 length string the string doesn't matter
    }
}

-(void)clickedPass {
    [self.board pass];
}
-(void)gameOver {
    [self.gameOverLabel setVisible:YES];
//    [self.background setVisible:YES];
    
    NSLog(@"Game over");
}
-(void)screenSizeChangedTo:(CGSize)size {
    [self.navbar setScreenSize:size];
    [self.board setPosition:ccp(size.width/2, size.height/2)];
    [self.background setScaleX:size.width];
    [self.background setScaleY:size.height];
    [self.llmenu setScreenSizeChangedTo:size];
    [self.gameOverLabel setPosition:ccp(size.width/2.0f, size.height/2.0f)];
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
    [self updateMatchmaker];
    [self.llmenu onUserChange];
    // Register for push notifications
//    PFInstallation* currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation addUniqueObject: [PFUser currentUser].objectId forKey:@"channels"];
//    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
//        if(succeeded && !error) {
//            NSLog(@"Installation saved.");
//        }else {
//            NSLog(@"%@ %@\nInstallation Save Error.", error, [error userInfo]);
//        }
//    }];
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    [self screenSizeChangedTo: [[CCDirector sharedDirector] winSize]];
}

/// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Error Logging in!");
    [self updateMatchmaker];
    [self.llmenu onUserChange];
}

/// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"Cancel Logging In!");
    [self.llmenu onUserChange];
    [self updateMatchmaker];
    [self screenSizeChangedTo: [[CCDirector sharedDirector] winSize]];
//    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
}
// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"Signed up user");
    [self screenSizeChangedTo: [[CCDirector sharedDirector] winSize]];
    [self.llmenu onUserChange];
    // Register for push notifications
//    PFInstallation* currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation addUniqueObject: [PFUser currentUser].objectId forKey:@"channels"];
//    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
//        if(succeeded && !error) {
//            NSLog(@"Installation saved.");
//        }else {
//            NSLog(@"%@ %@\nInstallation Save Error.", error, [error userInfo]);
//        }
//    }];
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:NULL];
}

@end
