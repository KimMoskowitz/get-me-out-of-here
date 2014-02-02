//
//  MKHelpButton.m
//  GetMeOutOfHere
//
//  Created by Richard Kim on 2/1/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import "MKHelpButton.h"

@implementation MKHelpButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if(self.highlighted) {
        [self setAlpha:0.7];
    }
    else {
        [self setAlpha:1.0];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
