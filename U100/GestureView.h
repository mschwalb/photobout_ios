//
//  GestureView.h
//
//  Created by admin on 10/04/15.
//

#import <UIKit/UIKit.h>
#import "GestureViewDelegate.h"

@interface GestureView : UIView

-(void)initialize;
@property (nonatomic, assign) id<GestureViewDelegate> delegate;

@end
