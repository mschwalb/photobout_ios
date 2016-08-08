//
//  ActivityFeedDelegate.h
//
//  Created by admin on 18/03/15.
//

#import <Foundation/Foundation.h>

@protocol ActivityFeedDelegate <NSObject>

-(void)finishedLoadingActivity:(NSMutableDictionary *)activity;

@end
