//
//  ActivityViewController.m
//
//  Created by admin on 05/02/15.
//

#import "ActivityViewController.h"
#import "ActivityCell.h"
#import "Util.h"
#import "ProfileViewController.h"
#import "ActivityFeed.h"
#import "AFHTTPClient.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadActivity];
}

-(void)reloadActivity{
    [self emptyActivity];
    [self loadActivity];
}

-(void)loadActivity{
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = @{};
    if (next)
        params = @{@"next":next};
    NSLog(@"Calling with: %@", params);
    [httpClient getPath:@"/users/notifications/get"
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSDictionary *resp = [NSJSONSerialization
                                      JSONObjectWithData: responseObject
                                      options: NSJSONReadingMutableContainers
                                      error: nil];
                     NSArray *notifs = [resp objectForKey:@"data"];
                     if (notifs && [notifs count] > 0)
                         [notifications addObjectsFromArray:notifs];
                     NSObject *nextCursor = [resp objectForKey:@"next"];
                     if ([nextCursor isKindOfClass:[NSString class]])
                         next = (NSString *) nextCursor;
                     else
                         next = nil;
                     [_activityTable reloadData];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [Util showMessage:[error localizedDescription]
                             withTitle:@"Error"];
                 }];
}

-(void)emptyActivity{
    notifications = [[NSMutableArray alloc] init];
    next = nil;
    [_activityTable reloadData];
}

#pragma mark TableViewMethods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return [notifications count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *currActivity = [notifications objectAtIndex:indexPath.row];
    ActivityCell *cell = (ActivityCell *) [Util loadViewWithNibName:@"ActivityCell"
                                                            andType:[ActivityCell class]];
    [cell populateWith:[self getMessageFor:currActivity]
                   and:[currActivity valueForKey:@"timestamp"]
                   and:[currActivity valueForKey:@"profile_picture"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *currActivity = [notifications objectAtIndex:indexPath.row];
    [self showFullBoutView:[currActivity objectForKey:@"bout"]];
}
#pragma mark -
-(NSAttributedString *)getMessageFor:(NSDictionary *)activity{
    NSArray *highlights = @[[activity valueForKey:@"from_name"]];
    NSString *message = [NSString stringWithFormat:@"%@ %@", [highlights objectAtIndex:0], [activity valueForKey:@"message"]];
    return [self highlight:highlights
                        in:message];
}

-(void)showFullBoutView:(NSObject *)boutID{
    SingleProductView *pv = (SingleProductView *) [Util loadViewWithNibName:@"SingleProductView"
                                                                    andType:[SingleProductView class]];
    [Util showView:pv
            inside:self.view];
    [pv layoutSubviews];
    [pv setDelegate:self];
    [pv populateWithID:boutID];
}

-(NSAttributedString *)highlight:(NSArray *)highlights
                              in:(NSString *)message{
    NSMutableAttributedString *retVal = [[NSMutableAttributedString alloc] initWithString:message];
    for (NSString *highlight in highlights) {
        NSRange range = [message rangeOfString:highlight];
        [retVal addAttribute:NSForegroundColorAttributeName
                       value:[Util appOrangeColor]
                       range:range];
    }
    return retVal;
}

-(IBAction)refresh:(id)sender{
    [self reloadActivity];
}

-(IBAction)clearActivities:(id)sender{
    NSArray *names = @[@"follow_api.clearnewfollowers",
                       @"like_api.clearnewlikes",
                       @"multilist_api.clearaddedtolist",
                       @"product_comments.clearnewtags"];
    for (NSString *name in names)
        [self clearActivity:name];
    [self emptyActivity];
}

-(void)clearActivity:(NSString *)name{
    
}

#pragma UIScrollView Method::
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int tempPage = scrollView.contentOffset.y / scrollView.frame.size.height;
    int totalPages = scrollView.contentSize.height / scrollView.frame.size.height;
    if (tempPage >= totalPages - 1 && next)
        [self loadActivity];
}
#pragma mark -

#pragma mark SingleProductViewDelegate
-(void)singleProductViewClosed{
    
}

-(void)presentController:(UIViewController *)controller{
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

-(void)userProfileClicked:(NSObject *)uid{
    [self performSegueWithIdentifier:@"activityToProfile"
                              sender:uid];
}

-(void)updateBoutWith:(NSDictionary *)boutDetails for:(NSObject *)boutID{
    
}
#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"activityToProfile"]) {
        NSDictionary *deets = (NSDictionary *)sender;
        ProfileViewController *pvc = segue.destinationViewController;
        [pvc prepareForUserID:deets];
    }
}
@end
