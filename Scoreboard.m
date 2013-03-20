//
//  Scoreboard.m
//  LoneLotusGo
//
//  Created by Brendan King on 13-02-16.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "Scoreboard.h"

@interface Scoreboard ()
    @property(nonatomic, retain) CCSprite* background;
    @property(nonatomic, retain) CCLabelAtlas* white_char_atlas;
    @property(nonatomic, retain) CCLabelAtlas* black_char_atlas;
@end
@implementation Scoreboard {
    int w;
    int b;
}
@synthesize background;
@synthesize white_char_atlas;
@synthesize black_char_atlas;

-(id)initWithScores:(int)white black:(int)black {
    self = [super init];
    if (self) {
        w               = white;
        b               = black;
        
        // Add background image
        background      = [CCSprite spriteWithFile:@"blackvswhite.png"];
        CGSize winSize  = [[CCDirector sharedDirector]winSize];
        [background setPosition:CGPointMake(winSize.width/2.0f, winSize.height - (background.contentSize.height/2.0f))];
        [self addChild:background];
        
        
        // Add white score text
        CCLabelAtlas* _char_atlas  = [[CCLabelAtlas alloc]  initWithString:@"0" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'];
        self.white_char_atlas = _char_atlas;
        [_char_atlas release];
        
        [self.white_char_atlas setColor:ccc3(0, 0, 0)];
        [self.white_char_atlas setAnchorPoint:CGPointMake(0, 0)];
        [self.white_char_atlas setPosition: CGPointMake(background.position.x, background.position.y) ];

        [self.white_char_atlas visit];
        [self addChild:white_char_atlas];
        
        // Add black score text
        _char_atlas  = [[CCLabelAtlas alloc]  initWithString:@"0" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'];
        self.black_char_atlas = _char_atlas;
        [_char_atlas release];
        
        [self.black_char_atlas setColor:ccc3(255, 255, 255)];
        [self.black_char_atlas setAnchorPoint: CGPointMake(1.0f, 0.0f)];
        [self.black_char_atlas setPosition: CGPointMake(background.position.x, background.position.y) ];
        [self.black_char_atlas visit];
        [self addChild:black_char_atlas];
        
    }
    return self;
}


-(void)setScores:(int)white black:(int)black {
    w = white;
    b = black;
    [self updateScoreboard];
}

-(void)setWhiteScore:(int)white {
    w = white;
    [self updateScoreboard];
}

-(void)setBlackScore:(int)black {
    b = black;
    [self updateScoreboard];
}

-(void)incrementWhiteScore:(int)with_value {
    w += with_value;
    [self updateScoreboard];
}

-(void)incrementBlackScore:(int)with_value {
    b += with_value;
    [self updateScoreboard];
}

-(void)incrementScores:(int)white_value black_value:(int)black_value {
    w += white_value;
    b += black_value;
    [self updateScoreboard];
}

-(void)updateScoreboard {
    NSString* str = [NSString stringWithFormat:@"%d", w];
    [[self white_char_atlas] setString:str];
    [[self white_char_atlas] visit];
    
    str = [NSString stringWithFormat:@"%d", b];
    [[self black_char_atlas] setString:str];
    [[self black_char_atlas] visit];
    
}
@end
