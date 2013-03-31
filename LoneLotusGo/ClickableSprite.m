//
//  ClickableSprite.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-30.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "ClickableSprite.h"

@implementation ClickableSprite
-(void) dealloc {
    [self.touchBegan release];
    [super dealloc];
}
-(void) registerTouch {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertToNodeSpace: [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]]];
    CGRect targetRect = CGRectMake(0.0f,
                                   0.0f,
                                   self.contentSize.width,
                                   self.contentSize.height);
    if (CGRectContainsPoint(targetRect, location)) {
            return self.touchBegan(touch, event);
    }
    return NO;

}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    return;
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    return;
}
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    return;
}
@end
