//
//  MKMessageViewController.m
//  GetMeOutOfHere
//
//  Created by Richard Kim on 2/2/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import "MKMessageViewController.h"

@interface MKMessageViewController ()

@end

@implementation MKMessageViewController
@synthesize messageTable;
@synthesize messageArray;
@synthesize temsButton;
@synthesize backgroundView;

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
    messageTable = [[MKMessageTable alloc]init];
    
    messageArray = @[@"Please get me out of here",@"Come meet me here",@"I might need some help here"];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 2; //seconds
    longPress.delegate = self;
    [temsButton addGestureRecognizer:longPress];
    
    CALayer *btnLayer = [temsButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    CALayer *Layer = [backgroundView layer];
    [Layer setMasksToBounds:YES];
    [Layer setCornerRadius:5.0f];
    backgroundView.hidden = YES;
    
    [temsButton setAlpha:0.4];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Make sure to change the default style to the next one if you want to manage to display text
        // in the detailsTextLabel area.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(messageArray.count == 0)
    {
        cell.textLabel.text = @"";
        return cell;
    }
    
    NSInteger currentRow = [indexPath row];
    
    cell.textLabel.text = messageArray[currentRow];
    
    if (currentRow == 0) {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (int i = 0; i<messageArray.count;i++)
    {
        cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}


-(void) handleLongPress : (id)sender
{
    [self stopAnimation];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:2672286051"]];
}
- (IBAction)temsTouchUp:(id)sender {
    NSLog(@"touch up worked");
    [self stopAnimation];
}

- (IBAction)temsTouchDown:(id)sender {
    [self startAnimation];
}

- (IBAction)temsDragOutside:(id)sender {
    [self stopAnimation];
}

-(void)startAnimation
{
    backgroundView.hidden = NO;
    [UIView beginAnimations:@"animationOff" context:NULL];
    [UIView setAnimationDuration:2.0f];
    [backgroundView setFrame:CGRectMake(46, 48, 229, 66)];
    [UIView commitAnimations];
}
-(void)stopAnimation
{
    backgroundView.hidden = YES;
    [UIView beginAnimations:@"animationOff" context:NULL];
    [UIView setAnimationDuration:0.0f];
    [backgroundView setFrame:CGRectMake(46, 48, 1, 66)];
    [UIView commitAnimations];
}
@end
