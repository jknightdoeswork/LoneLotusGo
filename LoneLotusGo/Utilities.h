//
//  Utilities.h
//  LoneLotusGo
//
//  Created by Brendan King on 13-01-29.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCNode.h"

@interface Utilities : NSObject
// Logs a point in a CCNode's Node Space and it's world space
+(void) log_point:(char*)name in_coordinate_system:(char)coord_system from_world:(CCNode*)node point:(CGPoint)p;
@end
