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
#import "LLMainMenu.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#pragma mark - HelloWorldLayer
@interface HelloWorldLayer (){
    PlayOnlineViewController* po;
    PFLogInViewController *logInController;
    LLMainMenu *llmenu;
    CCSprite *logo;
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

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation");
	return YES;
}
-(void) updateProjection {
    NSLog(@"Update projection");
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	CGSize size;
	if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			size = CGSizeMake(768, 1024);
		else
			size = CGSizeMake(320, 480 );
        
	} else if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			size = CGSizeMake(1024, 768);
		else
			size = CGSizeMake(480, 320 );
	}

    [llmenu setScreenSize:size];
    [logo setPosition:ccp(size.width/2, 0)];
}


-(void)onEnter {
    // ask director for the window size
    [super onEnter];
    NSLog(@"On enter called");
    CGSize size = [[CCDirector sharedDirector] winSize];
	[[CCDirector sharedDirector] setDelegate:self];
    // position the label on the center of the screen
    [logo setPosition:ccp( size.width /2 , size.height )];
    [llmenu setScreenSize:size];
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
        po = [[PlayOnlineViewController alloc] initWithNibName:@"PlayOnlineViewController" bundle:nil];

		// "LoneLotusGo" title
        logo = [CCSprite spriteWithFile:@"logo.png"];
        [logo setAnchorPoint:ccp(0.5, 1.0)];
		[self addChild: logo z:1];
		
        // Menus

        llmenu = [[LLMainMenu alloc] initWithScreenSize:size];
//        [llmenu setAnchorPoint:ccp(0.0f, 0.0f)];
//        [llmenu setPosition:ccp(0.0f, 0.0f)];
        [self addChild:llmenu z:10];
	}
	return self;
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[logInController release];
    [po release];
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark PFLogInViewControllerDelegate Methods
/*! @name Responding to Actions */
/// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"Logged in!");
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:^{
        [[CCDirector sharedDirector] presentViewController:po animated:YES completion:nil];
    }];
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
