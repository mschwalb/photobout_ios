//
//  OrderCell.m
//
//  Created by admin on 18/03/15.
//

#import "OrderCell.h"

@implementation OrderCell

-(void)populateWith:(NSDictionary *)orderDetails{
    [_name setText:[orderDetails valueForKey:@"name"]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:[orderDetails valueForKey:@"created_at"]];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    [_date setText:[dateFormat stringFromDate:date]];
}

@end
