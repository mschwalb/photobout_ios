//
//  LeftMenuDelegate.h
//
//  Created by admin on 12/01/15.
//

#import <Foundation/Foundation.h>

@protocol LeftMenuDelegate <NSObject>

-(void)menuItemSelected:(NSString *)itemLabel
          searchUpdated:(BOOL)status
                trigger:(NSString *)trigger;
-(void)toggleMenuVisibility;

@end