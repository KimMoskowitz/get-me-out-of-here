//
//  MKButtonViewController.m
//  GetMeOutOfHere
//
//  Created by Richard Kim on 2/1/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import "MKButtonViewController.h"
#import "MKHelpButton.h"

@interface MKButtonViewController ()

@end

@implementation MKButtonViewController
@synthesize helpButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CALayer *btnLayer = [helpButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:2.0f];
    //change button size and press down color
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)helpButtonAction:(id)sender {
    NSLog(@"button pressed");
}
@end
