//
//  NetworkViewDelegate.h
//
//  Created by admin on 22/03/15.
//

#import <Foundation/Foundation.h>

@protocol WonViewDelegate <NSObject>

-(void)userSelected:(NSObject *)uid;
-(void)wonDataLoaded:(int)count;
-(void)showInFullScreen:(NSDictionary *)productDetails;

@end
