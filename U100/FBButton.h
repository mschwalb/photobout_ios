//
//  FBButton.h
//
//  Created by admin on 11/02/15.
//

#import "ShareButton.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface FBButton : ShareButton<FBSDKSharingDelegate>{
    @private
    NSDictionary *boutDetails;
}

@end
