//
//  NameBoutView.h
//
//  Created by admin on 08/04/15.
//

#import <UIKit/UIKit.h>
#import "ProfilePicView.h"
#import "CreateBoutDelegate.h"
#import "BoutDurationView.h"
#import "BoutDurationDelegate.h"
#import "BoutAccessDelegate.h"
#import "BoutAccessView.h"

@interface NameBoutView : UIView<BoutDurationDelegate, BoutAccessDelegate, UITextFieldDelegate>{
    @private
    float origBottomConstraint;
    float origBoutDurationConstraint;
    float origBoutAccessConstraint;
    BoutDurationView *bdv;
    BoutAccessView *bav;
    UITapGestureRecognizer *tap;
    NSObject *duration;
    NSString *access;
}

@property (nonatomic, assign) IBOutlet NSLayoutConstraint *bottomContraint;
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *boutDurationConstraint;
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *boutAccessConstraint;
@property (nonatomic, assign) IBOutlet UIImageView *durationChevron;
@property (nonatomic, assign) IBOutlet UIImageView *accessChevron;
@property (nonatomic, assign) IBOutlet UITextField *name;
@property (nonatomic, assign) IBOutlet UITextField *boutDesc;
@property (nonatomic, assign) IBOutlet UIView *sep;
@property (nonatomic, assign) IBOutlet ProfilePicView *profilePic;
@property (nonatomic, assign) IBOutlet UILabel *userName;
@property (nonatomic, assign) IBOutlet UIButton *durationBtn;
@property (nonatomic, assign) IBOutlet UIButton *accessBtn;
@property (nonatomic, assign) id<CreateBoutDelegate> delegate;

-(IBAction)createBout:(id)sender;
-(IBAction)setBoutDuration:(id)sender;
-(IBAction)setBoutAccess:(id)sender;

-(BOOL)isBoutPrivate;

@end
