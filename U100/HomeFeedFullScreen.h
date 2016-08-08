//
//  HomeFeedFullScreen.h
//
//  Created by admin on 05/01/15.
//

#import <UIKit/UIKit.h>
#import "ProductContainer.h"
#import "FullScreenFeedDelegate.h"
#import "BrandDetailsContainer.h"
#import "BrandDetailsView.h"
#import "LoadingView.h"

@interface HomeFeedFullScreen : UIViewController<ProductContainer, UICollectionViewDataSource, UICollectionViewDelegate, BrandDetailsContainer>{
    @private
    NSMutableArray *feed;
    BOOL isLoading;
    BrandDetailsView *bdv;
    NSString *nextParam;
    LoadingView *lv;
}

@property (nonatomic, strong) IBOutlet UICollectionView *productScroller;
@property (nonatomic, strong) IBOutlet UIButton *logoBtn;
@property (nonatomic, strong) id<FullScreenFeedDelegate> delegate;

-(IBAction)scrollToTop:(id)sender;
-(void)enableScroller:(BOOL)isEnabled;
-(void)populateProductScroller;
-(NSDictionary *)currBout;

@end
