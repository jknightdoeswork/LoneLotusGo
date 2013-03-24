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
    PlayOnlineViewController* po;
    PFLogInViewController *logInController;
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
		
        // Parse related
        logInController = [[PFLogInViewController alloc] init];
        [logInController setDelegate:self];
        [[logInController signUpController] setDelegate:self];
        po = [[PlayOnlineViewController alloc] initWithNibName:@"PlayOnlineViewController" bundle:nil];
        
        
        
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"LoneLotus Go" fontName:@"Helvetica Neue" fontSize:64];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		
		//
		// Leaderboards and Achievements
		//
        [ CCMenuItemFont setFontName:@"Zapfino"];
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:24];


		// Leaderboard Menu Item using blocks
//		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
//			
//			
//			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
//			leaderboardViewController.leaderboardDelegate = self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
//			
//			[leaderboardViewController release];
//		}
//									   ];
		
        // BEGIN CUSTOM CODE
        CCMenuItem* itemPlay = [CCMenuItemFont itemWithString:@"Play Local" block:^(id sender) {
			
            [[CCDirector sharedDirector] pushScene: [PlayLayer scene]];
            
		}];

        CCMenuItem* itemPlayOnline = [CCMenuItemFont itemWithString:@"Play Online" block:^(id sender) {
            [[CCDirector sharedDirector] presentViewController:logInController animated:YES completion:nil];
		}];
        
        
        
        // END CUSTOM CODE
		
		CCMenu *menu = [CCMenu menuWithItems:itemPlay, itemPlayOnline, nil];

		[menu alignItemsVerticallyWithPadding:10];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		// Add the menu to the layer
		[self addChild:menu];

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
