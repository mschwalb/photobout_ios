//
//  FeedContainerDelegare.h
//
//  Created by admin on 12/01/15.
//

#import <Foundation/Foundation.h>

@protocol MenuDelegate <NSObject>

-(void)toggleMenuVisibility;
-(void)searchParamsChanged:(NSString *)trigger;
-(void)reloadActivityCounter;
-(void)boutSuccessfullyCreated;

@end
