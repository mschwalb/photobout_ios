//
//  BoutDurationView.m
//
//  Created by admin on 14/04/15.
//

#import "BoutDurationView.h"
#import "Util.h"

@implementation BoutDurationView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"durationCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"durationCell"];
    NSString *title = [NSString stringWithFormat:@"%ld d", indexPath.row + 1];
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
                         NSString *duration = [[[cell textLabel] text] substringToIndex:2];
                         [_delegate durationSetTo:[duration stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                     }];
}

-(void)deHighlightCell:(UITableViewCell *)cell
                    in:(UITableView *)table{
    UIImageView *unCheckImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sort_unchecked"]];
    cell.accessoryView = unCheckImg;
}


@end
