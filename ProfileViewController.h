//
//  ProfileViewController.h
//  U100
//
//  Created by Marko Bulaić on 22/08/14.
//

#import <UIKit/UIKit.h>
#import "MainTabController.h"
#import "ProfilePicView.h"
#import "BoutsViewDelegate.h"
#import "AddNewListDelegate.h"
#import "WonViewDelegate.h"
#import "NetworkViewDelegate.h"
#import "WonView.h"
#import "SingleProductViewDelegate.h"

#define FOLLOWING_TABLE_TAG 3
#define USERS_TABLE_TAG 4

@interface ProfileViewController : MainTabController<BoutsViewDelegate, AddNewListDelegate, WonViewDelegate, NetworkViewDelegate, SingleProductViewDelegate>{
    @private
    BOOL isNonDefaultUserID;
    UIView *currSection;
    WonView *wv;
}

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *boutsLbl;
@property (nonatomic, strong) IBOutlet UILabel *winsLbl;
@property (nonatomic, strong) IBOutlet UIImageView *coverImage;
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIView *blurView;
@property (nonatomic, strong) IBOutlet UIButton *leftBtn;
@property (nonatomic, strong) IBOutlet UIButton *rightBtn;
@property (nonatomic, strong) IBOutlet UIButton *boutsBtn;
@property (nonatomic, strong) IBOutlet UIButton *wonBtn;
@property (nonatomic, strong) IBOutlet UIButton *networkBtn;
@property (nonatomic, strong) IBOutlet ProfilePicView *profilePic;
@property (nonatomic, assign) NSObject *userID;
@property (nonatomic, assign) NSString *nonDefUserName;
@property (nonatomic, assign) NSString *nonDefUserFBID;
@property (nonatomic, assign) NSString *nonDefUserImgStr;

-(IBAction)changeProfileSection:(id)sender;
- (IBAction)settingsExited:(UIStoryboardSegue *)unwindSegue;
-(void)prepareForUserID:(NSObject *)newUserID;

@end
