//
//  ShareButton.h
//
//  Created by admin on 11/02/15.
//

#import <UIKit/UIKit.h>

@interface ShareButton : UIButton

-(void)share:(NSDictionary *)productDetails
     withIdx:(int)idx;

@end
