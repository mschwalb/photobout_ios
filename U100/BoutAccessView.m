//
//  BoutAccessView.m
//
//  Created by admin on 12/05/15.
//

#import "BoutAccessView.h"
#import "Util.h"

@implementation BoutAccessView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accessCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"accessCell"];
    NSString *title = nil;
    if (indexPath.row == 0)
        title = @"Public";
    else
        title = @"Private";
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.text = title;
    [cell setBackgroundColor:[UIColor clearColor]];
    [[cell textLabel] setTextColor:[UIColor whiteColor]];
    [self deHighlightCell:cell in:tableView];
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(cell.frame) - 1, CGRectGetWidth(cell.frame), 1)];
    separatorLineView.backgroundColor = [Util appOrangeColor];
    [cell.contentView addSubview:separatorLineView];
    return cell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self highlightCell:cell
                     in:tableView];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self deHighlightCell:[tableView cellForRowAtIndexPath:indexPath]
                       in:tableView];
}

-(void)highlightCell:(UITableViewCell *)cell
                  in:(UITableView *)table{
    [UIView animateWithDuration:0.3
                     animations:^{
                         UIImageView *checkImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sort_checked"]];
                         cell.accessoryView = checkImg;
                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                     } completion:^(BOOL finished) {
                         [_delegate accessSetTo:[[cell textLabel] text]];
                     }];
}

-(void)deHighlightCell:(UITableViewCell *)cell
                    in:(UITableView *)table{
    UIImageView *unCheckImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sort_unchecked"]];
    cell.accessoryView = unCheckImg;
}

@end
