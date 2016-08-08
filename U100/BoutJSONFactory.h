//
//  BoutJSONFactory.h
//
//  Created by admin on 29/03/15.
//

#import <Foundation/Foundation.h>

@interface BoutJSONFactory : NSObject{
    @private
    NSMutableArray *bouts;
}

-(NSDictionary *)getBoutFor:(int)idx;
-(void)voteForBout:(NSString *)name
           onPhoto:(NSString *)owner;

@end
