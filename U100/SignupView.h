//
//  SignupView.h
//
//  Created by admin on 14/01/15.
//

#import <UIKit/UIKit.h>
#import "CredentialsView.h"
#import "SignupViewDelegate.h"

@interface SignupView : CredentialsView

@property (nonatomic, strong) IBOutlet UITextField *firstName;
@property (nonatomic, strong) IBOutlet UITextField *lastName;
@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) id<SignupViewDelegate> delegate;

-(IBAction)signUp:(id)sender;

@end
