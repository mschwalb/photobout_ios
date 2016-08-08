//
//  TWButton.h
//
//  Created by admin on 11/02/15.
//

#import "ShareButton.h"

@interface TWButton : ShareButton<UIActionSheetDelegate>{
    @private
    NSArray *accounts;
    NSString *tweet;
}

@end