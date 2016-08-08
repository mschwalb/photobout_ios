//
//  MainContainerViewContoller.h
//
//  Created by admin on 11/01/15.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"
#import "FullScreenFeedDelegate.h"
#import "GridFeedDelegate.h"
#import "HomeFeedFullScreen.h"
#import "HomeFeedGrid.h"
#import "MainTabController.h"

@interface FeedContainerViewContoller : MainTabController<FullScreenFeedDelegate, GridFeedDelegate>{
    @private
    HomeFeedFullScreen *fullScreenFeed;
    HomeFeedGrid *gridFeed;
    UIViewController *currentFeed;
    NSArray *viewsToHide;
}

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIButton *gridButton;
@property (nonatomic, strong) IBOutlet UIButton *menuButton;
@property (nonatomic, strong) IBOutlet UILabel *voteLabel;

-(IBAction)showGrid:(id)sender;
-(void)updateFeed:(NSString *)changedParam;

@end
