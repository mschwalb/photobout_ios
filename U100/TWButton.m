//
//  TWButton.m
//
//  Created by admin on 11/02/15.
//

#import "TWButton.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "Util.h"

@implementation TWButton

-(void)share:(NSDictionary *)boutDetails
     withIdx:(int)idx{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"Wanna vote for this on the bout #%@", [boutDetails valueForKey:@"name"]]];
        if (boutDetails[@"photos"] && [boutDetails[@"photos"] count] > idx) {
            NSDictionary *currPhoto = [boutDetails[@"photos"] objectAtIndex:idx];
            NSString *imgURL = [NSString stringWithFormat:@"http://photobout-test.appspot.com%@", [currPhoto valueForKey:@"image"]];
            NSURL *url = [NSURL URLWithString:imgURL];
            NSData *imgData = [NSData dataWithContentsOfURL:url];
            [tweetSheet addImage:[UIImage imageWithData:imgData]];
        }
        UIViewController *vc = [Util findContainingControllerFor:self];
        [vc presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
        [Util showMessage:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                withTitle:@"Sorry"];
}

@end
