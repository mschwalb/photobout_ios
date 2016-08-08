//
//  ActivityViewController.h
//
//  Created by admin on 05/02/15.
//

#import <UIKit/UIKit.h>
#import "MainTabController.h"
#import "SingleProductViewDelegate.h"

@interface ActivityViewController : MainTabController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, SingleProductViewDelegate>{
    @private
    NSMutableArray *notifications;
    NSDictionary *selActivity;
    NSString *next;
}

@property (nonatomic, strong) IBOutlet UITableView *activityTable;
-(IBAction)refresh:(id)sender;
-(IBAction)clearActivities:(id)sender;

@end
