//
//  IndexPoint.h
//  LoneLotusGo
//
//  Created by Brendan King on 13-02-09.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexPoint : NSObject
@property(nonatomic) int i;
@property(nonatomic) int j;

-(id) initWithInts:(int)x y:(int)y;
@end
