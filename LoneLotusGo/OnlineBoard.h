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

@property (retain) PFObject* pf_object;
@property (retain) NSString* white_player;
@property (retain) NSString* black_player;

-(void)load:(NSString*) boardId;
-(void)save;

-(NSString*)getBoardId;
@end
