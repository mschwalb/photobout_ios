//
//  RightImageButton.m
//
//  Created by admin on 16/03/15.
//

#import "RightImageButton.h"

@implementation RightImageButton

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect imgFrame = self.imageView.frame;
    self.imageView.frame = CGRectMake(CGRectGetWidth(self.frame)-CGRectGetWidth(imgFrame),
                                      CGRectGetHeight(self.frame)/2.0-CGRectGetHeight(imgFrame)/2.0,
                                      CGRectGetWidth(imgFrame),
                                      CGRectGetHeight(imgFrame));
    CGRect lblFrame = self.titleLabel.frame;
    self.titleLabel.frame = CGRectMake(CGRectGetMidX(self.imageView.frame)-CGRectGetWidth(lblFrame)/2.0,
                                       CGRectGetHeight(self.frame)/2.0-CGRectGetHeight(lblFrame)/2.0,
                                       CGRectGetWidth(lblFrame),
                                       CGRectGetHeight(lblFrame));
}


@end
