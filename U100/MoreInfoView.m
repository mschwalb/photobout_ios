//
//  MoreInfoView.m
//
//  Created by admin on 10/02/15.
//

#import "MoreInfoView.h"
#import "Util.h"
#import "ShareButton.h"
#import "AddPhotoToBoutView.h"
#import "ShareButton.h"

@implementation MoreInfoView

-(void)populate:(NSDictionary *)_productDetails{
    productDetails = _productDetails;
    [_name setText:[NSString stringWithFormat:@"#%@", [productDetails valueForKey:@"name"]]];
    NSString *desc = [productDetails valueForKey:@"description"];
    if (desc && [desc isKindOfClass:[NSString class]] && [desc length] > 0)
        [_desc setText:desc];
    [self addGestureForSelf];
}

-(void)addGestureForSelf{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(close:)];
    [self addGestureRecognizer:tap];
}

-(void)close:(UITapGestureRecognizer *)tap{
    [_delegate closeMoreInfo];
    [self removeFromSuperview];
}

-(IBAction)share:(id)sender{
    ShareButton *btn = (ShareButton *)sender;
    [btn share:productDetails
       withIdx:[_delegate getPhotoIdx]];
}
@end
