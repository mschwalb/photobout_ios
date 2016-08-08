//
//  EditInputDetailsView.h
//
//  Created by admin on 09/03/15.
//

#import <UIKit/UIKit.h>
#import "EditInputDelegate.h"

@interface EditInputDetailsView : UIView<UITextFieldDelegate>{
    NSString *paramKey;
}

@property (nonatomic, strong) IBOutlet UITextField *input;
@property (nonatomic, assign) id<EditInputDelegate> delegate;

-(void)populateFor:(NSString *)title;

@end
