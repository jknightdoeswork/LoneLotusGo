//
//  HelloWorldLayer.h
//  LoneLotusGo
//
//  Created by Brendan King on 13-01-26.
//  Copyright VendAsta Technologiesfffff Inc.  2013. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "PlayLayer.h"
#import "LLBaseLayer.h"
#import <Parse/Parse.h>
#import "LLMainMenu.h"
#import "Matchmaker.h"
// HelloWorldLayer
@interface HelloWorldLayer : LLBaseLayer <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, LLMainMenuDelegate, MatchmakerDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
