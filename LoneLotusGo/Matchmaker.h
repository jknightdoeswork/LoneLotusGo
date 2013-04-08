//
//  Matchmaker.h
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-29.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MatchmakerDelegate <NSObject>
-(void)matchFound:(NSString*) otherUserId;
-(void)boardsDidUpdate;
@end

@interface Matchmaker : NSObject
@property(retain) NSMutableArray* currentUsersBoards; //array of board display info dicts for current user
// TODO make this^^ not a mutable array
@property(assign) NSObject<MatchmakerDelegate>* delegate;
-(void)doUpdate;
-(void)enterMatchmaking;
-(void)exitMatchmaking;
@end
