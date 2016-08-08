//
//  NetworkView.h
//
//  Created by admin on 06/02/15.
//

#import <UIKit/UIKit.h>
#import "WonViewDelegate.h"

@interface WonView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>{
    @private
    NSArray *bouts;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collection;
@property (nonatomic, assign) NSObject *userID;
@property (nonatomic, assign) id<WonViewDelegate> delegate;

-(void)populate;

@end
