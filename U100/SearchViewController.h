//
//  SearchViewController.h
//
//  Created by admin on 19/02/15.
//

#import <UIKit/UIKit.h>
#import "MainTabController.h"

@interface SearchViewController : MainTabController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>{
    @private
    NSMutableArray *searchResults;
    NSDictionary *selUser;
}

@property (nonatomic, strong) IBOutlet UITextField *searchStr;
@property (nonatomic, strong) IBOutlet UITableView *resultsTable;
@property (nonatomic, strong) IBOutlet UISegmentedControl *searchOptions;

@end
