//
//  ActivityFeed.m
//
//  Created by admin on 18/03/15.
//

#import "ActivityFeed.h"
#import "Util.h"

@implementation ActivityFeed

-(NSDictionary *)activityFor:(NSAttributedString *)message
                         and:(NSDictionary *)_activity{
    NSMutableDictionary *currActivity = [NSMutableDictionary dictionaryWithDictionary:_activity];
    [currActivity setObject:message
                     forKey:@"message"];
    return currActivity;
}

-(NSAttributedString *)highlight:(NSString *)highlight
                              in:(NSString *)message{
    NSMutableAttributedString *retVal = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange range = [message rangeOfString:highlight];
    [retVal addAttribute:NSForegroundColorAttributeName
                   value:[Util appOrangeColor]
                   range:range];
    return retVal;
}

-(void)fetch{
    activity = [[NSMutableDictionary alloc] init];
    [self addFollowersActivity];
}

-(void)addFollowersActivity{
    
}

-(void)addLikesActivity{
    
}

-(void)addListActivity{
    
}

-(void)addCommentActivity{
    
}


@end
