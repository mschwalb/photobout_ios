//
//  CreateBoutDelegate.h
//
//  Created by admin on 08/04/15.
//

#import <Foundation/Foundation.h>

@protocol CreateBoutDelegate <NSObject>

-(void)viewFinishedLoading;
-(void)moveToNextView:(NSObject *)boutID;
-(void)presentController:(UIViewController *)controller;
-(NSObject *)getBoutID;

@end

