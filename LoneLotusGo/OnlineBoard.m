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
 *      "white_player"          :   NSString*
 *      "black_player"          :   NSString*
 *      "pieces"                :   NSArray*        // array of piece data
 *      "savename"              :   NSString*       // displays in menu
 *      "justpassed"            :   NSNumber*       // true if the last player passed
 *      "gameover"              :   NSNumber*       // true if the game is over
 *      Piece Data Schema
 *          "player"    :   NSNumber*   // (char) current player
 *          "x_index"   :   NSNumber*   // x_index
 *          "y_index"   :   NSNumber*   // y_index
 */
@interface OnlineBoard () {
}

@end
@implementation OnlineBoard

-(void)refresh {
    if([self getBoardId] != nil) {
        [self load:[self getBoardId]];
    }
}

-(void)load:(NSString*) boardId {
    NSLog(@"Loading with boardId: %@", boardId);
    [self removeAllChildrenWithCleanup:NO];
    [[self unplacedStone] setVisible:NO];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Board"];
    [query includeKey:@"white_player"];
    [query includeKey:@"black_player"];

    PFObject *gameState = [query getObjectWithId:boardId];
    self.pf_object = gameState;
    
    if (gameState == nil) {
        NSLog(@"No board found for id: %@", boardId);
    }
    
    // Current player
    char cp = (char)[[gameState objectForKey:@"current_player"] intValue];
    [self setCurrentPlayer:cp];

    // Just Passed
    BOOL just_passed = [[gameState objectForKey:@"justpassed"] boolValue];
    [self setJustpassed:just_passed];
    
    // Game Over
    BOOL gameOver = [[gameState objectForKey:@"gameover"] boolValue];
    [self setGameOver:gameOver];

    // Players
    PFObject* white_player = [gameState objectForKey:@"white_player"];
    PFObject* black_player = [gameState objectForKey:@"black_player"];

    [self setWhite_player:white_player];
    [self setBlack_player:black_player];
    
    // TODO LOAD/SAVE BLACK/WHITE CAPTURES
    //    int white_score = [[gameState objectForKey:@"white_score"] intValue];
    //    [[self scoreboard] setWhiteScore:white_score];
    //    int black_score = [[gameState objectForKey:@"black_score"] intValue];
    //    [[self scoreboard] setBlackScore:black_score];
    
    // Pieces
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
    [self.pf_object release];
    [self.white_player release];
    [self.black_player release];
    [super dealloc];
}

-(void)saveWithName:(NSString*)name {
    if (self.pf_object == nil) {
        self.pf_object = [PFObject objectWithClassName:@"Board"];
    }
    [self.pf_object setObject:name forKey:@"savename"];
    [self save];
}

-(void)save {
    if(![PFUser currentUser]) {
        NSLog(@"Not logged in. Not saving.");
        return;
    }
    if(![[[PFUser currentUser] objectId] isEqualToString:[[self white_player] objectId]] && ![[[PFUser currentUser] objectId] isEqualToString: [[self black_player] objectId]] ) {
        NSLog(@"User id: %@ not found in game player ids: %@ %@\nNot saving.", [[PFUser currentUser] objectId], [[self white_player] objectId], [[self black_player] objectId]);
        return;
    }
    NSString* otherPlayerId = [[PFUser currentUser] objectId] == [[self white_player] objectId] ? [[self black_player] objectId]: [[self white_player] objectId];

    if (self.pf_object == nil) {
        self.pf_object = [PFObject objectWithClassName:@"Board"];
    }
    id white_player = self.white_player != nil ? self.white_player : [NSNull null];
    id black_player = self.black_player != nil ? self.black_player : [NSNull null];
    
    NSNumber* ns_j = [NSNumber numberWithBool:[self justpassed]];
    NSNumber* ns_g = [NSNumber numberWithBool:[self gameOver]];
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
    
    [[self pf_object] setObject:ns_j forKey:@"justpassed"];
    [[self pf_object] setObject:ns_g forKey:@"gameover"];
    [[self pf_object] setObject:ns_c forKey:@"current_player"];
    [[self pf_object] setObject:ns_n forKey:@"n"];
    [[self pf_object] setObject:ns_w forKey:@"white_score"];
    [[self pf_object] setObject:ns_b forKey:@"black_score"];
    [[self pf_object] setObject:pieces forKey:@"pieces"];
    [[self pf_object] setObject:black_player forKey:@"white_player"];
    [[self pf_object] setObject:white_player forKey:@"black_player"];
    
    [[self pf_object] saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
        if(!error) {
            NSLog(@"Game Saved.");
            if (otherPlayerId != nil) {
                NSLog(@"Pushing to other player id: %@", otherPlayerId);
                PFQuery* installationQuery = [PFInstallation query];
                [installationQuery whereKey:@"userid" equalTo:otherPlayerId];
                
                PFPush* push = [PFPush push];
                [push setQuery:installationQuery];
                [push setData:[NSDictionary dictionaryWithObject:[[self pf_object] objectId] forKey:@"boardid"]];
                
                [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
                    if(!error) {
                        NSLog(@"%@ %@\n. Push send error.", error, [error userInfo]);
                    }else {
                        NSLog(@"Push sent successfully.");
                    }
                }];
            }
        }
        else {
            NSLog(@"ERROR Saving Game: %@ %@.", error, [error userInfo]);
        }
    }];
}

-(NSString*)getBoardId {
    return [[self pf_object]objectId];
}

-(void) nextTurn {
    [super nextTurn];
    if (self.white_player != nil && self.black_player != nil){
        NSLog(@"Saving To Parse");
        [self save];
    }
    
    // TODO PUSH TO OTHER GUY
}


-(BOOL)canPutPieceAt:(int)x_index y_index:(int)y_index {
    if([self currentPlayer] == P_WHITE) {
        if ([self white_player] == nil || [[[self white_player] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            return [super canPutPieceAt:x_index y_index:y_index];
        }
    }
    else if ([self currentPlayer] == P_BLACK) {
        if ([self black_player] == nil || [[[self black_player] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            return [super canPutPieceAt:x_index y_index:y_index];
        }
    }
    return NO;
}

@end
