//
//  CreateBoutViewController.h
//
//  Created by admin on 08/04/15.
//

#import <UIKit/UIKit.h>
#import "MainTabController.h"
#import "CreateBoutDelegate.h"
#import "InviteFriendsView.h"
#import "NameBoutView.h"

@interface CreateBoutViewController : MainTabController<CreateBoutDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    @private
    NSArray *flow;
    int currIdx;
    NSObject *currBoutID;
    NameBoutView *nbv;
    BOOL isCurrBoutPrivate;
    InviteFriendsView *ifv;
}

@property (nonatomic, assign) IBOutlet UIButton *menu;
@property (nonatomic, assign) IBOutlet UIImageView *logo;
@property (nonatomic, assign) IBOutlet UILabel *logoLbl;

@end
