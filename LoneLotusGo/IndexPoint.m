//
//  IndexPoint.m
//  LoneLotusGo
//
//  Created by Brendan King on 13-02-09.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "IndexPoint.h"

@implementation IndexPoint
@synthesize i;
@synthesize j;
-(id) initWithInts:(int)x y:(int)y {
    [self setI:x];
    [self setJ:y];
    return [super init];
}
@end
