//
//  TagFollowersView.m
//
//  Created by admin on 24/02/15.
//

#import "TagFollowersView.h"
#import "Util.h"
#import "TagFollowerCell.h"

@implementation TagFollowersView

-(void)populateFollowers{
    [Util addBlurViewFor:self
                   above:nil];
    followers = [[NSMutableArray alloc] init];
}

-(IBAction)closePressed:(id)sender{
    [self removeFromSuperview];
}

#pragma mark UITableMethods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Here...");
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate followerSelected:[followers objectAtIndex:indexPath.row]];
    [self removeFromSuperview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return [followers count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TagFollowerCell *cell = (TagFollowerCell *)[tableView dequeueReusableCellWithIdentifier:@"FollowerCell"];
    if (!cell)
        cell = (TagFollowerCell *) [Util loadViewWithNibName:@"TagFollowerCell"
                                                     andType:[TagFollowerCell class]];
    [cell populateWith:[followers objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark -

@end
