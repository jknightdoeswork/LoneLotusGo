//
//  LLMenu.h
//  LoneLotusGo
//
//  Created by Jason Knight on 13-04-04.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "CCScrollLayer.h"

@protocol LLMenuDelegate<NSObject>
-(void)resume;
-(void)load:(NSString*)boardId;
-(void)newGame;
-(void)signIn;
-(void)signOut;
@end
@interface LLMenu : CCScrollLayer
@property(assign)CCNode<LLMenuDelegate>* menuDelegate;
-(void)onUserChange;
-(void)setScreenSizeChangedTo:(CGSize)size;
@end
