//
//  HelloWorldLayer.m
//  LoneLotusGo
//
//  Created by Brendan King on 13-01-26.
//  Copyright VendAsta Technologies Inc.  2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "PlayOnlineViewController.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#pragma mark - HelloWorldLayer
@interface HelloWorldLayer (){
    PFLogInViewController *logInController;
    LLMainMenu *llmenu;
    CCSprite *logo;
    Matchmaker *matchmaker;
}
@end
// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // Parse login controllers
        logInController = [[PFLogInViewController alloc] init];
        [logInController setDelegate:self];
        [[logInController signUpController] setDelegate:self];
        
		// "LoneLotusGo" title
        logo = [CCSprite spriteWithFile:@"logo.png"];
        [logo setAnchorPoint:ccp(0.5, 1.0)];
        [logo setPosition:ccp( size.width /2 , size.height )];
		[self addChild: logo z:1];

        // Menus
        llmenu = [[LLMainMenu alloc] init];
        [llmenu setScreenSize:size];
        [llmenu setDelegate:self];
        [self addChild:llmenu z:10];
        
        // Matchmaker
        matchmaker = [[Matchmaker alloc] init];
        [matchmaker setDelegate:self];
	}
	return self;
}

-(void)onEnter {
    [super onEnter];
    [llmenu onUserChange];
    NSLog(@"HelloWorldLayer.onEnter called");
}
-(void)screenSizeChangedTo:(CGSize)size {
    [llmenu setScreenSize:size];
    [logo setPosition:ccp(size.width/2.0f, size.height)];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[logInController release];
    [llmenu release];
    [matchmaker release];
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark LLMainMenu callbacks
-(void)signIn {
    NSLog(@"Sign In");
    [[CCDirector sharedDirector] presentViewController:logInController animated:YES completion:nil];
}
-(void)play {
    NSLog(@"Play");
    [[CCDirector sharedDirector] pushScene:[PlayLayer scene]];
}
-(void)matchmaking {
    [matchmaker enterMatchmaking];
}
-(void) matchFound:(NSString *)otherUserId {
    NSLog(@"MATCH FOUND!");
    [[CCDirector sharedDirector] pushScene:[PlayLayer startNewOnlineGame:otherUserId]];
}

-(void)signOut {
    NSLog(@"Sign out");
    [matchmaker exitMatchmaking];
    [PFUser logOut];
    [llmenu onUserChange];
}


#pragma mark PFLogInViewControllerDelegate Methods
/*! @name Responding to Actions */
/// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"Logged in!");
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    [llmenu onUserChange];
    // Register for push notifications
    PFInstallation* currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject: [PFUser currentUser].objectId forKey:@"channels"];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
        if(succeeded && !error) {
            NSLog(@"Installation saved.");
        }else {
            NSLog(@"%@ %@\nInstallation Save Error.", error, [error userInfo]);
        }
    }];
}

/// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Error Logging in!");
    [llmenu onUserChange];
}

/// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"Cancel Logging In!");
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    [llmenu onUserChange];
}
// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"Signed up user");
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:NULL];
    [llmenu onUserChange];
    PFInstallation* currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject: [PFUser currentUser].objectId forKey:@"channels"];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
        if(succeeded && !error) {
            NSLog(@"Installation saved.");
        }else {
            NSLog(@"%@ %@\nInstallation Save Error.", error, [error userInfo]);
        }
    }];
}
@end
