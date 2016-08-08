//
//  GestureView.m
//
//  Created by admin on 10/04/15.
//

#import "GestureView.h"

@implementation GestureView

-(void)initialize{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss:)];
    [self addGestureRecognizer:tap];
}

-(void)dismiss:(UITapGestureRecognizer *)tap{
    [_delegate viewDismissed];
    [self removeFromSuperview];
}

@end
