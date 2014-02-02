//
//  MKMessageViewController.h
//  GetMeOutOfHere
//
//  Created by Richard Kim on 2/2/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import "MKDataViewController.h"
#import "MKMessageTable.h"

@class MKMessageTable;
@interface MKMessageViewController : MKDataViewController
@property (strong, nonatomic) MKMessageTable *messageTable;
@property (strong, nonatomic) NSArray *messageArray;
- (IBAction)temsTouchUp:(id)sender;
- (IBAction)temsTouchDown:(id)sender;
- (IBAction)temsDragOutside:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *temsButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

-(void)startAnimation;
-(void)stopAnimation;
-(void)handleLongPress;

@end
