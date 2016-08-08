//
//  FBButton.m
//
//  Created by admin on 11/02/15.
//

#import "FBButton.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Util.h"

@implementation FBButton

-(void)share:(NSDictionary *)_boutDetails
     withIdx:(int)idx{
    boutDetails = _boutDetails;
    NSString *imgURL = @"";
    if (boutDetails[@"photos"] && [boutDetails[@"photos"] count] > idx) {
        NSDictionary *currPhoto = [boutDetails[@"photos"] objectAtIndex:idx];
        imgURL = [NSString stringWithFormat:@"http://photobout-test.appspot.com%@", [currPhoto valueForKey:@"image"]];
    }
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:imgURL];
    content.imageURL = [NSURL URLWithString:imgURL];
    content.contentDescription = [NSString stringWithFormat:@"Wanna vote for this on the bout #%@", [boutDetails valueForKey:@"name"]];
    content.contentTitle = @"Check out this Photobout";
    UIViewController *vc = [Util findContainingControllerFor:self];
    [FBSDKShareDialog showFromViewController:vc
                                 withContent:content
                                    delegate:self];
}

#pragma mark FBSDKSharingDelegate
-(void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    [Util showMessage:@"Posted to your timeline"
            withTitle:@"Success"];
}

-(void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    [Util showMessage:[error localizedDescription]
            withTitle:@"Error"];
}

-(void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"Did cancel");
}
#pragma mark -

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
