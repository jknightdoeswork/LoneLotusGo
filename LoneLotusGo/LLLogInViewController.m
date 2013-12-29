//
//  LLLogInViewController.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-04-06.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "LLLogInViewController.h"

@interface LLLogInViewController ()

@end

@implementation LLLogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ) {
        CGRect frame = self.logInView.logo.frame;
        frame.size.height = 100;
        self.logInView.logo.frame = frame;
    }
    else {
        CGRect frame = self.logInView.logo.frame;
        frame.size.height = 50;
        self.logInView.logo.frame = frame;
    }
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.logInView setBackgroundColor:[UIColor blackColor]];
    UIImageView* image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]autorelease];
    //change width of frame
    image.contentMode = UIViewContentModeScaleAspectFit;
    [self.logInView setLogo:image];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsPortrait(orientation) ) {
        CGRect frame = self.logInView.logo.frame;
        frame.size.height = 100;
        self.logInView.logo.frame = frame;
    }
    else {
        CGRect frame = self.logInView.logo.frame;
        frame.size.height = 50;
        self.logInView.logo.frame = frame;
    }
    
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:15.0f/255.0f green:222.0f/255.0f blue:210.0/255.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:15.0f/255.0f green:222.0f/255.0f blue:210.0/255.0f alpha:1.0]];

//     [self.logInView.logo setFrame:CGRectMake(66.5, 70, 187, 58.5)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
