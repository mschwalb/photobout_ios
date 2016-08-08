//
//  HomeFeedFullScreen.m
//
//  Created by admin on 05/01/15.
//

#import "HomeFeedFullScreen.h"
#import "Util.h"
#import "BoutView.h"
#import "SmallFeedCell.h"
#import "ProfileViewController.h"
#import "BoutJSONFactory.h"
#import "AFHTTPClient.h"
#import "LeaderBoardView.h"
#import "CommentsView.h"

@interface HomeFeedFullScreen ()

@end

@implementation HomeFeedFullScreen

-(void)viewDidLoad{
    [super viewDidLoad];
    lv = nil;
    [self registerCollectionCell];
    [self populateProductScroller];
}

-(void)registerCollectionCell{
    UINib *nib = [UINib nibWithNibName:@"BoutView"
                                bundle:[NSBundle mainBundle]];
    [_productScroller registerNib:nib
       forCellWithReuseIdentifier:@"ProductCell"];
}

-(NSDictionary *)currBout{
    int tempPage = _productScroller.contentOffset.y / _productScroller.frame.size.height;
    return [feed objectAtIndex:tempPage];
}

#pragma mark Populate
-(void)populateProductScroller{
    [self reloadCollectionView];
    [self fetchFromServerWithStartingIdx:0];
}

-(void)reloadCollectionView{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < [feed count]; i++) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i
                                             inSection:0];
        [indexPaths addObject:ip];
    }
    feed = [[NSMutableArray alloc] init];
    [_productScroller deleteItemsAtIndexPaths:indexPaths];
    nextParam = nil;
    NSLog(@"Set next to null");
    //[_productScroller reloadData];
}

-(void)fetchFromServerWithStartingIdx:(int)startingIdx{
    if (!isLoading) {
        isLoading = true;
        NSLog(@"Start loading for %@", nextParam);
        NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        
        NSDictionary *params = @{};
        if (nextParam)
            params = @{@"next":nextParam};
        [httpClient getPath:@"/bouts/get"
                 parameters:params
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        isLoading = false;
                        [self removeLoadingView];
                        NSDictionary *resp = [NSJSONSerialization
                                            JSONObjectWithData:responseObject
                                                       options:NSJSONReadingMutableContainers
                                                         error:nil];
                         [feed addObjectsFromArray:[resp objectForKey:@"data"]];
                        NSObject *next = [resp objectForKey:@"next"];
                        NSLog(@"Finished loading for: %@ with future next: %@", nextParam, next);
                        if ([next isKindOfClass:[NSString class]])
                            nextParam = (NSString *) next;
                        else
                            nextParam = nil;
                         NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                         for (int i = startingIdx; i < [feed count]; i++) {
                             NSIndexPath *ip = [NSIndexPath indexPathForRow:i
                                                                  inSection:0];
                             [indexPaths addObject:ip];
                         }
                         if ([indexPaths count] > 0){
                             [_productScroller insertItemsAtIndexPaths:indexPaths];
                             [self scrollViewDidEndDecelerating:nil];
                         }
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        isLoading = false;
                        [self removeLoadingView];
                        NSLog(@"Error: %@", error);
                    }];
    }
}
#pragma mark -

-(void)removeLoadingView{
    [lv removeFromSuperview];
    lv = nil;
    [_delegate closeCommentsClicked];
}

#pragma mark ProductContainer
-(void)showCommentsClicked{
    [_delegate showCommentsClicked];
    [_logoBtn setHidden:true];
}

-(void)closeCommentsClicked{
    [_delegate closeCommentsClicked];
    [_logoBtn setHidden:false];
}

-(void)showMoreInfoClicked{
    [_delegate showMoreInfoClicked];
    [_logoBtn setHidden:true];
}

-(void)closeMoreInfoClicked{
    [_delegate closeMoreInfoClicked];
    [_logoBtn setHidden:false];
}

-(void)userProfileClicked:(NSObject *)uid{
    [self performSegueWithIdentifier:@"feedToProfile"
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
    if (idxToReplace < [feed count])
        [feed replaceObjectAtIndex:idxToReplace
                        withObject:boutDetails];
}

-(void)presentController:(UIViewController *)controller{
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}
#pragma mark -

-(void)showBrandDetails:(NSDictionary *)brand{
    [_delegate showMoreInfoClicked];
    [bdv populateWith:brand];
    [bdv setDelegate:self];
    [Util showView:bdv
            inside:self.view];    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"feedToProfile"]) {
        NSDictionary *deets = (NSDictionary *)sender;
        ProfileViewController *pvc = segue.destinationViewController;
        [pvc prepareForUserID:deets];
    }
}

-(void)enableScroller:(BOOL)isEnabled{
    [_productScroller setScrollEnabled:isEnabled];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

-(void)showLoadingView{
    if (lv)
        return;
    NSLog(@"Reloading for next: %@ and loading: %d", nextParam, isLoading);
    lv = [Util showLoadingViewOver:self.view
                              with:@"Refreshing"];
    [_delegate showCommentsClicked];
}

-(IBAction)scrollToTop:(id)sender{
    [UIView animateWithDuration:0.25
                     animations:^{
                         _productScroller.contentOffset = CGPointMake(0.0, 0.0);
                     }
                     completion:^(BOOL finished) {
                         [self scrollViewDidEndDecelerating:_productScroller];
                     }];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int tempPage = scrollView.contentOffset.y / scrollView.frame.size.height;
    if (scrollView.contentOffset.y < -15 && !isLoading){
        [self populateProductScroller];
        [self showLoadingView];
        return;
    }
    int totalPages = scrollView.contentSize.height / scrollView.frame.size.height;
    if (tempPage >= totalPages - 5 && !isLoading && nextParam)
        [self fetchFromServerWithStartingIdx:(int)[feed count]];
}
#pragma mark -

#pragma mark - UICollectionView Datasource
-(NSInteger)collectionView:(UICollectionView *)view
    numberOfItemsInSection:(NSInteger)section {
    return [Util getCountFor:feed
                          at:section
                        with:(int)[self numberOfSectionsInCollectionView:nil]];
}

-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BoutView *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductCell"
                                                        forIndexPath:indexPath];
    //[self addTapGestureFor:cell];
    int index = [Util getColIndexFor:feed
                                  at:indexPath
                                with:(int)[self numberOfSectionsInCollectionView:nil]];
    [cell layoutSubviews];
    [cell clearView];
    [cell setDetails:[feed objectAtIndex:index]];
    [cell setDelegate:self];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (BoutView *cell in [_productScroller visibleCells])
        [cell populate];
}
#pragma mark -

#pragma mark BrandDetailsContainer
-(void)showProductsFor:(NSString *)brandName{
    NSMutableDictionary *searchParams = [Util getSearchParams];
    [searchParams setObject:brandName
                     forKey:@"SelectedBrand"];
    [self populateProductScroller];
}

-(void)brandsScreenClosed{
    [_delegate closeMoreInfoClicked];
    bdv = nil;
}
#pragma mark -


@end