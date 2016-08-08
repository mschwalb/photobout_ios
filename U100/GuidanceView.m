//
//  GuidanceView.m
//
//  Created by admin on 24/03/15.
//

#import "GuidanceView.h"

@implementation GuidanceView

-(void)didMoveToWindow{
    if (self.window) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                               action:@selector(close:)];
        [self addGestureRecognizer:tap];
    }
}

-(void)close:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

@end
