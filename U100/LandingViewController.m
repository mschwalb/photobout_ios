//
//  LandingViewController.m
//
//  Created by admin on 23/12/14.
//

#import "LandingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Util.h"
#import "CredentialsView.h"
#import "AppDelegate.h"
#import "AFHTTPClient.h"
#import "NotificationHandlerViewController.h"

@interface LandingViewController ()

@end

@implementation LandingViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    [self loadScroller];
    [self scrollLandingImages];
    [self addGestureRecognisers];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!isLoggingOut)
        [self loginIfPreviousSession];
}

-(void)addGestureRecognisers{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)scrollLandingImages{
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(rotateLandingImg)
                                   userInfo:nil
                                    repeats:true];
}

-(void)rotateLandingImg{
    currLandingImg = (currLandingImg + 1) % [marquees count];
    CGFloat xOrigin = currLandingImg * CGRectGetWidth(self.view.frame);
    [_scroller setContentOffset:CGPointMake(xOrigin, 0.0)
                       animated:true];
}

-(void)loginIfPreviousSession{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:[Util retreiveFBPermissions]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionStateChanged:session
                                                              state:state
                                                              error:error];
                                      }];
    }
    else{
        switch ([self getCookieStatus]) {
            case ABSENT:
                break;
            case ACTIVE:
                [self loginSuccessful];
                break;
            case EXPIRED:
                [Util showMessage:@"Your current session has expired. Starting a new one"
                        withTitle:@"Note"];
                [self prepareForLogout:nil];
                break;
        }
    }
}

-(BOOL)doesCookieNameMatch:(NSHTTPCookie *)cookie{
    return ([[[cookie name] lowercaseString] isEqualToString:@"dgu00"]);
}

-(enum cookie_states)getCookieStatus{
    enum cookie_states retVal;
    retVal = ABSENT;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if ([self doesCookieNameMatch:cookie]) {
            NSDate *expiry = [cookie expiresDate];
            if (([expiry timeIntervalSinceNow]) > 3560.0)
                retVal = ACTIVE;
            else
                retVal = EXPIRED;
            break;
        }
    }
    return retVal;
}

-(void)handleTap:(UITapGestureRecognizer *)gesture{
    NSMutableArray *credentialViews = [[NSMutableArray alloc] init];
    if (_loginView)
        [credentialViews addObject:_loginView];
    if (_signupView)
        [credentialViews addObject:_signupView];
    for (CredentialsView *cv in credentialViews) {
        [cv dismissKeyboard];
        [cv removeFromSuperview];
    }
    [self resetLandingView];
}

-(IBAction)fbLogin:(id)sender{
    FBSession *currSession = [FBSession activeSession];
    [currSession closeAndClearTokenInformation];
    FBSessionState currState = currSession.state;
    if (currState == FBSessionStateOpen ||
        currState == FBSessionStateOpenTokenExtended) {
        [self sessionStateChanged:currSession
                            state:currState
                            error:nil];
    } else {
        NSLog(@"%@", [Util retreiveFBPermissions]);
        [FBSession openActiveSessionWithReadPermissions:[Util retreiveFBPermissions]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionStateChanged:session
                                 state:state
                                 error:error];
         }];
    }
}

-(void)successfulLogin{
    [self performSegueWithIdentifier:@"login" sender:self];
}

#pragma mark Sign Up
-(IBAction)signUp:(id)sender{
    [self prepareLandingView];
    [self showSignUpView];
}

-(void)showSignUpView{
    [[NSBundle mainBundle] loadNibNamed:@"SignUpView"
                                  owner:self
                                options:nil];
    [_signupView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_signupView setDelegate:self];
    [self.view addSubview:_signupView];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(_signupView);
    NSArray *vertConstraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:[_signupView]|"
                                options:0
                                metrics:nil
                                views:bindings];
    [_signupView setVerticalConstraint:[vertConstraints objectAtIndex:0]];
    [self.view addConstraints:vertConstraints];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_signupView]|"
                               options:0
                               metrics:nil
                               views:bindings]];
}
#pragma mark -

#pragma mark Scroller methods
-(void)loadScroller{
    NSArray *landingImgs = @[@"sneakers", @"men_fashion", @"girl_dress", @"drink"];
    marquees =@[@[@"CHALLENGE", @"Post a picture of your friends flip or your best look and invite your friends to one up you"],
                @[@"COMPETE", @"Compete in challenges posted by others by posting a picture to prove your might"],
                @[@"VOTE", @"Let everyone vote to decide\n who wore it best"],
                @[@"CELEBRATE", @"Get the most votes for your pictures to win and celebrate with your friends"]];
    [_pager setNumberOfPages:[landingImgs count]];
    NSArray *currMarquee = [marquees objectAtIndex:0];
    [_marqueeTitle setText:[currMarquee objectAtIndex:0]];
    [_marquee setText:[currMarquee objectAtIndex:1]];
    _scroller.contentSize = CGSizeMake(self.view.frame.size.width * [landingImgs count], self.view.frame.size.height);
    for (int i = 0; i < [landingImgs count]; i++) {
        UIImage *currImg = [UIImage imageNamed:[landingImgs objectAtIndex:i]];
        UIImageView *currView = [[UIImageView alloc] initWithImage:currImg];
        [currView setContentMode: UIViewContentModeCenter];
        [currView setClipsToBounds:true];
        CGFloat xOrigin = i * self.view.frame.size.width;
        currView.frame = CGRectMake(xOrigin, 0.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [_scroller addSubview:currView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int tempPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    [_pager setCurrentPage:tempPage];
    NSArray *currMarquee = [marquees objectAtIndex:tempPage];
    [_marqueeTitle setText:[currMarquee objectAtIndex:0]];
    [_marquee setText:[currMarquee objectAtIndex:1]];
}
#pragma mark -

#pragma mark Custom Login methods
-(IBAction)customLogin:(id)sender{
    [self prepareLandingView];
    [self addLoginView];
}

-(void)prepareLandingView{
    NSSet *viewsToShow = [NSSet setWithObjects:_logo, _scroller, _blackFilter, nil];
    for (UIView *subView in [self.view subviews]) {
        if (![viewsToShow containsObject:subView])
            [subView setHidden:true];
    }
}

-(void)resetLandingView{
    for (UIView *subView in [self.view subviews])
        [subView setHidden:false];
}

-(void)addLoginView{
    [[NSBundle mainBundle] loadNibNamed:@"LoginDetailsView"
                                  owner:self
                                options:nil];
    [_loginView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_loginView setDelegate:self];
    [self.view addSubview:_loginView];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(_loginView);
    NSArray *vertConstraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:[_loginView(163)]-0-|"
                                options:0
                                metrics:nil
                                views:bindings];
    [_loginView setVerticalConstraint:[vertConstraints objectAtIndex:1]];
    [self.view addConstraints:vertConstraints];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_loginView]|"
                               options:0
                               metrics:nil
                               views:bindings]];
}

-(void)loginSuccessful{
    [self successfulLogin];
}

-(void)loginUnSuccessful:(NSString *)failureReason{
    [Util showMessage:failureReason
            withTitle:@"Error"];
}

-(void)forgotPassSuccessful{
    [Util showMessage:@"Please check your email for further steps"
            withTitle:@"Success"];
}

-(void)forgotPassUnSuccessful:(NSString *)failureReason{
    [Util showMessage:failureReason
            withTitle:@"Error"];
}
#pragma mark -

#pragma mark Signup Delegate
-(void)signupSuccessful{
    [self handleTap:nil];
    [self loginSuccessful];
}

-(void)signupUnSuccessful:(NSString *)failureReason{
    [Util showMessage:failureReason
            withTitle:@"Error"];
}
#pragma mark -

-(void)startServerSessionForFBUser{
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                       id<FBGraphUser> user,
                                       NSError *error) {
         if (!error) {
             NSString *accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
             NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
             AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
             AppDelegate *ad = [[UIApplication sharedApplication] delegate];
             NSString *deviceToken = ad.deviceTokenHex;
             if (!deviceToken)
                 deviceToken = @"";
             NSDictionary *params = @{@"user_id" : [user objectID],
                                 @"access_token" : accessToken,
                                    @"token_hex" : deviceToken};
             [httpClient postPath:@"/users/facebook/login"
                       parameters:params
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSDictionary *resp = [NSJSONSerialization
                                                    JSONObjectWithData: responseObject
                                                    options: NSJSONReadingMutableContainers
                                                    error: nil];
                              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                              [defaults setObject:[user first_name]
                                           forKey:@"firstname"];
                              [defaults setObject:[user last_name]
                                           forKey:@"lastname"];
                              [defaults setObject:[user objectID]
                                           forKey:@"user_id"];
                              [defaults setObject:[resp valueForKey:@"email"]
                                           forKey:@"user_email"];
                              [defaults setObject:@"1"
                                           forKey:@"isFBUser"];
                              [defaults synchronize];
                              [self loginSuccessful];
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Error: %@", error);
                          }];
         }
         else{
             NSLog(@"%@", error);
             [Util showMessage:[Util fbErrorFrom:error]
                     withTitle:@"Error"];
         }
     }];
}

#pragma mark FB Login methods
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen){
        [self startServerSessionForFBUser];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        NSLog(@"Safe to show logged out UI");
    }
    
    if (error){
        NSLog(@"%@", error);
        NSString *alertText;
        NSString *alertTitle;
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [Util showMessage:alertText withTitle:alertTitle];
        } else {
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [Util showMessage:alertText withTitle:alertTitle];
            } else {
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [Util showMessage:alertText withTitle:alertTitle];
            }
        }
        [FBSession.activeSession closeAndClearTokenInformation];
        NSLog(@"Safe to show logged out UI");
    }
}

#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"landingToNotificationHandler"]) {
        [Util showMessage:@"Preparing for segue"
                withTitle:@"Alert"];
        NotificationHandlerViewController *nvc = (NotificationHandlerViewController *)segue.destinationViewController;
        [nvc setBoutID:sender];
    }
}

- (IBAction)prepareForLogout:(UIStoryboardSegue *)unwindSegue{
    NSLog(@"Unwinding...");
    isLoggingOut = true;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"user_id"];
    [userDefaults removeObjectForKey:@"user_email"];
    [userDefaults removeObjectForKey:@"firstname"];
    [userDefaults removeObjectForKey:@"lastname"];
    [userDefaults removeObjectForKey:@"isFBUser"];
    [userDefaults synchronize];
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    [ad setSearchParams:[[NSMutableDictionary alloc] init]];
    [FBSession.activeSession closeAndClearTokenInformation];
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient postPath:@"/users/logout"
              parameters:@{}
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     isLoggingOut = false;
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     isLoggingOut = false;
                     [Util showMessage:@"Unsuccessful logout"
                             withTitle:@"Error"];
                 }];
}
@end
