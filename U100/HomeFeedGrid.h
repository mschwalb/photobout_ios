//
//  FirstViewController.h
//
//  Created by Marko Bulaić on 21/08/14.
//

#import <UIKit/UIKit.h>
#import "GridFeedDelegate.h"
#import "SingleProductViewDelegate.h"

@interface HomeFeedGrid : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDelegate, SingleProductViewDelegate>{
    @private
    NSMutableArray *feed;
    NSMutableDictionary *frames;
    NSMutableArray *childCategories;
    NSMutableDictionary *catNameToID;
    BOOL isLoading;
    BOOL isInitDone;
    NSString *boutStatus;
    NSString *nextParams;
}

@property (nonatomic, weak) IBOutlet UICollectionView *feedView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *statusSegments;
@property (nonatomic, weak) IBOutlet UIView *boutDeetsContainer;
@property (nonatomic, weak) IBOutlet UILabel *boutName;
@property (nonatomic, weak) IBOutlet UILabel *boutTime;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerHeight;
@property (nonatomic, weak) NSDictionary *currFullScreenBout;
@property (nonatomic, assign) BOOL hasCategoryChanged;
@property (nonatomic, assign) id<GridFeedDelegate> delegate;

-(IBAction)feedSegmentChanged:(id)sender;
-(void)populateHomeFeed;

@end
