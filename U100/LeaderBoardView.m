//
//  LeaderBoardView.m
//
//  Created by admin on 02/04/15.
//

#import "LeaderBoardView.h"
#import "Util.h"
#import "AFHTTPClient.h"
#import "LeaderBoardCell.h"

@implementation LeaderBoardView

-(void)populate:(NSObject *)boutID{
    [Util addBlurViewFor:self
                   above:nil];
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"bout_id":boutID};
    [httpClient getPath:@"/bouts/leaderboard"
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSArray *resp = [NSJSONSerialization
                                           JSONObjectWithData: responseObject
                                           options: NSJSONReadingMutableContainers
                                           error:nil];
                     leaderBoard = [NSMutableArray arrayWithArray:resp];
                     [_delegate leaderBoardFinishedLoading];
                     [_table reloadData];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [Util showMessage:@"Error"
                             withTitle:[error localizedDescription]];
                 }];
}

-(IBAction)close:(id)sender{
    [self removeFromSuperview];
    [_delegate leaderBoardClosed];
}

-(NSArray *)getLeaderBoard{
    return leaderBoard;
}

#pragma mark UITableMethods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return [leaderBoard count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeaderBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leaderCell"];
    if (!cell) {
        cell = (LeaderBoardCell *) [Util loadViewWithNibName:@"LeaderBoardCell"
                                                     andType:[LeaderBoardCell class]];
        [cell setRestorationIdentifier:@"leaderCell"];
    }
    [cell populateWith:[leaderBoard objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark -

@end
