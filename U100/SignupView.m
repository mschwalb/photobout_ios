//
//  SignupView.m
//
//  Created by admin on 14/01/15.
//

#import "SignupView.h"
#import "Util.h"
#import "AFHTTPClient.h"
#import "AppDelegate.h"

@implementation SignupView

#pragma mark CredentialsView
-(void)dismissKeyboard{
    NSArray *textFields = @[_firstName, _lastName, _email, _password];
    for (UITextField *field in textFields) {
        [field resignFirstResponder];
    }
}
#pragma mark -

-(IBAction)signUp:(id)sender{
    UIButton *signupBtn = (UIButton *)sender;
    [signupBtn setUserInteractionEnabled:false];
    NSString *pass = [_password text];
    NSString *email = [_email text];
    NSString *firstName = [_firstName text];
    NSString *lastName = [_lastName text];
    
    if (![self checkInput]){
        [signupBtn setUserInteractionEnabled:true];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    NSString *deviceToken = ad.deviceTokenHex;
    if (!deviceToken)
        deviceToken = @"";
    NSDictionary *params = @{@"email":email,
                             @"first_name":firstName,
                             @"last_name":lastName,
                             @"password":pass,
                             @"confirm_password":pass,
                             @"token_hex":deviceToken};
    [httpClient postPath:@"/users/signup"
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [signupBtn setUserInteractionEnabled:true];
                    NSDictionary *resp = [NSJSONSerialization
                                     JSONObjectWithData: responseObject
                                     options: NSJSONReadingMutableContainers
                                     error: nil];
                    int success = [[resp objectForKey:@"success"] intValue];
                    if (success){
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:firstName
                                     forKey:@"firstname"];
                        [defaults setObject:lastName
                                     forKey:@"lastname"];
                        [defaults setObject:email
                                     forKey:@"user_id"];
                        [defaults setObject:email
                                     forKey:@"user_email"];
                        [defaults setObject:@"0"
                                     forKey:@"isFBUser"];
                        [defaults synchronize];
                        [_delegate signupSuccessful];
                    }
                    else
                        [_delegate signupUnSuccessful:[resp valueForKey:@"error"]];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [signupBtn setUserInteractionEnabled:true];
                    [_delegate signupUnSuccessful:[error localizedDescription]];
                }];
    [self dismissKeyboard];
}

-(BOOL)checkInput{
    BOOL retVal = true;
    NSArray *mandatoryInput = @[_firstName, _lastName, _email, _password];
    for (UITextField *field in mandatoryInput) {
        if (![field text] || [[field text] length] <= 0) {
            NSString *message =[NSString stringWithFormat:@"Please input %@", [field placeholder]];
            [Util showMessage:message
                    withTitle:@"Error"];
            retVal = false;
            break;
        }
    }
    return retVal;
}

@end