//
//  FavesCell.m
//
//  Created by admin on 17/02/15.
//

#import "FavesCell.h"
#import "Util.h"

@implementation FavesCell

-(void)populateWith:(NSDictionary *)productDetails{
    NSString *urlStr = [productDetails[@"gallery"] objectAtIndex:0];
    NSURLRequest *urlRequest = [Util createGetRequestFor:urlStr
                                              withParams:@""];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if ([data length] >0 && error == nil)
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       UIImage *img = [[UIImage alloc] initWithData:data];
                                       [_image setImage:img];
                                   });
                               else
                                   NSLog(@"%@", [error localizedDescription]);
                           }];
}

@end
