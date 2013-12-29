//
//  LLBaseLayer.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-03-25.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "LLBaseLayer.h"

@implementation LLBaseLayer
- (void) onEnter {
    [super onEnter];
    [[CCDirector sharedDirector] setDelegate:self];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	CGSize size;
	if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			size = CGSizeMake(768, 1024);
		else
			size = CGSizeMake(320, 480 );
	} else if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			size = CGSizeMake(1024, 768);
		else
			size = CGSizeMake(480, 320 );
	}
    NSLog(@"LLBaseLayer --- willRotateToInterfaceOrientation: %f x %f",size.width, size.height);
    [self screenSizeChangedTo:size];
}
@end
