//
//  LeftMenuController.m
//
//  Created by admin on 09/01/15.
//

#import "LeftMenuController.h"
#import "Util.h"

@interface LeftMenuController ()

@end

@implementation LeftMenuController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self addGesturesToSelf];
    [self addGesturesToProfile];
}

-(void)addGesturesToSelf{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss:)];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(dismiss:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:tap];
    [self.view addGestureRecognizer:swipe];
}

-(void)addGesturesToProfile{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(showProfile:)];
    [_profileLbl addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(showProfile:)];
    [_profilePic addGestureRecognizer:tap];
}

-(IBAction)createBout:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [_delegate menuItemSelected:[[btn titleLabel] text]
                  searchUpdated:false
                        trigger:nil];
}

-(IBAction)search:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [_delegate menuItemSelected:[[btn titleLabel] text]
                  searchUpdated:false
                        trigger:nil];
}

-(IBAction)homeButtonTapped:(id)sender{
    [_delegate menuItemSelected:@"FEED"
                  searchUpdated:false
                        trigger:nil];
}

-(IBAction)activityButtonTapped:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [_delegate menuItemSelected:[[btn titleLabel] text]
                  searchUpdated:false
                        trigger:nil];
}

-(void)dismiss:(UIGestureRecognizer *)gesture{
    [_delegate toggleMenuVisibility];
}

-(void)showProfile:(UITapGestureRecognizer *)tap{
    [_delegate menuItemSelected:@"USER_DETAILS"
                  searchUpdated:false
                        trigger:nil];
}

-(void)menuShown{
    [_profilePic clearImage];
    [_profilePic populateProfilePicForLoggedInUser];
}

@end
