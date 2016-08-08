//
//  LoginViewDelegate.h
//  U100
//
//  Created by admin on 28/12/14.
//

#import <Foundation/Foundation.h>

@protocol LoginViewDelegate <NSObject>

-(void)loginSuccessful;
-(void)loginUnSuccessful:(NSString *)failureReason;
-(void)forgotPassSuccessful;
-(void)forgotPassUnSuccessful:(NSString *)failureReason;

@end

