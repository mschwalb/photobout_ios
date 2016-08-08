//
//  ProductResultsCell.h
//
//  Created by admin on 27/02/15.
//

#import <UIKit/UIKit.h>

@interface BoutResultsCell : UITableViewCell{
    @private
    NSDictionary *boutDetails;
}

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *num;

-(void)populate:(NSDictionary *)boutDetails;

@end
