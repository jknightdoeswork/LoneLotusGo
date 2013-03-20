//
//  Utilities.m
//  LoneLotusGo
//
//  Created by Brendan King on 13-01-29.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
+(void)log_point:(char *)name in_coordinate_system:(char)coord_system from_world:(CCNode*)node point:(CGPoint)p 
{
    switch (coord_system) {
        case 'W': {
            CGPoint other = [node convertToNodeSpace:p];
            NSLog(@"%s\t|%.2f\t%.2f|%.2f\t%.2f", name, p.x, p.y, other.x, other.y);
            break;
        }
        case 'N': {
            CGPoint other = [node convertToWorldSpace:p];
            NSLog(@"%s\t|%.2fx%.2f|%.2fx%.2f", name, other.x, other.y, p.x, p.y);
            break;
        }
    };
}

@end
