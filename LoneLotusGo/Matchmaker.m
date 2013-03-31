//
//  Matchmaker.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-29.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "Matchmaker.h"
#import <Parse/Parse.h>

/**
 * Parse Schema
 * Class: Matchmaker
 * user_id      : NSString User Id of user looking for a game
 */
@interface Matchmaker ()

@end

@implementation Matchmaker

-(void)enterMatchmaking {
    if (![PFUser currentUser]) {
        NSLog(@"EnterMatchmaking. Not logged in");
    }
    NSString* uid = [PFUser currentUser].objectId;
    PFQuery* query_for_others = [PFQuery queryWithClassName:@"Matchmaker"];
    [query_for_others whereKey:@"uid" notEqualTo:uid]; // Don't look for yourself!
    [query_for_others getFirstObjectInBackgroundWithBlock:^(PFObject* object, NSError* error) {
        if (!error && object) {
            NSString* other_uid = [object valueForKey:@"uid"];
            NSLog(@"Found match!: %@", other_uid);
            [self.delegate matchFound: other_uid];
            // TODO Tell the other guy that we are a match
        } else {
            // There was no other users. Check if were already in matchmaking
            NSLog(@"%@ %@\nEntering Matchmaking", error, [error userInfo]);
            PFQuery* query_for_myself = [PFQuery queryWithClassName:@"Matchmaker"];
            [query_for_myself whereKey:@"uid" equalTo:uid];
            [query_for_myself countObjectsInBackgroundWithBlock:^(int number, NSError* error) {
                if (!error && number == 0) {
                    // this uid has no matchmaker entity
                    PFObject* entity = [PFObject objectWithClassName:@"Matchmaker"];
                    [entity setObject:uid forKey:@"uid"];
                    [entity saveInBackground];
                }
                else if (number > 0) {
                    NSLog(@"We are in matchmaking already");
                }
                else {
                    NSLog(@"Error: %@ %@\nBad Count", error, [error userInfo]);
                }
            }];

        }
    }];
}

-(void)exitMatchmaking {
    if (![PFUser currentUser]) {
        NSLog(@"EnterMatchmaking. Not logged in");
    }
    NSString* uid = [PFUser currentUser].objectId;
    PFQuery* query = [PFQuery queryWithClassName:@"Matchmaker"];
    [query whereKey:@"uid" equalTo:uid];
    [query getFirstObjectInBackgroundWithBlock: ^(PFObject *matchmaker, NSError *error) {
        if (!error) {
            NSLog(@"Deleting matchmaker entity");
            [matchmaker deleteInBackground];
        } else {
            // Log details of our failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
@end
