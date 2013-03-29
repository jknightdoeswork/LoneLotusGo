//
//  NavBar.h
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-27.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//
#import "CCLayer.h"
#import "OnlineBoard.h"
@interface NavBar : CCLayer
@property(assign) OnlineBoard* board;
/**
 * Adjusts the children's position to a screensize.
 */
-(void)setScreenSize:(CGSize)size;
@end
