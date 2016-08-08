//
//  ListsCell.m
//
//  Created by admin on 17/02/15.
//

#import "ListsCell.h"
#import "Util.h"
#import "AFNetworking/AFImageRequestOperation.h"

@implementation ListsCell

-(void)showAddView{
    [_addList setHidden:false];
    _photo.layer.borderColor = [[Util appOrangeColor] CGColor];
    [_photo setImage:nil];
    [_name setText:@"Add"];
    [_name setTextColor:[Util appOrangeColor]];
}

-(void)populateWith:(NSDictionary *)productDetails{
    [_addList setHidden:true];
    _photo.layer.borderColor = [[Util appOrangeColor] CGColor];
    [_name setText:[productDetails valueForKey:@"name"]];
    [_name setTextColor:[UIColor blackColor]];
    NSString *imgURL = [NSString stringWithFormat:@"%@", [productDetails valueForKey:@"image"]];
    NSLog(@"%@", imgURL);
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:imgURL]];
    AFImageRequestOperation* imgOpr = [AFImageRequestOperation
                                       imageRequestOperationWithRequest:req
                                       success:^(UIImage *image) {
                                           [_photo setImage:image];
                                       }];
    [imgOpr start];
}

-(void)prepareForReuse{
    [_photo setImage:nil];
}

@end
