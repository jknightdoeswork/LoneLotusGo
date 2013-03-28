//
//  PlayLayer.m
//  FirstCoco
//
//  Created by Brendan King on 13-01-19.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "PlayLayer.h"

@implementation PlayLayer
    float v_sw;
	float v_sh;

-(void)dealloc {
    NSLog(@"PlayLayer being deallocated");

    [board release];
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
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    NavBar* navbar = [[NavBar alloc]init];
    [navbar setScreenSize:screenSize];
    navbar.anchorPoint = ccp(0.0f, 0.0f);
    [navbar setPosition:ccp(0.0f, 0.0f)];
	[scene addChild:navbar];
    
	// return the scene
	return scene;
}

-(void) onEnter
{
	[super onEnter];
//    self.isTouchEnabled = YES;
    // Screen size
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    v_sw = screenSize.width;
    v_sh = screenSize.height;
    NSLog(@"%fx%f Screen", v_sw,v_sh);
    
    Scoreboard* scoreboard = [[Scoreboard alloc] initWithScores:0 black:0];
    [self addChild:scoreboard z:2];
    
    // add board
    board = [[Board alloc] initBoard:18 s_board:scoreboard];
    [self addChild:board z:1];
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


@end
