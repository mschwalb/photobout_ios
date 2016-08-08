//
//  BrandDetailsView.m
//
//  Created by admin on 03/03/15.
//

#import "BrandDetailsView.h"
#import "AFNetworking/AFImageRequestOperation.h"

@implementation BrandDetailsView

-(IBAction)closePressed:(id)sender{
    [self removeFromSuperview];
    [_delegate brandsScreenClosed];
}

-(IBAction)showBrandProducts:(id)sender{
    [_delegate showProductsFor:[brandDetails valueForKey:@"name"]];
    [self closePressed:nil];
}

-(void)populateWith:(NSDictionary *)_brandDetails{
    brandDetails = _brandDetails;
    NSString *name = [brandDetails valueForKey:@"name"];
    [_name setText:name];
    [_descText setText:[brandDetails valueForKey:@"description"]];
    [self loadImage];
    [self beautifyPhoto];
    [_productsButton setTitle:[NSString stringWithFormat:@"%@ Products", name]
                     forState:UIControlStateNormal];
}

-(void)loadImage{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[brandDetails valueForKey:@"image_url"]]];
    AFImageRequestOperation* imgOpr = [AFImageRequestOperation
                                       imageRequestOperationWithRequest:req
                                       success:^(UIImage *image) {
                                           [_photo setImage:image];
                                       }];
    [imgOpr start];
}

-(void)beautifyPhoto{
    _photo.layer.cornerRadius = CGRectGetHeight(_photo.frame) / 2.0;
    _photo.layer.borderWidth = 2.5;
    _photo.layer.borderColor = [[UIColor grayColor] CGColor];
}

@end
