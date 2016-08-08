// TwitterHelper.m
//
// Copyright (c) 2013/2014 Kyle Begeman (www.kylebegeman.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "STLOAuthClient.h"
#import "SecretKeys.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "AFHTTPRequestOperation.h"
#import <Accounts/ACAccountStore.h>
#import <Accounts/Accounts.h>
#import "TwitterHelper.h"

#define kTwitterApiRootURL [NSURL URLWithString:@"https://api.twitter.com/1.1/"]

const struct TwitterCredentials TwitterCredentials = {
    .oauthToken = @"oauth_token",
    .oauthTokenSecret = @"oauth_token_secret",
    .userId = @"user_id",
    .screenName = @"screen_name"
};

@implementation TwitterHelper
//@synthesize accountStore =_accountStore;
+ (void)getCredentialsForAccount:(ACAccount *)account
                      completion:(void(^)(NSDictionary *credentials, NSError *error))completion {
    NSParameterAssert(completion);
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/"];
    STLOAuthClient *client = [[STLOAuthClient alloc] initWithBaseURL:url consumerKey:kTwitterConsumerKey secret:kTwitterConsumerSecret];
    NSDictionary *params = @{ @"x_auth_mode" : @"reverse_auth" };
    
    [client getPath:@"oauth/request_token"
         parameters:params
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *oauth = operation.responseString;

        NSString *S = oauth;
        NSDictionary *step2Params = [[NSMutableDictionary alloc] init];
        [step2Params setValue:kTwitterConsumerKey
                       forKey:@"x_reverse_auth_target"];
        [step2Params setValue:S
                       forKey:@"x_reverse_auth_parameters"];
        
        NSURL *url2 = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];

        SLRequest *stepTwoRequest =
                [SLRequest requestForServiceType:SLServiceTypeTwitter
                                   requestMethod:SLRequestMethodPOST
                                             URL:url2
                                      parameters:step2Params];
        
        stepTwoRequest.account = account;
        [stepTwoRequest performRequestWithHandler:
         ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
             NSString *responseStr =
             [[NSString alloc] initWithData:responseData
                                   encoding:NSUTF8StringEncoding];
             if (responseData && !error) {
                 completion([TwitterHelper credentialsFromTwitterOAuthResponse:responseStr], nil);
             } else {
                 completion(nil, error);
             }
         }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
        }];
}

+ (NSDictionary *)credentialsFromTwitterOAuthResponse:(NSString *)response {
    
    // Divide the string by ampersands
    NSArray *components = [response componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *credentials = [NSMutableDictionary dictionaryWithCapacity:4];
    
    // Iterate through the components
    for (NSString *component in components) {
        
        // Split by = sign
        NSRange divider = [component rangeOfString:@"="];
        NSString *key = [component substringToIndex:divider.location];
        NSString *val = [component substringFromIndex:divider.location+1];
        [credentials setObject:val forKey:key];
    }
    
    return credentials;
}

@end
