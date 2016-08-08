//
//  SignupViewDelegate.h
//
//  Created by admin on 15/01/15.
//

#import <Foundation/Foundation.h>

@protocol SignupViewDelegate <NSObject>

-(void)signupSuccessful;
-(void)signupUnSuccessful:(NSString *)failureReason;

@end