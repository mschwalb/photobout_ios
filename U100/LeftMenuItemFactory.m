//
//  LeftMenuItemFactory.m
//
//  Created by admin on 12/01/15.
//

#import "LeftMenuItemFactory.h"
#import "Util.h"
#import "MainTabController.h"
#import "MenuDelegate.h"

@implementation LeftMenuItemFactory

-(void)instantiateControllers:(id<MenuDelegate>)menuDelegate{
    NSDictionary *labelToID = @{@"FEED" : @"FeedContainer",
                            @"ACTIVITY" : @"Activity",
                              @"SEARCH" : @"Search",
                        @"USER_DETAILS" : @"Profile",
                              @"CREATE" : @"Create"};
    labelToController = [[NSMutableDictionary alloc] init];
    for (id key in labelToID) {
        NSString *storyBoardID = [labelToID valueForKey:key];
        MainTabController *controller = (MainTabController *) [Util loadViewController:storyBoardID];
        [controller setDelegate:menuDelegate];
        [labelToController setValue:controller
                             forKey:key];
    }
}

-(MainTabController *)controllerForItemWithLabel:(NSString *)label{
    return [labelToController objectForKey:label];
}

@end
