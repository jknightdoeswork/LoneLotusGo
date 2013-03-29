//
//  OnlineBoard.h
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-26.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "Board.h"
#import <Parse/Parse.h>
@interface OnlineBoard : Board

@property (retain) NSString* board_id;
@property (retain) PFObject* pf_object;
@property (retain) NSString* w_player_id;
@property (retain) NSString* b_player_id;

-(void)load:(NSString*) boardId;
-(void)save;

@end
