//
//  PinterestButton.h
//
//  Created by admin on 11/02/15.
//

#import "ShareButton.h"
#import <Pinterest/Pinterest.h>

@interface PinterestButton : ShareButton

-(void)share:(NSDictionary *)productDetails;

@end
