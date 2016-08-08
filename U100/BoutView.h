//
//  ProductView.h
//
//  Created by admin on 06/01/15.
//

#import <UIKit/UIKit.h>
#import "ProductContainer.h"
#import "CommentsContainer.h"
#import "CommentsView.h"
#import "MoreInfoView.h"
#import "MoreInfoContainer.h"
#import "ProfilePicView.h"
#import "AddPhotoToBoutView.h"
#import "LeaderBoardContainer.h"
#import "LeaderBoardView.h"

@interface BoutView : UICollectionViewCell<UIScrollViewDelegate, CommentsContainer, MoreInfoContainer, CreateBoutDelegate, LeaderBoardContainer>{
    @private
    UIView *blurView;
    CGFloat yPos;
    CommentsView *cv;
    MoreInfoView *moreInfoView;
    NSMutableDictionary *boutDetails;
    NSArray *coverImages;
    LeaderBoardView *lbv;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) IBOutlet UILabel *timeLeft;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *user;
@property (nonatomic, strong) IBOutlet UILabel *vote;
@property (nonatomic, strong) IBOutlet UIButton *comment;
@property (nonatomic, strong) IBOutlet UIButton *leaderBoardButton;
@property (nonatomic, strong) IBOutlet UIButton *joinButton;
@property (nonatomic, strong) IBOutlet ProfilePicView *profilePic;
@property (nonatomic, strong) IBOutlet UIImageView *logo;
@property (nonatomic, strong) IBOutlet UIView *userContainer;
@property (nonatomic, weak) id<ProductContainer> delegate;

-(IBAction)showCommentsPressed:(id)sender;
-(IBAction)showMoreInfoPressed:(id)sender;
-(IBAction)showLeaderBoard:(id)sender;
-(IBAction)showAddPhoto:(id)sender;

-(void)clearView;
-(void)populate;
-(void)containerClosing;
-(void)setDetails:(NSDictionary *)boutDetails;

@end
