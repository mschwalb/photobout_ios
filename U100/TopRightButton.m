//
//  TopRightButton.m
//
//  Created by admin on 16/03/15.
//

#import "TopRightButton.h"

@implementation TopRightButton

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.imageView.frame;
    self.imageView.frame = CGRectMake((CGRectGetWidth(self.frame)-15.0)-CGRectGetWidth(frame),
                                      42.0-CGRectGetHeight(frame)/2.0,
                                      CGRectGetWidth(frame),
                                      CGRectGetHeight(frame));
}

@end
