//
//  TopLeftButton.m
//
//  Created by admin on 17/03/15.
//

#import "TopLeftButton.h"

@implementation TopLeftButton

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.imageView.frame;
    self.imageView.frame = CGRectMake(15.0,
                                      42.0-CGRectGetHeight(frame)/2.0,
                                      CGRectGetWidth(frame),
                                      CGRectGetHeight(frame));
}

@end
