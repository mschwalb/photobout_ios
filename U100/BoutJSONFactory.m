//
//  BoutJSONFactory.m
//
//  Created by admin on 29/03/15.
//

#import "BoutJSONFactory.h"

@implementation BoutJSONFactory
-(NSArray *)loadData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *data = [defaults objectForKey:@"data"];
    if (!data) {
        data = @[@{@"name" : @"#perfect360",
                   @"time_left" : @"7 days left",
                   @"photos" : @[@{@"owner" : @"@jakefarrell",
                                   @"image" : @"skater1",
                                   @"num_votes" : @"35",
                                   @"is_voted" : @"0"},
                                 @{@"owner" : @"@stevevall",
                                   @"image" : @"skater2",
                                   @"num_votes" : @"15",
                                   @"is_voted" : @"1"},
                                 @{@"owner" : @"@mattresnick",
                                   @"image" : @"skater3",
                                   @"num_votes" : @"3",
                                   @"is_voted" : @"0"}],
                   @"num_comments" : @"12",
                   @"rank" : @"2"},
                 @{@"name" : @"#BeaglesHalloweenParty",
                   @"time_left" : @"1 day left",
                   @"photos" : @[@{@"owner" : @"@mollypribor",
                                   @"image" : @"halloween1",
                                   @"num_votes" : @"17",
                                   @"is_voted" : @"1"},
                                 @{@"owner" : @"@stevevall",
                                   @"image" : @"halloween2",
                                   @"num_votes" : @"5",
                                   @"is_voted" : @"1"},
                                 @{@"owner" : @"@chrissie",
                                   @"image" : @"halloween3",
                                   @"num_votes" : @"13",
                                   @"is_voted" : @"0"},
                                 @{@"owner" : @"@erika",
                                   @"image" : @"halloween4",
                                   @"num_votes" : @"3",
                                   @"is_voted" : @"0"}],
                   @"num_comments" : @"7",
                   @"rank" : @"3"}];
    }
    return data;
}

-(NSDictionary *)getBoutFor:(int)idx{
    return [[self loadData] objectAtIndex:idx];
}

-(void)voteForBout:(NSString *)name
           onPhoto:(NSString *)owner{
    /*
    NSArray *data = [self loadData];
    for (NSDictionary *currBout in data) {
        if ([[currBout valueForKey:@"name"] isEqualToString:name]) {
            for (NSDictionary *photo in [currBout objectForKey:@"photos"]) {
                if ([[photo valueForKey:@"owner"] isEqualToString:owner]) {
                    photo[@"is_voted"] = @"1";
                }
            }
        }
    }
     */
}

@end
