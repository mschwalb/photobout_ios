//
//  FavoritesView.m
//
//  Created by admin on 06/02/15.
//

#import "BoutsView.h"
#import "Util.h"
#import "SmallFeedCell.h"
#import "ListsCell.h"
#import "SingleProductView.h"
#import "AFHTTPClient.h"

@implementation BoutsView

-(void)populate{
    UINib *nib = [UINib nibWithNibName:@"SmallFeedCell"
                                bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nib
      forCellWithReuseIdentifier:@"SmallFeedCell"];
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"user_id":_userID};
    [httpClient getPath:@"/users/bouts"
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    bouts = [NSJSONSerialization
                                 JSONObjectWithData:responseObject
                                 options:NSJSONReadingMutableContainers
                                 error:nil];
                    [_delegate boutsDataLoaded:(int)[bouts count]];
                    [_collectionView reloadData];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [Util showMessage:[error localizedDescription]
                            withTitle:@"Error"];
                }];
}

-(void)reloadLists{
    bouts = nil;
    [_collectionView reloadData];
    [self populate];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view
     numberOfItemsInSection:(NSInteger)section {
    return [Util getCountFor:bouts
                          at:section
                        with:(int)[self numberOfSectionsInCollectionView:nil]];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    int index = [Util getColIndexFor:bouts
                                  at:indexPath
                                with:(int)[self numberOfSectionsInCollectionView:nil]];
    SmallFeedCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SmallFeedCell"
                                                        forIndexPath:indexPath];
    cell.isBout = true;
    [cell setDetails:[bouts objectAtIndex:index]];
    [cell setUserID:_userID];
    [cell populate];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SmallFeedCell *cell = (SmallFeedCell *) [self collectionView:_collectionView
                                          cellForItemAtIndexPath:indexPath];
    [_delegate showInFullScreen:[cell getProductDetails]];
}
#pragma mark -
@end
