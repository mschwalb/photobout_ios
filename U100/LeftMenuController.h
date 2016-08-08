//
//  LeftMenuController.h
//
//  Created by admin on 09/01/15.
//

#import <UIKit/UIKit.h>
#import "LeftMenuDelegate.h"
#import "ProfilePicView.h"

@interface LeftMenuController : UIViewController

@property (nonatomic, strong) id<LeftMenuDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet ProfilePicView *profilePic;
@property (nonatomic, strong) IBOutlet UILabel *profileLbl;

-(IBAction)createBout:(id)sender;
-(IBAction)activityButtonTapped:(id)sender;
-(IBAction)search:(id)sender;
-(IBAction)homeButtonTapped:(id)sender;
-(void)menuShown;

@end
