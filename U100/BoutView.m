//
//  ProductView.m
//
//  Created by admin on 06/01/15.
//

#import "BoutView.h"
#import "Util.h"
#import "CommentsView.h"
#import "AFNetworking/AFImageRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "BoutJSONFactory.h"
#import "AFHTTPClient.h"
#import "AddPhotoToBoutView.h"
#import "LeaderBoardView.h"

@implementation BoutView
-(void)setDetails:(NSDictionary *)_boutDetails{
    boutDetails = (NSMutableDictionary *) _boutDetails;
}

-(void)populate{
    [self loadCoverImages];
    [self setUpPageControl];
    [self loadDetails];
    [self scrollViewDidEndDecelerating:_scroller];
    [self addGestureRecognizerForLogo];
    [self prepareLeaderBoardView];
    [self addGestureRecognizerForUserProfile];
}

-(void)addGestureRecognizerForUserProfile{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(showUserProfile:)];
    [_userContainer addGestureRecognizer:gesture];
}

-(void)addGestureRecognizerForLogo{
    int boutEnded = [[boutDetails objectForKey:@"ended"] intValue];
    if (!boutEnded) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(changeLogo:)];
        [_logo setUserInteractionEnabled:true];
        [_logo setAlpha:1.0f];
        [_logo addGestureRecognizer:gesture];
    }
    else {
        [_logo setUserInteractionEnabled:false];
        [_logo setAlpha:0.75f];
    }
}

-(void)prepareForReuse{
    [self clearView];
}

-(void)changeLogo:(UITapGestureRecognizer *)tap{
    NSArray *photos = [boutDetails objectForKey:@"photos"];
    if (!photos || [photos count] <= 0)
        return;
    [tap setEnabled:false];
    int page = ceil(_scroller.contentOffset.x / _scroller.frame.size.width);
    NSDictionary *photo = [photos objectAtIndex:page];
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"owner_email":[photo valueForKey:@"owner_email"],
                             @"bout_id":[boutDetails valueForKey:@"id"]};
    [httpClient postPath:@"/bouts/photos/vote"
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSDictionary *resp = [NSJSONSerialization
                                      JSONObjectWithData: responseObject
                                      options: NSJSONReadingMutableContainers
                                      error: nil];
                     int success = [[resp objectForKey:@"success"] intValue];
                     if (!success) {
                         [Util showMessage:[resp valueForKey:@"error"]
                                 withTitle:@"Error"];
                         return;
                     }
                     [tap setEnabled:true];
                     [self moveToNextView:nil];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [tap setEnabled:true];
                    NSLog(@"Error: %@", error);
                }];
}

-(void)clearView{
    for (UIView *image in [_scroller subviews])
        [image removeFromSuperview];
    [_profilePic clearImage];
    [_pageControl setCurrentPage:0];
    [_scroller setContentOffset:CGPointMake(0, 0)];
    [_leaderBoardButton setImage:[UIImage imageNamed:@"like_icon"]
           forState:UIControlStateNormal];
    [_name setText:@""];
    [_user setText:@""];
    [_vote setText:@""];
    [_vote setTextColor:[UIColor whiteColor]];
    [_joinButton setEnabled:true];
    [_comment setTitle:@"??"
              forState:UIControlStateNormal];
    [_logo setImage:[UIImage imageNamed:@"logo_white"]];
    [_leaderBoardButton setUserInteractionEnabled:true];
    [_leaderBoardButton setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
}

-(void)addBlur{
    blurView = [Util addBlurViewFor:self
                              above:_scroller];
    [blurView setAlpha:0.0];
}

-(void)showUserProfile:(UITapGestureRecognizer *)gesture{
    int page = ceil(_scroller.contentOffset.x / _scroller.frame.size.width);
    NSArray *photos = [boutDetails objectForKey:@"photos"];
    if (!photos || [photos count] <= 0)
        return;
    NSDictionary *currPhoto = [photos objectAtIndex:page];
    NSString *name = [NSString stringWithFormat:@"%@ %@", [currPhoto valueForKey:@"owner_first_name"], [currPhoto valueForKey:@"owner_last_name"]];
    NSString *fbID = @"";
    if ([currPhoto objectForKey:@"facebook_id"]) {
        fbID = [currPhoto objectForKey:@"facebook_id"];
    }
    NSDictionary *deets = @{@"user_id":[currPhoto objectForKey:@"owner_email"],
                            @"user_profile_pic":[currPhoto valueForKey:@"profile_picture"],
                            @"user_name":name,
                            @"user_fb_id":fbID};
    [_delegate userProfileClicked:deets];
}

-(void)loadDetails{
    [_timeLeft setText:[boutDetails valueForKey:@"time_left"]];
    [_name setText:[NSString stringWithFormat:@"#%@", [boutDetails valueForKey:@"name"]]];
    [_leaderBoardButton setTitle:[boutDetails valueForKey:@"rank"]
           forState:UIControlStateNormal];
}

-(void)loadCoverImages{
    if (!coverImages)
        [self populateCoverImageViews];
    int numCoverImages = [self numCoverImages];
    for (int i = 0; i < numCoverImages; i++) {
        UIImageView *imageView = [coverImages objectAtIndex:i];
        [self loadCoverImageForIndex:i
                              inside:imageView];
        [_scroller addSubview:imageView];
    }
    float contentWidth = CGRectGetWidth(self.frame) * numCoverImages;
    _scroller.contentSize = CGSizeMake(contentWidth,
                                       CGRectGetHeight(_scroller.frame));
}

-(void)populateCoverImageViews{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++)
        [temp addObject:[[UIImageView alloc] init]];
    coverImages = temp;
    for (int i = 0; i < [coverImages count]; i++) {
        CGRect frame = CGRectMake(i * CGRectGetWidth(self.frame),
                                  0.0,
                                  CGRectGetWidth(self.frame),
                                  CGRectGetHeight(self.frame));
        UIImageView *imgView = [coverImages objectAtIndex:i];
        [imgView setFrame:frame];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        [imgView setClipsToBounds:true];
    }
}

-(void)setUpPageControl{
    [_pageControl setNumberOfPages:[self numCoverImages]];
}

-(int)numCoverImages{
    int galleryImages = (int) [boutDetails[@"photos"] count];
    int coverImageViews = (int) [coverImages count];
    int numImages = coverImageViews;
    if (galleryImages < coverImageViews)
        numImages = galleryImages;
    return numImages;
}

-(void)loadCoverImageForIndex:(int)index
                       inside:(UIImageView *)imageView{
    [imageView setImage:nil];
    NSDictionary *currPhoto = [boutDetails[@"photos"] objectAtIndex:index];
    NSString *imgURL = [NSString stringWithFormat:@"http://photobout-test.appspot.com%@", [currPhoto valueForKey:@"image"]];
    [imageView setImageWithURL:[NSURL URLWithString:imgURL]];
}

-(void)populateRankFor:(NSDictionary *)photo{
    NSArray *leaderBoard = [lbv getLeaderBoard];
    NSString *photoEmail = [photo valueForKey:@"owner_email"];
    BOOL rankSet = false;
    if (leaderBoard) {
        for (NSDictionary *rank in leaderBoard) {
            if ([[rank valueForKey:@"email"] isEqualToString:photoEmail]) {
                [_leaderBoardButton setTitle:[[rank objectForKey:@"rank"] stringValue]
                                    forState:UIControlStateNormal];
                rankSet = true;
                break;
            }
        }
    }
    if (!rankSet)
        [_leaderBoardButton setTitle:@""
                            forState:UIControlStateNormal];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = ceil(scrollView.contentOffset.x / scrollView.frame.size.width);
    [_pageControl setCurrentPage:page];
    NSArray *photos = [boutDetails objectForKey:@"photos"];
    if (photos && [photos count] > 0) {
        NSDictionary *currPhoto = [[boutDetails objectForKey:@"photos"] objectAtIndex:page];
        [self populateRankFor:currPhoto];
        [self highlightWinner:currPhoto];
        [_vote setText:[NSString stringWithFormat:@"%@", [currPhoto valueForKey:@"num_votes"]]];
        [_user setText:[NSString stringWithFormat:@"%@ %@", [currPhoto valueForKey:@"owner_first_name"], [currPhoto valueForKey:@"owner_last_name"]]];
        [_profilePic clearImage];
        [_profilePic populateProfilePicWith:[currPhoto valueForKey:@"profile_picture"]];
        [_comment setTitle:[NSString stringWithFormat:@"%@", [currPhoto objectForKey:@"num_comments"]]
                  forState:UIControlStateNormal];
        [self updateLogo:[[currPhoto valueForKey:@"is_voted"] intValue]];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float alphaVal = [Util lerpFor:_scroller.contentOffset.y
                            withX0:yPos
                             andY0:1.0
                             andX1:0.0
                             andY1:0.0];
    [blurView setAlpha:alphaVal];
}
#pragma mark -
-(void)highlightWinner:(NSDictionary *)photo{
    int boutEnded = [[boutDetails objectForKey:@"ended"] intValue];
    BOOL isPhotoUpdated = false;
    if (boutEnded) {
        NSArray *winners = [boutDetails objectForKey:@"winners"];
        for (NSString *winner in winners) {
            if ([winner isEqualToString:[photo valueForKey:@"owner_email"]]){
                _scroller.layer.borderWidth = 10.0f;
                _scroller.layer.borderColor = [[Util appOrangeColor] CGColor];
                isPhotoUpdated = true;
            }
        }
    }
    if (!isPhotoUpdated) {
        _scroller.layer.borderWidth = 0.0f;
        _scroller.layer.borderColor = [[UIColor clearColor] CGColor];
    }
}

-(void)updateLogo:(int)isVoted{
    NSString *imgName = @"logo";
    UIColor *textColor = [Util appOrangeColor];
    if (isVoted == 0){
        imgName = @"logo_white";
        textColor = [UIColor whiteColor];
    }
    [_logo setImage:[UIImage imageNamed:imgName]];
    [_vote setTextColor:textColor];
}

#pragma mark ProductDetailsContainer
-(IBAction)showCommentsPressed:(id)sender{
    [_delegate showCommentsClicked];
    cv = (CommentsView *) [Util loadViewWithNibName:@"CommentsView"
                                            andType:[CommentsView class]];
    int page = ceil(_scroller.contentOffset.x / _scroller.frame.size.width);
    [cv populateComments:boutDetails
                     for:page];
    [cv setDelegate:self];
    [Util showView:cv inside:self];
}

-(IBAction)showMoreInfoPressed:(id)sender{
    moreInfoView = (MoreInfoView *) [Util loadViewWithNibName:@"MoreInfoView"
                                                      andType:[MoreInfoView class]];
    [moreInfoView populate:boutDetails];
    [moreInfoView setDelegate:self];
    [Util showView:moreInfoView inside:self];
}
#pragma mark -
-(IBAction)showAddPhoto:(id)sender{
    [_delegate showMoreInfoClicked];
    AddPhotoToBoutView *apb = (AddPhotoToBoutView *)[Util loadViewWithNibName:@"AddPhotoToBoutView"
                                                                      andType:[AddPhotoToBoutView class]];
    [apb setDelegate:self];
    [Util showView:apb
            inside:self];
    [apb addPhoto:nil];
}

-(void)prepareLeaderBoardView{
    lbv = (LeaderBoardView *) [Util loadViewWithNibName:@"LeaderBoardView"
                                                andType:[LeaderBoardView class]];
    [lbv populate:[boutDetails valueForKey:@"id"]];
    [lbv setDelegate:self];
}

-(IBAction)showLeaderBoard:(id)sender{
    [_delegate showCommentsClicked];
    [Util showView:lbv
            inside:self];
}

-(void)containerClosing{
    [lbv setDelegate:nil];
    [cv setDelegate:nil];
}

#pragma mark LeaderBoardContainer
-(void)leaderBoardClosed{
    [_delegate closeCommentsClicked];
}

-(void)leaderBoardFinishedLoading{
    [self scrollViewDidEndDecelerating:_scroller];
}
#pragma mark -

#pragma mark CreateBoutDelegate
-(void)moveToNextView:(NSObject *)boutID{
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"bout_id":[boutDetails valueForKey:@"id"]};
    [httpClient getPath:@"/bouts/get"
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [_delegate closeMoreInfoClicked];
                    NSArray *resp = [NSJSONSerialization
                                     JSONObjectWithData: responseObject
                                     options: NSJSONReadingMutableContainers
                                     error: nil];
                    [self clearView];
                    [self setDetails:[resp objectAtIndex:0]];
                    [_delegate updateBoutWith:[resp objectAtIndex:0]
                                          for:[boutDetails valueForKey:@"id"]];
                    [self populate];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [_delegate closeMoreInfoClicked];
                    NSLog(@"Error: %@", error);
                }];
}

-(void)presentController:(UIViewController *)controller{
    [_delegate presentController:controller];
}

-(NSObject *)getBoutID{
    return [boutDetails valueForKey:@"id"];
}
#pragma mark -


#pragma mark CommentsContainer
-(void)closePressed{
    [_delegate closeCommentsClicked];
    cv = nil;
}

-(void)updateCommentsCountTo:(int)count
                         for:(int)photoIdx{
    [_comment setTitle:[NSString stringWithFormat:@"%d", count]
              forState:UIControlStateNormal];
    NSArray *photos = [boutDetails objectForKey:@"photos"];
    NSMutableDictionary *currPhoto = [photos objectAtIndex:photoIdx];
    [currPhoto setObject:[NSNumber numberWithInt:count]
                  forKey:@"num_comments"];
    [_delegate updateBoutWith:boutDetails for:[boutDetails valueForKey:@"id"]];
}

-(void)showCommentUser:(NSObject *)uid{
    [_delegate userProfileClicked:uid];
}
#pragma mark -

#pragma mark MoreInfoContainer
-(void)closeMoreInfo{
    [moreInfoView removeFromSuperview];
    [_delegate closeMoreInfoClicked];
}

-(int)getPhotoIdx{
    return ceil(_scroller.contentOffset.x / _scroller.frame.size.width);
}
#pragma mark -

-(void)payViewClosed{
    [_delegate closeMoreInfoClicked];
}

-(void)webBuyViewClosed{
    [_delegate closeMoreInfoClicked];
}
@end
