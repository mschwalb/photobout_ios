//
//  BrandsCell.m
//
//  Created by admin on 02/03/15.
//

#import "BrandsCell.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking/AFImageRequestOperation.h"
#import "Util.h"

@implementation BrandsCell

-(void)populateWith:(NSDictionary *)_brandDetails{
    brandDetails = _brandDetails;
    [_name setText:[brandDetails valueForKey:@"name"]];
    [self loadImage];
    [self beautifyPhoto];
}

-(void)beautifyPhoto{
    _photo.layer.cornerRadius = CGRectGetHeight(_photo.frame) / 2.0;
    _photo.layer.borderWidth = 2.5;
    _photo.layer.borderColor = [[Util appOrangeColor] CGColor];
}

-(void)loadImage{
    _photo.contentMode = UIViewContentModeScaleToFill;
    [_photo setImageWithURL:[NSURL URLWithString:[brandDetails valueForKey:@"image_url"]]];
}

@end
