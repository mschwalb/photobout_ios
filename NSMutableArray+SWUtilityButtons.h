//
//  NSMutableArray+SWUtilityButtons.h
//  SWTableViewCell
//
//  Created by Matt Bowman on 11/27/13.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SWUtilityButtons)

- (void)sw_addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void)sw_addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon;
- (void)sw_addUtilityButtonWithColor:(UIColor *)color normalIcon:(UIImage *)normalIcon selectedIcon:(UIImage *)selectedIcon;

@end


@interface NSArray (SWUtilityButtons)

- (BOOL)sw_isEqualToButtons:(NSArray *)buttons;

@end