//
//  FavoritesView.h
//
//  Created by admin on 06/02/15.
//

#import <UIKit/UIKit.h>
#import "BoutsViewDelegate.h"

@interface BoutsView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>{
    @private
    NSArray *bouts;
    BOOL isInitDone;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) id<BoutsViewDelegate> delegate;
@property (nonatomic, assign) NSObject *userID;

-(void)populate;
-(void)reloadLists;

@end
