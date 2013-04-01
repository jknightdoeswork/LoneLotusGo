//
//  IntroLayer.h
//  LoneLotusGo
//
//  Created by Brendan King on 13-01-26.
//  Copyright VendAsta Technologies Inc.  2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface IntroLayer : CCLayer
{
}
@property(retain) NSString* transitionToBoardId;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
+(CCScene*)sceneWithTransitionToBoard:(NSString*)boardId;
@end
