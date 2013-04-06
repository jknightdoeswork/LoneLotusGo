//
//  LLSignupViewController.m
//  LoneLotusGo
//
//  Created by Jason Knight on 13-04-06.
//  Copyright (c) 2013 VendAsta Technologies Inc. . All rights reserved.
//

#import "LLSignupViewController.h"

@interface LLSignupViewController ()

@end

@implementation LLSignupViewController

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
        CGRect frame = self.signUpView.logo.frame;
        frame.size.height = 100;
        self.signUpView.logo.frame = frame;
    }
    else {
        CGRect frame = self.signUpView.logo.frame;
        frame.size.height = 50;
        self.signUpView.logo.frame = frame;
    }
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.signUpView setBackgroundColor:[UIColor blackColor]];
    UIImageView* image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]autorelease];
    //change width of frame
    image.contentMode = UIViewContentModeScaleAspectFit;

    
    [self.signUpView setLogo:image];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsPortrait(orientation) ) {
        CGRect frame = self.signUpView.logo.frame;
        frame.size.height = 100;
        self.signUpView.logo.frame = frame;
    }
    else {
        CGRect frame = self.signUpView.logo.frame;
        frame.size.height = 50;
        self.signUpView.logo.frame = frame;
    }
    
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:15.0f/255.0f green:222.0f/255.0f blue:210.0/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:15.0f/255.0f green:222.0f/255.0f blue:210.0/255.0f alpha:1.0]];
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:15.0f/255.0f green:222.0f/255.0f blue:210.0/255.0f alpha:1.0]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
