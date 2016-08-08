//
//  TagFollowersView.h
//
//  Created by admin on 24/02/15.
//

#import <UIKit/UIKit.h>
#import "TagFollowersContainer.h"

@interface TagFollowersView : UIView<UITableViewDataSource, UITableViewDelegate>{
    @private
    NSMutableArray *followers;
}

-(IBAction)closePressed:(id)sender;
-(void)populateFollowers;

@property (nonatomic, strong) IBOutlet UITableView *followersTable;
@property (nonatomic, assign) id<TagFollowersContainer> delegate;

@end
