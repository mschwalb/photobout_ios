//
//  ActivityFeed.h
//
//  Created by admin on 18/03/15.
//

#import <Foundation/Foundation.h>
#import "ActivityFeedDelegate.h"

@interface ActivityFeed : NSObject{
    @private
    NSMutableDictionary *activity;
}

-(void)fetch;
@property (nonatomic, assign) id<ActivityFeedDelegate> delegate;

@end
