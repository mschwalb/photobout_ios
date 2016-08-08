//
//  CredentialsView.m
//
//  Created by admin on 14/01/15.
//

#import "CredentialsView.h"

@implementation CredentialsView

-(void)didMoveToWindow{
    if (self.window) {
        [self addKeyboardNotifListeners];
    }
}

-(void)willMoveToWindow:(UIWindow *)newWindow{
    if (newWindow == nil) {
        [self removeKeyboardNotifListeners];
    }
}

#pragma mark KeyboardHandlers
-(void)addKeyboardNotifListeners{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(keyboardShown:)
                   name:UIKeyboardDidShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(keyboardHidden:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
}

-(void)removeKeyboardNotifListeners{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self
                      name:UIKeyboardDidShowNotification
                    object:nil];
    [center removeObserver:self
                      name:UIKeyboardWillHideNotification
                    object:nil];
}

-(void)keyboardShown:(NSNotification *)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    NSLog(@"%f %f", _verticalConstraint.constant, CGRectGetHeight(keyboardFrameBeginRect));
    _verticalConstraint.constant = CGRectGetHeight(keyboardFrameBeginRect);
    [self.superview setNeedsUpdateConstraints];
    [self.superview layoutIfNeeded];
}

-(void)keyboardHidden:(NSNotification *)notification{
    _verticalConstraint.constant = 0.0;
    [self.superview setNeedsUpdateConstraints];
    [self.superview layoutIfNeeded];
}
#pragma mark -


@end
