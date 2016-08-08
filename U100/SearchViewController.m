//
//  SearchViewController.m
//
//  Created by admin on 19/02/15.
//

#import "SearchViewController.h"
#import "BoutResultsCell.h"
#import "UserResultsCell.h"
#import "Util.h"
#import "SingleProductView.h"
#import "ProfileViewController.h"
#import "AFHTTPClient.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIColor *color = [UIColor whiteColor];
    _searchStr.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_searchStr.placeholder attributes:@{NSForegroundColorAttributeName: color}];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    searchResults = nil;
    [_searchStr setText:@""];
    [_searchOptions setSelectedSegmentIndex:0];
    [_resultsTable reloadData];
    [_searchStr becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *searchStr = [_searchStr text];
    if ([_searchOptions selectedSegmentIndex] == 1)
        [self searchForUser:searchStr];
    else
        [self searchForProduct:searchStr];
    [textField resignFirstResponder];
    return NO;
}

-(IBAction)searchForUser:(NSString *)str{
    searchResults = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"search_string":str};
    [httpClient postPath:@"/users/search"
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *resp = [NSJSONSerialization
                                     JSONObjectWithData: responseObject
                                     options: NSJSONReadingMutableContainers
                                     error: nil];
                    NSArray *users = [resp objectForKey:@"users"];
                    if (users && [users count] > 0)
                        [searchResults addObjectsFromArray:users];
                    else
                        [Util showMessage:@"No users matched your query"
                                withTitle:@"Sorry"];
                    [_resultsTable reloadData];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
}

-(IBAction)searchForProduct:(NSString *)str{
    searchResults = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"name":str};
    [httpClient getPath:@"/bouts/search"
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSArray *bouts = [NSJSONSerialization
                                           JSONObjectWithData: responseObject
                                           options: NSJSONReadingMutableContainers
                                           error: nil];
                     if (bouts && [bouts count] > 0)
                         [searchResults addObjectsFromArray:bouts];
                     else
                         [Util showMessage:@"No bouts matched your query"
                                 withTitle:@"Sorry"];
                     [_resultsTable reloadData];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
}

-(void)showMenu:(id)sender{
    [_searchStr resignFirstResponder];
    [super showMenu:sender];
}

#pragma mark TableDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return [searchResults count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_searchOptions selectedSegmentIndex] == 0) {
        BoutResultsCell *cell = (BoutResultsCell *)[Util loadViewWithNibName:@"BoutResultsCell"
                                                                andType:[BoutResultsCell class]];
        [cell populate:[searchResults objectAtIndex:indexPath.row]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    UserResultsCell *cell = (UserResultsCell *)[Util loadViewWithNibName:@"UserResultsCell"
                                                                 andType:[UserResultsCell class]];
    [cell populate:[searchResults objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_searchOptions selectedSegmentIndex] == 0) {
        SingleProductView *pv = (SingleProductView *) [Util loadViewWithNibName:@"SingleProductView"
                                                                        andType:[SingleProductView class]];
        [Util showView:pv
                inside:self.view];
        [self.view layoutSubviews];
        [pv populateWith:[searchResults objectAtIndex:indexPath.row]];
    }
    else{
        selUser = [searchResults objectAtIndex:indexPath.row];
        NSString *fbID = @"";
        if ([selUser valueForKey:@"facebook_id"])
            fbID = [selUser valueForKey:@"facebook_id"];
        NSDictionary *deets = @{@"user_id":[selUser valueForKey:@"id"],
                                @"user_name":[selUser valueForKey:@"name"],
                                @"user_profile_pic":[selUser valueForKey:@"profile_picture"],
                                @"user_fb_id":fbID};
        [self performSegueWithIdentifier:@"searchToProfile"
                                  sender:deets];
    }
}
#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender{
    if ([segue.identifier isEqualToString:@"searchToProfile"]) {
        ProfileViewController *pvc = segue.destinationViewController;
        [pvc prepareForUserID:sender];
    }
}
@end
