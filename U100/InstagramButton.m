//
//  InstagramButton.m
//
//  Created by admin on 12/02/15.
//

#import "InstagramButton.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Util.h"

@implementation InstagramButton

-(void)share:(NSDictionary *)productDetails
     withIdx:(int)idx{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://camera"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
    else {
        [Util showMessage:@"The application cannot share a status at the moment. This is because it cannot reach Instagram or you don't have a Instagram account associated with this device."
                withTitle:@"Sorry"];
    }
}


@end
