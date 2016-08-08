//
//  TitleLabel.m
//
//  Created by admin on 16/03/15.
//

#import "TitleLabel.h"

@implementation TitleLabel

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setFont:[UIFont fontWithName:@"nevis-Bold"
                                  size:15.0]];
    NSString *oldText = [self text];
    [self setText:[oldText uppercaseString]];
    _topConstraint.constant = 42.0 - (CGRectGetHeight(self.frame)/2.0);
}

@end
