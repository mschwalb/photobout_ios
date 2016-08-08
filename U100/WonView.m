//
//  NetworkView.m
//
//  Created by admin on 06/02/15.
//

#import "WonView.h"
#import "Util.h"
#import "SmallFeedCell.h"
#import "AFHTTPClient.h"

@implementation WonView

-(void)populate{
    [self registerNIB];
    [self pullData];
}

-(void)registerNIB{
    UINib *nib = [UINib nibWithNibName:@"SmallFeedCell"
                                bundle:[NSBundle mainBundle]];
    [_collection registerNib:nib
  forCellWithReuseIdentifier:@"SmallFeedCell"];
}

-(void)pullData{
    NSLog(@"Pulling wins for: %@", _userID);
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"user_id":_userID};
    [httpClient getPath:@"/users/wins"
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    bouts = [NSJSONSerialization
                             JSONObjectWithData:responseObject
                             options:NSJSONReadingMutableContainers
                             error:nil];
                    [_delegate wonDataLoaded:(int)[bouts count]];
                    [_collection reloadData];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [Util showMessage:[error localizedDescription]
                            withTitle:@"Error"];
                }];
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
    SmallFeedCell *cell = (SmallFeedCell *) [self collectionView:collectionView
                                          cellForItemAtIndexPath:indexPath];
    [_delegate showInFullScreen:[cell getProductDetails]];
}
#pragma mark -

@end
