//
//  OnlineBoard.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-26.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "OnlineBoard.h"
#import "Stone.h"

/**
 * Parse Schema:
 * Board
 *      "current_player"        :   NSNumber*       // (char) current player
 *      "white_score"           :   NSNumber*       // whites score
 *      "black_score"           :   NSNumber*       // blacks score
 *      "pieces"                :   NSArray*        // array of piece data
 *      Piece Data Schema
 *          "player"    :   NSNumber*   // (char) current player
 *          "x_index"   :   NSNumber*   // x_index
 *          "y_index"   :   NSNumber*   // y_index
 */
@interface OnlineBoard () {
}

@end
@implementation OnlineBoard

-(void)load:(NSString*) boardId {
    [self removeAllChildrenWithCleanup:YES];
    [[self unplacedStone] setVisible:NO];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Board"];
    PFObject *gameState = [query getObjectWithId:boardId];
    self.pf_object = gameState;
    self.board_id = boardId;
    
    if (gameState == nil) {
        NSLog(@"No board found for id: %@", boardId);
    }
    
    char cp = (char)[[gameState objectForKey:@"current_player"] intValue];
    int white_score = [[gameState objectForKey:@"white_score"] intValue];
    int black_score = [[gameState objectForKey:@"black_score"] intValue];
    
    [self setCurrentPlayer:cp];
    [[self scoreboard] setWhiteScore:white_score];
    [[self scoreboard] setBlackScore:black_score];
    
    NSArray* pieces = [gameState objectForKey:@"pieces"];
    for (NSDictionary* piece_data in pieces) {
        char player = (char)[[piece_data objectForKey:@"player"] intValue];
        int x_index = [[piece_data objectForKey:@"x_index"] intValue];
        int y_index = [[piece_data objectForKey:@"y_index"] intValue];
        
        Stone* stone = [[Stone alloc] initForGoGame:self for_player:player x_index:x_index y_index:y_index];
        [self addChild:stone z:1.0 tag:[super get_index:x_index j:y_index]];
    }
}

-(void)dealloc {
    [self.board_id release];
    [super dealloc];
}

-(void)save {
    if (self.pf_object == nil) {
        self.pf_object = [PFObject objectWithClassName:@"Board"];
    }
    id white_player = self.w_player_id != nil ? self.w_player_id : [NSNull null];
    id black_player = self.b_player_id != nil ? self.b_player_id : [NSNull null];

    NSNumber* ns_c = [NSNumber numberWithInt:[self currentPlayer]];
    NSNumber* ns_n = [NSNumber numberWithInt:[self n]];
    NSNumber* ns_w = [NSNumber numberWithInt:[[self scoreboard] getWhiteScore]];
    NSNumber* ns_b = [NSNumber numberWithInt:[[self scoreboard] getBlackScore]];
    NSMutableArray* pieces = [NSMutableArray arrayWithCapacity:[[self children] count]];

    for (Stone* stone in [self children]) {
        if (![stone isUnplacedStone]) {
            NSDictionary *stone_dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:[stone getXIndex]], @"x_index",
                                        [NSNumber numberWithInt:[stone getYIndex]], @"y_index",
                                        [NSNumber numberWithInt:[stone playerFlag]], @"player",
                                        nil];
            [pieces addObject:stone_dict];
        }
    }
    
    [[self pf_object] setObject:ns_c forKey:@"current_player"];
    [[self pf_object] setObject:ns_n forKey:@"n"];
    [[self pf_object] setObject:ns_w forKey:@"white_score"];
    [[self pf_object] setObject:ns_b forKey:@"black_score"];
    [[self pf_object] setObject:pieces forKey:@"pieces"];
    [[self pf_object] setObject:black_player forKey:@"white_player"];
    [[self pf_object] setObject:white_player forKey:@"black_player"];
    
    [[self pf_object] saveInBackground];
}
@end
