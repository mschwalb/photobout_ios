//
//  LoadingView.m
//
//  Created by admin on 22/03/15.
//

#import "LoadingView.h"
#import "Util.h"

@implementation LoadingView

-(void)didMoveToWindow{
    if (self.window) {
        [Util addBlurViewFor:self
                       above:nil];
    }
}


@end
