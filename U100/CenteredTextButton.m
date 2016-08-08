//
//  CenteredTextButton.m
//
//  Created by admin on 10/03/15.
//

#import "CenteredTextButton.h"

@implementation CenteredTextButton

-(void)layoutSubviews{
    [super layoutSubviews];
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2.0,
                                 CGRectGetHeight(self.frame)/2.0);
    self.imageView.center = center;
    if (self.tag == 773)
        self.imageView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0,
                                            (CGRectGetHeight(self.frame)/2.0 - 2.5));
    self.titleLabel.center = center;
    
}

@end
