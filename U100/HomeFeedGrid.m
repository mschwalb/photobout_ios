
//  FirstViewController.m
//
//  Created by Marko Bulaić on 21/08/14.
//
#import "HomeFeedGrid.h"
#import "AFHTTPRequestOperation.h"
#import "SmallFeedCell.h"
#import "Util.h"
#import "BoutView.h"
#import "AFHTTPClient.h"
#import "ProfileViewController.h"

@interface HomeFeedGrid ()
@end

@implementation HomeFeedGrid

-(void)viewDidLoad{
    [super viewDidLoad];
    isInitDone = false;
    UINib *nib = [UINib nibWithNibName:@"SmallFeedCell"
                                bundle:[NSBundle mainBundle]];
    [_feedView registerNib:nib
      forCellWithReuseIdentifier:@"FeedCell"];
    boutStatus = @"current";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!isInitDone || [boutStatus isEqualToString:@"current"]){
        [self populateHomeFeed];
        isInitDone = true;
    }
    [self updateDeetsVisibility];
}

-(IBAction)feedSegmentChanged:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    int selIndex = (int)[segment selectedSegmentIndex];
    if (selIndex == 0)
        boutStatus = @"current";
    else if (selIndex == 1)
        boutStatus = @"all";
    else if (selIndex == 2)
        boutStatus = @"past";
    [self updateDeetsVisibility];
    nextParams = nil;
    [self populateHomeFeed];
}

-(void)updateDeetsVisibility{
    if ([boutStatus isEqualToString:@"current"]){
        [_boutDeetsContainer setHidden:false];
        _containerHeight.constant = 31;
        [_boutTime setText:[_currFullScreenBout valueForKey:@"time_left"]];
        [_boutName setText:[_currFullScreenBout valueForKey:@"name"]];
    }
    else {
        [_boutDeetsContainer setHidden:true];
        _containerHeight.constant = 0.0;
    }
}

#pragma mark Populate
-(void)populateHomeFeed{
    [self emptyBoutsScroller];
    [self fetchFeedFromServerWith:0];
}
#pragma mark -
-(void)emptyBoutsScroller{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSLog(@"Clearing: %d items", (int) [feed count]);
    for (int i = 0; i < [feed count]; i++) {
        int row = (int) i / [self numberOfSectionsInCollectionView:_feedView];
        int sec = i % [self numberOfSectionsInCollectionView:_feedView];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:row
                                             inSection:sec];
        
        [indexPaths addObject:ip];
    }
    feed = [[NSMutableArray alloc] init];
    [_feedView deleteItemsAtIndexPaths:indexPaths];
}

-(void)fetchFeedFromServerWith:(int)startingIdx{
    if (!isLoading) {
        NSLog(@"HFG: Trying to load for %d, %@", startingIdx, nextParams);
        if ([boutStatus isEqualToString:@"current"]) {
            [feed addObjectsFromArray:[_currFullScreenBout objectForKey:@"photos"]];
            [self loadFeedIntoScroller:startingIdx];
            return;
        }
        if (!boutStatus)
            return;
        isLoading = true;
        [self allowStatusChange:false];
        NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

        NSDictionary *params = @{@"status":boutStatus};
        if (nextParams)
            params = @{@"status":boutStatus,
                       @"next":nextParams};
        [httpClient getPath:@"/bouts/get"
                 parameters:params
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        isLoading = false;
                        [self allowStatusChange:true];
                        NSDictionary *resp = [NSJSONSerialization
                                         JSONObjectWithData:responseObject
                                         options:NSJSONReadingMutableContainers
                                         error:nil];
                        if([[resp objectForKey:@"data"] count] <= 0 && [feed count] <= 0)
                            [Util showMessage:@"Sorry, home feed has no items"
                                    withTitle:@"Error"];
                        else{
                            [feed addObjectsFromArray:[resp objectForKey:@"data"]];
                            [self loadFeedIntoScroller:startingIdx];
                            NSObject *next = [resp objectForKey:@"next"];
                            if ([next isKindOfClass:[NSString class]])
                                nextParams = (NSString *) next;
                            else
                                nextParams = nil;
                        }
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        isLoading = false;
                        [self allowStatusChange:true];
                        if ([feed count] == 0)
                            [Util showMessage:[error localizedDescription]
                                    withTitle:@"Error"];
                    }];
    }
}

-(void)allowStatusChange:(BOOL)isEnabled{
    [_statusSegments setEnabled:isEnabled];
    [_statusSegments setUserInteractionEnabled:isEnabled];
}

-(void)loadFeedIntoScroller:(int)startingIdx{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = startingIdx; i < [feed count]; i++) {
        NSIndexPath *ip = [Util getIndexPathForIdx:i
                                        andNumCols:(int)[self numberOfSectionsInCollectionView:nil]];
        [indexPaths addObject:ip];
    }
    if ([indexPaths count] > 0){
        [_feedView insertItemsAtIndexPaths:indexPaths];
        if ([boutStatus isEqualToString:@"current"]){
            [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(collectionViewDoneLoading)
                                           userInfo:nil
                                            repeats:NO];
        }
        else
            [self scrollViewDidScroll:nil];
    }
}

-(void)collectionViewDoneLoading{
    [self scrollViewDidScroll:nil];
}

-(float)getWidthFor:(NSString *)catName{
    UILabel *childCatLbl = [[UILabel alloc] init];
    [childCatLbl setText:catName];
    [childCatLbl sizeToFit];
    return CGRectGetWidth(childCatLbl.frame) + 20;
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view
     numberOfItemsInSection:(NSInteger)section {
    return [Util getCountFor:feed
                          at:section
                        with:(int)[self numberOfSectionsInCollectionView:nil]];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SmallFeedCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FeedCell"
                                                        forIndexPath:indexPath];
    [self addTapGestureFor:cell];
    int index = [Util getColIndexFor:feed
                                  at:indexPath
                                with:(int)[self numberOfSectionsInCollectionView:nil]];
    [cell clearView];
    if ([boutStatus isEqualToString:@"current"])
        cell.isBout = false;
    else
        cell.isBout = true;
    [cell setDetails:[feed objectAtIndex:index]];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView && nextParams) {
        int tempPage = scrollView.contentOffset.y / scrollView.frame.size.height;
        int totalPages = scrollView.contentSize.height / scrollView.frame.size.height;
        if (tempPage >= totalPages - 1 && !isLoading) {
            [self fetchFeedFromServerWith:(int)[feed count]];
        }
    }
    for (SmallFeedCell *cell in [_feedView visibleCells])
        [cell populate];
}
#pragma mark -

-(void)addTapGestureFor:(SmallFeedCell *)cell{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(showFullProductView:)];
    [cell addGestureRecognizer:tap];
}

-(void)showFullProductView:(UITapGestureRecognizer *)tap{
    if (![boutStatus isEqualToString:@"current"]) {
        SmallFeedCell *cell = (SmallFeedCell *)[tap view];
        SingleProductView *pv = (SingleProductView *) [Util loadViewWithNibName:@"SingleProductView"
                                                                        andType:[SingleProductView class]];
        [_delegate showSingleProductView:pv];
        [pv layoutSubviews];
        [pv setDelegate:self];
        [pv populateWith:[cell getProductDetails]];
    }
}

#pragma mark SingleProductViewDelegate
-(void)singleProductViewClosed{
    
}

-(void)presentController:(UIViewController *)controller{
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

-(void)userProfileClicked:(NSObject *)uid{
    [self performSegueWithIdentifier:@"gridToProfile"
                              sender:uid];
}

-(void)updateBoutWith:(NSDictionary *)boutDetails
                  for:(NSObject *)boutID{
    int idxToReplace = 0;
    for (NSMutableDictionary *bout in feed) {
        if ([[bout objectForKey:@"id"] isEqual:boutID])
            break;
        idxToReplace += 1;
    }
    if (idxToReplace < [feed count]){
        [feed replaceObjectAtIndex:idxToReplace
                        withObject:boutDetails];
        [_feedView reloadData];
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(collectionViewDoneLoading)
                                       userInfo:nil
                                        repeats:NO];
    }
}
#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"gridToProfile"]) {
        NSDictionary *deets = (NSDictionary *)sender;
        ProfileViewController *pvc = segue.destinationViewController;
        [pvc prepareForUserID:deets];
    }
}
@end
