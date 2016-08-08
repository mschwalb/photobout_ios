//
//  ProfileViewController.m
//  U100
//
//  Created by Marko Bulaić on 22/08/14.
//
#import "ProfileViewController.h"
#import "Util.h"
#import "BoutsView.h"
#import "WonView.h"
#import "SingleProductView.h"
#import "UIImageView+AFNetworking.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AFHTTPClient.h"
#import "NetworkView.h"

@implementation ProfileViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadCoverImage];
    if (isNonDefaultUserID)
        [self setUpViewForNonDefaultUser];
    else
        [self setUpViewForDefaultUser];
    [self addBlurView];
    [self changeProfileSection:_wonBtn];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!isNonDefaultUserID){
        [self loadNameFromDefaults];
        [_profilePic clearImage];
        [_profilePic populateProfilePicForLoggedInUser];
    }
}

-(void)loadCoverImage{
    NSDictionary *basicUserData = @{@"fields": @"cover"};
    [FBRequestConnection startWithGraphPath:@"/me"
                                 parameters:basicUserData
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if ([result objectForKey:@"cover"] &&
                                  [[result objectForKey:@"cover"] valueForKey:@"source"]){
                                  [_coverImage setContentMode:UIViewContentModeScaleAspectFill];
                                  [_coverImage setImageWithURL:[NSURL URLWithString:[[result objectForKey:@"cover"] valueForKey:@"source"]]];
                              }
                          }];
}

-(void)addBlurView{
    [Util addBlurViewFor:_blurView
                   above:nil];
}

-(void)determineStatusAndEnableFollow{
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient getPath:@"/users/is_following_user"
              parameters:@{@"user_id":_userID}
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSDictionary *resp = [NSJSONSerialization
                                           JSONObjectWithData: responseObject
                                           options: NSJSONReadingMutableContainers
                                           error: nil];
                     int isFollowing = [[[resp objectForKey:@"data"] objectForKey:@"is_following"] intValue];
                     if (isFollowing)
                         [_leftBtn setEnabled:false];
                     else
                         [_leftBtn setEnabled:true];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [_leftBtn setEnabled:false];
                     NSLog(@"%@", error);
                 }];
}

-(void)setUpViewForNonDefaultUser{
    NSString *currUserID = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_email"];
    if (![currUserID isEqualToString:(NSString *)_userID]){
        [_leftBtn setHidden:false];
        [_leftBtn setImage:[UIImage imageNamed:@"follow_user"]
                  forState:UIControlStateNormal];
        [_leftBtn addTarget:self
                     action:@selector(followUser:)
           forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setEnabled:false];
        [self determineStatusAndEnableFollow];
    }
    else{
        [_leftBtn setHidden:true];
    }
    [_name setText:_nonDefUserName];
    [_rightBtn setImage:[UIImage imageNamed:@"comments_close"]
               forState:UIControlStateNormal];
    [_profilePic populateProfilePicWith:_nonDefUserImgStr];
    [_rightBtn addTarget:self
                  action:@selector(close:)
        forControlEvents:UIControlEventTouchUpInside];
}

-(void)setUpViewForDefaultUser{
    [_rightBtn addTarget:self
                  action:@selector(settingsClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _userID = [defaults valueForKey:@"user_email"];
    [self loadNameFromDefaults];
}

-(void)loadNameFromDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [NSString stringWithFormat:@"%@ %@", [userDefaults valueForKey:@"firstname"], [userDefaults valueForKey:@"lastname"]];
    [_name setText:name];
}

-(void)populateUserDetails{
    
}

-(void)removeSubViews{
    for (UIView *subView in [_containerView subviews]){
        if ([subView respondsToSelector:@selector(setDelegate:)])
            [subView performSelector:@selector(setDelegate:)
                          withObject:nil];
        [subView removeFromSuperview];
    }
}

-(IBAction)changeProfileSection:(id)sender{
    [self removeSubViews];
    UIButton *sectionBtn = (UIButton *)sender;
    UIView *section = nil;
    [self setSectionImage:sectionBtn];
    if (sender == _boutsBtn) {
        section = [Util loadViewWithNibName:@"BoutsView"
                                    andType:[BoutsView class]];
        [(BoutsView *)section setUserID:_userID];
        [(BoutsView *)section populate];
        [(BoutsView *)section setDelegate:self];
    }
    else if (sender == _wonBtn){
        if (wv == nil) {
            wv = (WonView *) [Util loadViewWithNibName:@"WonView"
                                               andType:[WonView class]];
            [wv setUserID:_userID];
            [wv populate];
        }
        [wv setDelegate:self];
        section = wv;
    }
    else if (sender == _networkBtn){
        section = [Util loadViewWithNibName:@"NetworkView"
                                    andType:[NetworkView class]];
        [(NetworkView *)section setDelegate:self];
        [(NetworkView *)section setUserID:_userID];
        [(NetworkView *)section populate];
    }
    [Util showView:section
            inside:_containerView];
}

-(void)setSectionImage:(UIButton *)selBtn{
    NSArray *btns = @[_wonBtn, _boutsBtn, _networkBtn];
    NSDictionary *btnImg = @{[NSNumber numberWithInteger:[_boutsBtn tag]]:@[@"boutSectionImgNotSel", @"boutSectionImgSel"],
                             [NSNumber numberWithInteger:[_wonBtn tag]]:@[@"wonSectionImgNotSel", @"wonSectionImgSel"],
                             [NSNumber numberWithInteger:[_networkBtn tag]]:@[@"netSectionImgNotSel", @"netSectionImgSel"]};
    for (UIButton *btn in btns) {
        NSNumber *currTag = [NSNumber numberWithInteger:[btn tag]];
        NSArray *imgs = [btnImg objectForKey:currTag];
        UIImage *currBtnImg = nil;
        if ([currTag isEqualToNumber:[NSNumber numberWithInteger:[selBtn tag]]])
            currBtnImg = [UIImage imageNamed:imgs[1]];
        else
            currBtnImg = [UIImage imageNamed:imgs[0]];
        [btn setImage:currBtnImg
             forState:UIControlStateNormal];
    }
}

- (IBAction)settingsExited:(UIStoryboardSegue *)unwindSegue{
    NSLog(@"Here...");
}

-(void)settingsClicked:(id)sender{
    [self performSegueWithIdentifier:@"settingsSegue"
                              sender:self];
}

#pragma mark BoutsViewDelegate
-(void)showInFullScreen:(NSDictionary *)productDetails{
    SingleProductView *pv = (SingleProductView *) [Util loadViewWithNibName:@"SingleProductView"
                                                                    andType:[SingleProductView class]];
    [self.view addSubview:pv];
    [pv setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(pv);
    [self.view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[pv]|"
                          options:0
                          metrics:nil
                          views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[pv]|"
                          options:0
                          metrics:nil
                          views:bindings]];
    [pv layoutSubviews];
    [pv setDelegate:self];
    [pv populateWith:productDetails];
}

-(void)showAddNewListView{
    
}

-(void)showListProducts:(NSDictionary *)list{
    
}

-(void)boutsDataLoaded:(int)count{
    [_boutsLbl setText:[NSString stringWithFormat:@"%d Photobouts", count]];
    [_boutsBtn setTitle:[NSString stringWithFormat:@"%d", count]
               forState:UIControlStateNormal];
}
#pragma mark -

-(void)addToFullScreen:(UIView *)viewToDisplay{
    [self.view addSubview:viewToDisplay];
    [viewToDisplay setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(viewToDisplay);
    NSArray *vertConstraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|[viewToDisplay]|"
                                options:0
                                metrics:nil
                                views:bindings];
    [self.view addConstraints:vertConstraints];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[viewToDisplay]|"
                               options:0
                               metrics:nil
                               views:bindings]];
}

#pragma mark SingleProductViewDelegate
-(void)singleProductViewClosed{
    
}

-(void)presentController:(UIViewController *)controller{
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

-(void)userProfileClicked:(NSObject *)uid{
    [self userSelected:uid];
}

-(void)updateBoutWith:(NSDictionary *)boutDetails for:(NSObject *)boutID{
    
}
#pragma mark -

#pragma mark AddNewListDelegate
-(void)listFinishedAdding{
    [(BoutsView *)currSection reloadLists];
}
#pragma mark -

#pragma mark WonViewDelegate
-(void)userSelected:(NSObject *)uid{
    ProfileViewController *pvc = (ProfileViewController *) [Util loadViewController:@"Profile"];
    [pvc prepareForUserID:uid];
    NSLog(@"Selected: %@", uid);
    [self presentViewController:pvc
                       animated:YES
                     completion:nil];
}

-(void)wonDataLoaded:(int)count{
    [_winsLbl setText:[NSString stringWithFormat:@"%d Wins", count]];
    [_wonBtn setTitle:[NSString stringWithFormat:@"%d", count]
             forState:UIControlStateNormal];
    [self changeProfileSection:_boutsBtn];
}
#pragma mark -

-(void)prepareForUserID:(NSObject *)newUserID{
    NSDictionary *deets = (NSDictionary *)newUserID;
    _userID = [deets objectForKey:@"user_id"];
    _nonDefUserName = [deets valueForKey:@"user_name"];
    _nonDefUserFBID = [deets valueForKey:@"user_fb_id"];
    _nonDefUserImgStr = [deets valueForKey:@"user_profile_pic"];
    isNonDefaultUserID = true;
}

-(void)close:(id)sender{
    [self removeSubViews];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

-(void)followUser:(id)sender{
    [_leftBtn setEnabled:false];
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient postPath:@"/users/followers/add"
             parameters:@{@"following":_userID}
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [_leftBtn setEnabled:true];
                    NSDictionary *resp = [NSJSONSerialization
                                          JSONObjectWithData: responseObject
                                          options: NSJSONReadingMutableContainers
                                          error: nil];
                    int success = [[resp objectForKey:@"success"] intValue];
                    if (!success)
                        [Util showMessage:[resp valueForKey:@"error"]
                                withTitle:@"Error"];
                    else
                        [Util showMessage:@"You are now following this user"
                                withTitle:@"Success"];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [_leftBtn setEnabled:true];
                    NSLog(@"%@", error);
                }];
}
@end
