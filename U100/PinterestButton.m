//
//  PinterestButton.m
//
//  Created by admin on 11/02/15.
//

#import "PinterestButton.h"

@implementation PinterestButton

-(void)share:(NSDictionary *)productDetails{
    Pinterest *pinterest = [[Pinterest alloc] initWithClientId:@"1442991"];
    [pinterest createPinWithImageURL:[NSURL URLWithString:[productDetails valueForKey:@"owner_image"]]
                           sourceURL:[NSURL URLWithString:[productDetails valueForKey:@"product_origin_url"]]
                         description:[productDetails valueForKey:@"name"]];
}

@end
