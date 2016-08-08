//
//  ImageOnTopButton.m
//
//  Created by admin on 10/03/15.
//

#import "ImageOnTopButton.h"

@implementation ImageOnTopButton

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect img = self.imageView.frame;
    CGRect btn = self.frame;
    self.imageView.frame = CGRectMake(CGRectGetWidth(btn)/2.0-CGRectGetWidth(img)/2.0,
                                      10.0,
                                      CGRectGetWidth(img),
                                      CGRectGetHeight(img));
    self.titleLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0,
                                         CGRectGetMaxY(self.imageView.frame) + 15.0);
}

@end
