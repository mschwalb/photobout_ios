//
//  NetworkView.m
//
//  Created by admin on 06/02/15.
//

#import "NetworkView.h"
#import "Util.h"
#import "NetworkCell.h"
#import "AFHTTPClient.h"

@implementation NetworkView

-(void)populate{
    [self registerNIB];
    [self pullData];
}

-(void)registerNIB{
    UINib *nib = [UINib nibWithNibName:@"NetworkCell"
                                bundle:[NSBundle mainBundle]];
    [_collection registerNib:nib
  forCellWithReuseIdentifier:@"NetworkCell"];
}

-(void)pullData{
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"user_id":_userID};
    [httpClient getPath:@"/users/following/get"
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *resp = [NSJSONSerialization
                                          JSONObjectWithData:responseObject
                                          options:NSJSONReadingMutableContainers
                                          error:nil];
                    following = [resp valueForKey:@"data"];
                    long numFollowing = [following count];
                    NSString *title = [NSString stringWithFormat:@"%ld FOLLOWING", numFollowing];
                    [_followingBtn setTitle:title forState:UIControlStateNormal];
                    if (!isInitDone) {
                        [self changeNetworkSection:_followingBtn];
                        isInitDone = true;
                    }
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [Util showMessage:[error localizedDescription]
                            withTitle:@"Error"];
                }];
    [httpClient getPath:@"/users/followers/get"
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *resp = [NSJSONSerialization
                                          JSONObjectWithData:responseObject
                                          options:NSJSONReadingMutableContainers
                                          error:nil];
                    followers = [resp valueForKey:@"data"];
                    long numFollowers = [followers count];
                    NSString *title = [NSString stringWithFormat:@"%ld FOLLOWERS", numFollowers];
                    [_followersBtn setTitle:title forState:UIControlStateNormal];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [Util showMessage:[error localizedDescription]
                            withTitle:@"Error"];
                }];
}

-(IBAction)changeNetworkSection:(id)sender{
    if (sender == _followersBtn){
        currList = followers;
        [self highlight:_followersBtn];
    }
    else{
        currList = following;
        [self highlight:_followingBtn];
    }
    [_collection reloadData];
}

-(void)highlight:(UIButton *)btn{
    NSArray *btns = @[_followingBtn, _followersBtn];
    for (UIButton *currBtn in btns) {
        if (currBtn == btn)
            [currBtn setAlpha:1.0];
        else
            [currBtn setAlpha:0.5];
    }
}


#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view
     numberOfItemsInSection:(NSInteger)section {
    return [Util getCountFor:currList
                          at:section
                        with:(int)[self numberOfSectionsInCollectionView:nil]];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NetworkCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"NetworkCell"
                                                      forIndexPath:indexPath];
    int index = [Util getColIndexFor:currList
                                  at:indexPath
                                with:(int)[self numberOfSectionsInCollectionView:nil]];
    [cell populateWith:[currList objectAtIndex:index]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int index = [Util getColIndexFor:currList
                                  at:indexPath
                                with:(int)[self numberOfSectionsInCollectionView:nil]];
    NSDictionary *selUser = [currList objectAtIndex:index];
    NSString *fbID = @"";
    if ([selUser valueForKey:@"facebook_id"])
        fbID = [selUser valueForKey:@"facebook_id"];
    NSDictionary *deets = @{@"user_id":[selUser valueForKey:@"id"],
                            @"user_name":[selUser valueForKey:@"name"],
                            @"user_profile_pic":[selUser valueForKey:@"profile_picture"],
                            @"user_fb_id":fbID};
    
    [_delegate userSelected:deets];
}
#pragma mark -

@end
