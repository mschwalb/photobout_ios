//
//  AddPhotoToBoutView.h
//
//  Created by admin on 08/04/15.
//

#import <UIKit/UIKit.h>
#import "CreateBoutDelegate.h"
#import "LoadingView.h"

@interface AddPhotoToBoutView : UIView<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>{
    @private
    NSString *uploadURL;
    LoadingView *lv;
}

@property (nonatomic, assign) id<CreateBoutDelegate> delegate;
@property (nonatomic, assign) UIViewController *parentController;

-(IBAction)addPhoto:(id)sender;
-(IBAction)close:(id)sender;

@end
