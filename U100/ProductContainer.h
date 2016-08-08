//
//  ProductDetailsContainer.h
//
//  Created by admin on 07/01/15.
//

#import <Foundation/Foundation.h>

@protocol ProductContainer <NSObject>

-(void)showCommentsClicked;
-(void)closeCommentsClicked;
-(void)showMoreInfoClicked;
-(void)closeMoreInfoClicked;
-(void)userProfileClicked:(NSObject *)uid;
-(void)brandClicked:(NSString *)brand;
-(void)presentController:(UIViewController *)controller;
-(void)updateBoutWith:(NSDictionary *)boutDetails
                  for:(NSObject *)boutID;

@end
