//
//  SettingsViewController.h
//
//  Created by admin on 03/03/15.
//

#import <UIKit/UIKit.h>
#import "ProfilePicView.h"
#import "EditInputDelegate.h"
#import "EditInputDetailsView.h"

@interface SettingsViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, EditInputDelegate>{
    @private
    NSDictionary *userSettings;
    NSDictionary *editableSettings;
    EditInputDetailsView *edv;
}

@property (nonatomic, strong) IBOutlet ProfilePicView *profilePic;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UIView *container;

-(IBAction)closePressed:(id)sender;

@end
