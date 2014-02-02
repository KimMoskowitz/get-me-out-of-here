//
//  MKCell.m
//  GetMeOutOfHere
//
//  Created by Richard Kim on 2/2/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import "MKCell.h"

@implementation MKCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
