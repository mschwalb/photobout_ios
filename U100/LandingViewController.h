//
//  LandingViewController.h
//
//  Created by admin on 23/12/14.
//

#import <UIKit/UIKit.h>
#import "LoginViewDelegate.h"
#import "SignupViewDelegate.h"
#import "LoginView.h"
#import "SignupView.h"

@interface LandingViewController : UIViewController<UIActionSheetDelegate, UIScrollViewDelegate, LoginViewDelegate, SignupViewDelegate>{
    @private
    NSArray *accounts;
    NSArray *marquees;
    enum cookie_states {ACTIVE, EXPIRED, ABSENT};
    BOOL isLoggingOut;
    int currLandingImg;
}

@property (nonatomic, strong) IBOutlet UIView *logo;

-(IBAction)fbLogin:(id)sender;
-(IBAction)customLogin:(id)sender;
-(IBAction)signUp:(id)sender;
-(IBAction)prepareForLogout:(UIStoryboardSegue *)unwindSegue;

@property (nonatomic, strong) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) IBOutlet UIPageControl *pager;
@property (nonatomic, strong) IBOutlet UILabel *marqueeTitle;
@property (nonatomic, strong) IBOutlet UILabel *marquee;
@property (nonatomic, strong) IBOutlet LoginView *loginView;
@property (nonatomic, strong) IBOutlet SignupView *signupView;
@property (nonatomic, strong) IBOutlet UIView *blackFilter;

@end
