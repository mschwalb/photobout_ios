//
//  ProfilePicView.m
//
//  Created by admin on 04/03/15.
//

#import "ProfilePicView.h"
#import "Util.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPClient.h"

@implementation ProfilePicView

-(void)clearImage{
    for (UIView *subView in [self subviews])
        [subView removeFromSuperview];
}

-(NSString *)parseURL:(NSString *)imgURL{
    if ([imgURL isKindOfClass:[NSNull class]])
        return nil;
    if ([imgURL rangeOfString:@"https://"].length != 0)
        return imgURL;
    return [NSString stringWithFormat:@"http://photobout-test.appspot.com%@", imgURL];
}

-(void)populateProfilePicWith:(NSString *)imgURL{
    [self populateProfilePicWith:imgURL
                      andCaching:true];
}

-(void)populateProfilePicWith:(NSString *)imgURL
                   andCaching:(BOOL)caching{
    UIImageView *profilePicView = [[UIImageView alloc] init];
    [profilePicView setContentMode:UIViewContentModeScaleAspectFill];
    NSURL* imageURL = [NSURL URLWithString:[self parseURL:imgURL]];
    if (caching)
        [profilePicView setImageWithURL:imageURL];
    else{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        profilePicView.image = [UIImage imageWithData:imageData];
    }
    [Util showView:profilePicView
            inside:self];
}

-(void)populateProfilePicForLoggedInUser{
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    [httpClient getPath:@"/users/profile_picture_url"
             parameters:@{}
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *resp = [NSJSONSerialization
                                     JSONObjectWithData: responseObject
                                     options: NSJSONReadingMutableContainers
                                     error: nil];
                    [self populateProfilePicWith:[resp valueForKey:@"profile_picture_url"]
                                      andCaching:false];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
}

@end
