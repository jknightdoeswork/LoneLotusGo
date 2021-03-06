//
//  Matchmaker.h
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-29.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@protocol MatchmakerDelegate <NSObject>
-(void)matchFound:(NSString*) otherUserId;
-(void)boardsDidUpdate;
-(void)othersInMatchmakingDidUpdate;
-(void)challengeRecieved:(PFObject*)challenge;
@end

@interface Matchmaker : NSObject
@property(retain) NSMutableArray* currentUsersBoards; //array of board display info dicts for current user
// TODO make this^^ not a mutable array
@property(assign) NSObject<MatchmakerDelegate>* delegate;
-(void)updateCurrentUsersBoards;
-(void)updateIncomingChallenges;
-(void)updateOthersInMatchmaking;
-(NSArray*)othersInMatchmaking;

-(void)enterMatchmaking;
-(void)exitMatchmaking;

-(void)challengeOtherUser:(PFObject*)otherUser;
-(void)acceptChallenge:(PFObject*)challenge;
-(void)declineChallenge:(PFObject*)challenge;
@end
