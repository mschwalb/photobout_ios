//
//  LoginView.m
//  U100
//
//  Created by admin on 26/12/14.
//

#import "LoginView.h"
#import "Util.h"
#import "AFHTTPClient.h"
#import "AppDelegate.h"

@implementation LoginView

#pragma mark CredentialsView
-(void)dismissKeyboard{
    NSArray *textFields = @[_emailField, _passField];
    for (UITextField *field in textFields)
        [field resignFirstResponder];
}
#pragma mark -

-(IBAction)forgotPassword:(id)sender{
    UIButton *forgotPassBtn = (UIButton *)sender;
    [forgotPassBtn setUserInteractionEnabled:false];
    NSString *params = [NSString stringWithFormat:@"forgotemail=%1$@", [_emailField text]];
    NSURLRequest *urlRequest = [Util createPostRequestFor:@"customer/account/ajaxForgotPassword"
                                               withParams:params];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:
     ^(NSURLResponse *response,
       NSData *data,
       NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [forgotPassBtn setUserInteractionEnabled:true];
             if (error) {
                 [Util showMessage:[error localizedDescription]
                         withTitle:@"Error"];
                 return;
             }
             NSDictionary *resetResponse = [NSJSONSerialization
                                            JSONObjectWithData: data
                                            options: NSJSONReadingMutableContainers
                                            error: nil];
             int success = [[resetResponse objectForKey:@"success"] intValue];
             if (success != 1)
                 [_delegate forgotPassUnSuccessful:[resetResponse valueForKey:@"message"]];
             else
                 [_delegate forgotPassSuccessful];
         });
     }];
}

-(IBAction)customLogin:(id)sender{
    UIButton *loginBtn = (UIButton *)sender;
    [loginBtn setUserInteractionEnabled:false];
    if ([_emailField hasText] && [_passField hasText]) {
        NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        AppDelegate *ad = [[UIApplication sharedApplication] delegate];
        NSString *deviceToken = ad.deviceTokenHex;
        if (!deviceToken)
            deviceToken = @"";
        NSDictionary *params = @{@"email":[_emailField text],
                                 @"password":[_passField text],
                                 @"token_hex":deviceToken};
        [httpClient postPath:@"/users/custom/login"
                  parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         [loginBtn setUserInteractionEnabled:true];
                         NSDictionary *resp = [NSJSONSerialization
                                          JSONObjectWithData: responseObject
                                          options: NSJSONReadingMutableContainers
                                          error: nil];
                         int success = [[resp objectForKey:@"success"] intValue];
                         if (success) {
                             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                             [defaults setObject:[resp valueForKey:@"first_name"]
                                          forKey:@"firstname"];
                             [defaults setObject:[resp valueForKey:@"last_name"]
                                          forKey:@"lastname"];
                             [defaults setObject:[resp valueForKey:@"email"]
                                          forKey:@"user_id"];
                             [defaults setObject:[resp valueForKey:@"email"]
                                          forKey:@"user_email"];
                             [defaults setObject:@"0"
                                          forKey:@"isFBUser"];
                             [defaults synchronize];
                             [_delegate loginSuccessful];
                         }
                         else{
                             [_delegate loginUnSuccessful:[resp valueForKey:@"error"]];
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [loginBtn setUserInteractionEnabled:true];
                         [_delegate loginUnSuccessful:[error localizedDescription]];
                     }];
    }
    else{
        [Util showMessage:@"Please enter valid email and password"
                withTitle:@"Missing credentials"];
        [loginBtn setUserInteractionEnabled:true];
    }
}
@end
