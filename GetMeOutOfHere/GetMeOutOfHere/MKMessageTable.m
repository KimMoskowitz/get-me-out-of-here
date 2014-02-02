//
//  MKMessageTable.m
//  GetMeOutOfHere
//
//  Created by Richard Kim on 2/2/14.
//  Copyright (c) 2014 KimMoskowitz. All rights reserved.
//

#import "MKMessageTable.h"

@implementation MKMessageTable
@synthesize messageVC;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        messageVC = [[MKMessageViewController alloc]init];
    }
    return self;
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
    
    if(messageVC.messageArray.count == 0)
    {
        cell.textLabel.text = @"";
        return cell;
    }
    
    NSInteger currentRow = [indexPath row];
    
    cell.textLabel.text = @"test";//messageVC.messageArray[currentRow];
    
    return cell;

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
