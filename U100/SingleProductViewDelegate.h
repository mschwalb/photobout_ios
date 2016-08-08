//
//  SingleProductViewDelegate.h
//
//  Created by admin on 04/03/15.
//

#import <Foundation/Foundation.h>

@protocol SingleProductViewDelegate <NSObject>

-(void)singleProductViewClosed;
-(void)presentController:(UIViewController *)controller;
-(void)userProfileClicked:(NSObject *)uid;
-(void)updateBoutWith:(NSDictionary *)boutDetails
                  for:(NSObject *)boutID;

@end
