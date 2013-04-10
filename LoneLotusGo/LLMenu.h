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
-(void)enterMatchmaking;
-(void)exitMatchmaking;
-(void)challengeOtherUser:(NSString*)otherUserId otherUserName:(NSString*)otherUserName;
-(NSArray*)getBoardList;
@end
@interface LLMenu : CCScrollLayer
@property(assign)CCNode<LLMenuDelegate>* menuDelegate;
-(void)onUserChange;
-(void)updateBoardList;
-(void)setScreenSizeChangedTo:(CGSize)size;
-(void)othersInMatchmakingDidUpdate:(NSArray*)others;
@end
