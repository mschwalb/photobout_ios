//
//  ProductDetailsView.m
//
//  Created by admin on 06/01/15.
//

#import "ProductDetailsView.h"
#import "Util.h"

@implementation ProductDetailsView

-(void)populate:(NSDictionary *)_productDetails{
    productDetails = _productDetails;
    [_name setText:[productDetails valueForKey:@"name"]];
    [_user setText:[productDetails valueForKey:@"owner"]];
    [_brand setText:[productDetails valueForKey:@"brand"]];
    [_price setText:[NSString stringWithFormat:@"$%@", [productDetails valueForKey:@"price"]]];
    [_comment setTitle:[NSString stringWithFormat:@"%@", [productDetails objectForKey:@"comments_count"]]
              forState:UIControlStateNormal];
    [_like setTitle:[NSString stringWithFormat:@"%@", [productDetails objectForKey:@"likes_count"]]
              forState:UIControlStateNormal];
    [self addGestureRecognizerForBuying];
}

-(void)addGestureRecognizerForBuying{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(buy:)];
    [_buyContainer addGestureRecognizer:tap];
}

-(IBAction)showComments:(id)sender{
    [_delegate showCommentsPressed];
}

-(IBAction)showMoreInfo:(id)sender{
    [_delegate showMoreInfoPressed];
}

@end
