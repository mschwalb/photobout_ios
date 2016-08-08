//
//  LeaderBoardView.h
//
//  Created by admin on 02/04/15.
//

#import <UIKit/UIKit.h>
#import "LeaderBoardContainer.h"

@interface LeaderBoardView : UIView<UITableViewDataSource, UITableViewDelegate>{
    @private
    NSMutableArray *leaderBoard;
}

@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, assign) id<LeaderBoardContainer> delegate;

-(void)populate:(NSObject *)boutID;
-(IBAction)close:(id)sender;
-(NSArray *)getLeaderBoard;

@end
