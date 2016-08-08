//
//  NetworkView.h
//
//  Created by admin on 06/02/15.
//

#import <UIKit/UIKit.h>
#import "NetworkViewDelegate.h"

@interface NetworkView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>{
    NSArray *following;
    NSArray *followers;
    NSArray *currList;
    BOOL isInitDone;
}

@property (nonatomic, strong) IBOutlet UIButton *followersBtn;
@property (nonatomic, strong) IBOutlet UIButton *followingBtn;
@property (nonatomic, strong) IBOutlet UICollectionView *collection;
@property (nonatomic, assign) NSObject *userID;
@property (nonatomic, assign) id<NetworkViewDelegate> delegate;

-(void)populate;
-(IBAction)changeNetworkSection:(id)sender;

@end
