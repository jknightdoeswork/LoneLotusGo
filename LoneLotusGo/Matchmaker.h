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
@end

@interface Matchmaker : NSObject
@property(assign) NSObject<MatchmakerDelegate>* delegate;

-(void)enterMatchmaking;
-(void)exitMatchmaking;
@end