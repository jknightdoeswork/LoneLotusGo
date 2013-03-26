//
//  LLBaseLayer.h
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-25.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "CCLayer.h"
#import "CCDirector.h"

@protocol ScreenSizeChangedDelegate <NSObject>

-(void)screenSizeChangedTo:(CGSize)size;

@end

@interface LLBaseLayer : CCLayer<CCDirectorDelegate, ScreenSizeChangedDelegate>
@end
