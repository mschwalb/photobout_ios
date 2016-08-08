//
//  OrderCell.h
//
//  Created by admin on 18/03/15.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *date;

-(void)populateWith:(NSDictionary *)orderDetails;

@end
