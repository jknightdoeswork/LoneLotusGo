//
//  OnlineBoard.h
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-26.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "Board.h"
#import <Parse/Parse.h>

@protocol OnlineBoardDelegate <NSObject>

-(void)boardDidLoad;

@end

@interface OnlineBoard : Board
@property (retain) PFObject* pf_object;
@property (retain) PFObject* white_player;
@property (retain) PFObject* black_player;
@property (assign) CCNode<OnlineBoardDelegate>* loadDelegate;

-(void)load:(NSString*) boardId;
-(void)refresh;
-(void)save;
-(void)saveWithName:(NSString*)name;

-(NSString*)getBoardId;
@end
