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
 *      "n"                     :   NSNumber*       // nxn board size
 *      "current_player"        :   NSNumber*       // (char) current player
 *      "white_score"           :   NSNumber*       // whites score
 *      "black_score"          :   NSNumber*       // blacks score
 *      "pieces"                :   NSArray*        // array of piece data
 *      Piece Data Schema
 *          "player"    :   NSNumber*   // (char) current player
 *          "x_index"   :   NSNumber*   // x_index
 *          "y_index"   :   NSNumber*   // y_index
 */

@implementation OnlineBoard
-(id) initFromBoardId:(NSString*)boardId scoreboard:(Scoreboard*)scoreboard {
    PFQuery *query = [PFQuery queryWithClassName:@"Board"];
    PFObject *gameState = [query getObjectWithId:boardId];
    self.pf_object = gameState;
    if (gameState == nil) {
        NSLog(@"No board found for id: %@", boardId);
        return nil;
    }
    int gs_n = [[gameState objectForKey:@"n"] intValue];
    if (self = [super initBoard:gs_n s_board:scoreboard]) {
        self.board_id = boardId;
        
        char cp = (char)[[gameState objectForKey:@"current_player"] intValue];
        int white_score = [[gameState objectForKey:@"white_score"] intValue];
        int black_score = [[gameState objectForKey:@"black_score"] intValue];
        
        [self setCurrentPlayer:cp];
        [[self scoreboard] setWhiteScore:white_score];
        [[self scoreboard] setBlackScore:black_score];
        
        NSArray* pieces = [gameState objectForKey:@"pieces"];
        for (NSDictionary* piece_data in pieces) {
            char player = [[piece_data objectForKey:@"player"] intValue];
            int x_index = [[piece_data objectForKey:@"x_index"] intValue];
            int y_index = [[piece_data objectForKey:@"y_index"] intValue];
            
            Stone* stone = [[Stone alloc] initForGoGame:self for_player:player x_index:x_index y_index:y_index];
            [self addChild:stone z:1.0 tag:[super get_index:x_index j:y_index]];
        }
    }
    return self;
}

-(void)dealloc {
    [self.board_id release];
    [super dealloc];
}

-(void)save {
    if (self.pf_object == nil) {
        self.pf_object = [PFObject objectWithClassName:@"Board"];
    }
    NSNumber* ns_c = [NSNumber numberWithChar:[self currentPlayer]];
    NSNumber* ns_n = [NSNumber numberWithInt:[self n]];
    NSNumber* ns_w = [NSNumber numberWithInt:[[self scoreboard] getWhiteScore]];
    NSNumber* ns_b = [NSNumber numberWithInt:[[self scoreboard] getBlackScore]];
    NSMutableArray* pieces = [NSMutableArray arrayWithCapacity:[[self children] count]];
    for (Stone* stone in [self children]) {
        if (![stone isUnplacedStone]) {
            NSDictionary *stone_dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:[stone getXIndex]], @"x_index",
                                        [NSNumber numberWithInt:[stone getYIndex]], @"y_index",
                                        [NSNumber numberWithChar:[stone playerFlag]], @"player",
                                        nil];
            [pieces addObject:stone_dict];
        }
    }
    
    [[self pf_object] setObject:ns_c forKey:@"current_player"];
    [[self pf_object] setObject:ns_n forKey:@"n"];
    [[self pf_object] setObject:ns_w forKey:@"white_score"];
    [[self pf_object] setObject:ns_b forKey:@"black_score"];
    [[self pf_object] setObject:pieces forKey:@"pieces"];
    
    [[self pf_object] saveInBackground];
}
@end
