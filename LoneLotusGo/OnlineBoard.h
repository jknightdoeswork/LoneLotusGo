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

-(void)load:(NSString*) boardId;
-(void)save;

@end
