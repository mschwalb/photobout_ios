//
//  InviteFriendsView.m
//
//  Created by admin on 20/04/15.
//

#import "InviteFriendsView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FriendCell.h"
#import "Util.h"
#import "AFHTTPClient.h"
#import "UIImageView+AFNetworking.h"

@implementation InviteFriendsView

-(void)populate{
    [_delegate viewFinishedLoading];
    selectedCells = [[NSMutableDictionary alloc] init];
    [self pullData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [_profilePic populateProfilePicForLoggedInUser];
    [_name setText:[defaults valueForKey:@"firstname"]];
    [self addGestureForContainer];
}

-(void)addGestureForContainer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAllFriends:)];
    [_container addGestureRecognizer:tap];
}

-(void)selectAllFriends:(UITapGestureRecognizer *)tap{
    if (!areAllSelected) {
        areAllSelected = true;
        [_friendsTable setUserInteractionEnabled:false];
        [_friendsTable setAlpha:0.5];
        [_selectAllImg setImage:[UIImage imageNamed:@"sort_checked"]];
        [self populateCount:(int)[friends count]];
    }
    else{
        areAllSelected = false;
        [_friendsTable setUserInteractionEnabled:true];
        [_friendsTable setAlpha:1.0];
        [_selectAllImg setImage:[UIImage imageNamed:@"sort_unchecked"]];
        [self populateCount:(int)[selectedCells count]];
    }
}

-(void)pullData{
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"user_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_email"]};
    [httpClient getPath:@"/users/following/get"
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *resp = [NSJSONSerialization
                                          JSONObjectWithData:responseObject
                                          options:NSJSONReadingMutableContainers
                                          error:nil];
                    friends = [resp valueForKey:@"data"];
                    [self populateCount:(int)[selectedCells count]];
                    [_friendsTable reloadData];
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [Util showMessage:[error localizedDescription]
                            withTitle:@"Error"];
                }];
}

-(void)populateCount:(int)count{
    NSString *text = [NSString stringWithFormat:@"%d FRIENDS", count];
    if (count == 1)
        text = [NSString stringWithFormat:@"%d FRIEND", count];
    [_numFriends setText:text];
}

-(IBAction)nextPressed:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [btn setEnabled:false];
    NSArray *invitees = [self getSelectedFriends];
    if (!invitees)
        invitees = @[];
    NSMutableString *inviteesParam = [[NSMutableString alloc] init];
    for (NSString *invitee in invitees)
        [inviteesParam appendFormat:@"%@;", invitee];

    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = @{@"bout_id" : [_delegate getBoutID],
                             @"ids" : inviteesParam};
    NSLog(@"%@", params);
    [httpClient postPath:@"/bouts/invites/add"
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [btn setEnabled:true];
                    NSDictionary *resp = [NSJSONSerialization
                                          JSONObjectWithData: responseObject
                                          options: NSJSONReadingMutableContainers
                                          error: nil];
                    NSLog(@"%@", resp);
                    [_delegate moveToNextView:nil];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [btn setEnabled:true];
                    [Util showMessage:@"Could not invite friends"
                            withTitle:@"Sorry"];
                    [_delegate moveToNextView:nil];
                }];
}

-(NSArray *)getSelectedFriends{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    if (!areAllSelected) {
        for (NSIndexPath *ip in selectedCells) {
            NSDictionary *deets = [selectedCells objectForKey:ip];
            [retVal addObject:[deets valueForKey:@"id"]];
        }
    }
    else{
        for (NSDictionary *friend in friends){
            NSLog(@"Adding: %@", [friend valueForKey:@"id"]);
            [retVal addObject:[friend valueForKey:@"id"]];
        }
    }
    return retVal;
}

#pragma mark UITableMethods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return [friends count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendCell *cell = (FriendCell *) [Util loadViewWithNibName:@"FriendCell"
                                                        andType:[FriendCell class]];
    [cell populate:[friends objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([selectedCells objectForKey:indexPath])
        [cell.checkImg setImage:[UIImage imageNamed:@"sort_checked"]];
    else
        [cell.checkImg setImage:[UIImage imageNamed:@"sort_unchecked"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *deets = [selectedCells objectForKey:indexPath];
    FriendCell *cell = (FriendCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *imgName = nil;
    if (deets) {
        [selectedCells removeObjectForKey:indexPath];
        imgName = @"sort_unchecked";
    }
    else{
        [selectedCells setObject:[cell getUserDetails]
                          forKey:indexPath];
        imgName = @"sort_checked";
    }
    [self populateCount:(int)[selectedCells count]];
    [cell.checkImg setImage:[UIImage imageNamed:imgName]];
}
#pragma mark -

@end
