//
//  Matchmaker.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-29.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "Matchmaker.h"
#import <Parse/Parse.h>
#import "OnlineBoard.h"
/**
 * Parse Schema
 * Class: Matchmaker
 * user_id      : NSString User Id of user looking for a game
 */
@interface Matchmaker ()
@property(retain) NSArray* othersInMatchmaking_;
@end

@implementation Matchmaker

-(id)init {
    if(self = [super init]) {
        self.currentUsersBoards = [NSMutableArray arrayWithCapacity:6];
    }
    return self;
}

-(void)dealloc {
    [self.currentUsersBoards removeAllObjects];
    [self.currentUsersBoards release];
    [self.othersInMatchmaking_ release];
    [super dealloc];
}

-(void)updateOthersInMatchmaking {
    if(![PFUser currentUser]) {
        NSLog(@"isInMatchmaking. Not logged in.");
        return;
    }
    NSString* uid = [PFUser currentUser].objectId;
    
    PFQuery* query = [PFUser query];
    [query whereKey:@"objectId" notEqualTo:uid];
    [query whereKey:@"inMatchmaking" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error) {
        if (error) {
            NSLog(@"Error: %@ %@\nupdateOthersInMatchmaking", error, [error userInfo]);
        }
        else {
            [self setOthersInMatchmaking_:objects];
            NSLog(@"Found %d others in matchmaking.", [[self othersInMatchmaking_] count]);
            [self.delegate othersInMatchmakingDidUpdate];
        }
    }];
}
-(NSArray*)othersInMatchmaking {
    return [self othersInMatchmaking_];
}

-(void)enterMatchmaking {
    if (![PFUser currentUser]) {
        NSLog(@"Warning: enterMatchmaking. Not logged in.");
        return;
    }
    if([[[PFUser currentUser] objectForKey:@"inMatchmaking"] boolValue]) {
        NSLog(@"Warning: enterMatchmaking. Already in matchmaking.");
        return;
    }
    [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:@"inMatchmaking"];
    [[PFUser currentUser] saveInBackground];
    NSLog(@"Entered matchmaking");
}

-(void)exitMatchmaking {
    if (![PFUser currentUser]) {
        NSLog(@"Warning: exitMatchmaking. Not logged in.");
        return;
    }
    if(![[[PFUser currentUser] objectForKey:@"inMatchmaking"] boolValue]) {
        NSLog(@"Warning: exitMatchmaking: Already not in matchmaking");
        return;
    }
    [[PFUser currentUser] setObject:[NSNumber numberWithBool:NO] forKey:@"inMatchmaking"];
    [[PFUser currentUser] saveInBackground];
    NSLog(@"Exited matchmaking");
}

-(void)updateCurrentUsersBoards {
    if(![PFUser currentUser]) {
        return;
    }
    PFQuery* white_query = [PFQuery queryWithClassName:@"Board"];
    [white_query whereKey:@"white_player" equalTo:[PFUser currentUser]];
    
    PFQuery* black_query = [PFQuery queryWithClassName:@"Board"];
    [black_query whereKey:@"black_player" equalTo:[PFUser currentUser]];
    
    NSArray* queries = [NSArray arrayWithObjects:white_query, black_query, nil];
    PFQuery* both_query = [PFQuery orQueryWithSubqueries:queries];
    
    [both_query includeKey:@"white_player"]; // Fetch the player entities, as well.
    [both_query includeKey:@"black_player"];
    
    [both_query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error){
        if(!error) {
            NSLog(@"Query for players board ids successful. %d found.", [objects count]);
            [self.currentUsersBoards removeAllObjects];
            for(PFObject* board in objects) {
                [self.currentUsersBoards addObject:[OnlineBoard getBoardDisplayInfoDict:board]];
            }
            [[self delegate] boardsDidUpdate];
        }
        else {
            NSLog(@"updateCurrentUsersBoards Error %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)challengeOtherUser:(PFObject*)otherUser {
    NSLog(@"challenge other user %@", [otherUser objectId]);
    if(![PFUser currentUser]) {
        NSLog(@"Warning. challengeOtherUser not logged in.");
        return;
    }
    NSString* myUsername = [[PFUser currentUser]username];
    NSString* otherPlayerName = [otherUser objectForKey:@"username"];
    PFObject* challenge = [PFObject objectWithClassName:@"Challenge"];
    
    [challenge setObject:otherUser forKey:@"challengee"];
    [challenge setObject:otherPlayerName forKey:@"challengeeName"];
    [challenge setObject:myUsername forKey:@"challengerName"];
    [challenge setObject:[PFUser currentUser] forKey:@"challenger"];
    
    [challenge setObject:[NSNumber numberWithBool:NO] forKey:@"accepted"];
    
    [challenge saveInBackground];
}

-(void)updateIncomingChallenges {
    if(![PFUser currentUser]) {
        NSLog(@"Warning. updateIncomingChallenges not logged in.");
        return;
    }
    if(![[[PFUser currentUser] objectForKey:@"inMatchmaking"]boolValue]) {
        NSLog(@"Warning. updateIncomingChallenges not in matchmaking.");
        return;
    }
    PFQuery* incomingquery = [PFQuery queryWithClassName:@"Challenge"];
    [incomingquery whereKey:@"challengee" equalTo:[PFUser currentUser]];
    [incomingquery whereKey:@"accepted" equalTo:[NSNumber numberWithBool:NO]];
    [incomingquery includeKey:@"challenger"];
    [incomingquery includeKey:@"challengee"];
    
    [incomingquery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(error) {
            NSLog(@"updateOutgoingChallenges Error %@ %@", error, [error userInfo]);
        }
        else {
            [[self delegate] challengeRecieved:object];
        }
    }];
}

-(void)acceptChallenge:(PFObject*)challenge {
    [challenge setObject:[NSNumber numberWithBool:YES] forKey:@"accepted"];
    [challenge saveInBackground];
    [OnlineBoard createOnlineGameInBackground:[challenge objectForKey:@"challengee"] whitePlayer:[challenge objectForKey:@"challenger"]];
}
-(void)declineChallenge:(PFObject*)challenge {
    [challenge deleteInBackground];
}
@end
