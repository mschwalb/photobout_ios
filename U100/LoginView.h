//
//  LoginView.h
//  U100
//
//  Created by admin on 26/12/14.
//

#import <UIKit/UIKit.h>
#import "LoginViewDelegate.h"
#import "CredentialsView.h"

@interface LoginView : CredentialsView

-(IBAction)customLogin:(id)sender;
-(IBAction)forgotPassword:(id)sender;

@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UITextField *passField;
@property (nonatomic, weak) id<LoginViewDelegate> delegate;

@end
