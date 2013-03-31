//
//  ClickableSprite.h
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-30.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"

@interface ClickableSprite : CCSprite <CCTargetedTouchDelegate>
@property(copy) BOOL(^touchBegan)(UITouch* touch, UIEvent* event);
-(void) registerTouch;
@end
