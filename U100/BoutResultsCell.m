//
//  ProductResultsCell.m
//
//  Created by admin on 27/02/15.
//

#import "BoutResultsCell.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking/AFImageRequestOperation.h"
#import "Util.h"

@implementation BoutResultsCell

-(void)populate:(NSDictionary *)_boutDetails{
    boutDetails = _boutDetails;
    [_name setText:[NSString stringWithFormat:@"#%@", [boutDetails valueForKey:@"name"]]];
    int numPhotos = 0;
    if (boutDetails[@"photos"] && [boutDetails[@"photos"] count] > 0)
        numPhotos = [boutDetails[@"photos"] count];
    [_num setText:[NSString stringWithFormat:@"%d >", numPhotos]];
}

@end
