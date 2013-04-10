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
-(void)challengeRecieved:(PFObject*)challenge;
-(void)challengeWasAccepted:(PFObject*)challenge;
@end

@interface Matchmaker : NSObject
@property(retain) NSMutableArray* currentUsersBoards; //array of board display info dicts for current user
// TODO make this^^ not a mutable array
@property(assign) NSObject<MatchmakerDelegate>* delegate;
-(void)doUpdate;
-(void)enterMatchmaking;
-(void)exitMatchmaking;

-(bool)isInMatchmaking;
-(NSArray*)othersInMatchmaking;

-(void)challengeOtherPlayer:(NSString*)otherPlayerId;
-(void)acceptChallenge:(PFObject*)challenge;
-(void)declineChallenge:(PFObject*)challenge;
@end
