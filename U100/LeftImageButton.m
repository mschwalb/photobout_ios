//
//  LeftImageButton.m
//
//  Created by admin on 16/03/15.
//

#import "LeftImageButton.h"

@implementation LeftImageButton

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect imgFrame = self.imageView.frame;
    self.imageView.frame = CGRectMake(0.0,
                                      CGRectGetHeight(self.frame)/2.0-CGRectGetHeight(imgFrame)/2.0,
                                      CGRectGetWidth(imgFrame),
                                      CGRectGetHeight(imgFrame));
    CGRect lblFrame = self.titleLabel.frame;
    self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.imageView.frame)/2.0-CGRectGetWidth(lblFrame)/2.0,
                                       CGRectGetHeight(self.frame)/2.0-CGRectGetHeight(lblFrame)/2.0-1.0,
                                       CGRectGetWidth(lblFrame),
                                       CGRectGetHeight(lblFrame));
}

@end
