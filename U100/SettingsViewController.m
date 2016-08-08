//
//  SettingsViewController.m
//
//  Created by admin on 03/03/15.
//

#import "SettingsViewController.h"
#import "Util.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPClient.h"
#import "EditInputDetailsView.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadName];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(editProfilePic:)];
    [_profilePic addGestureRecognizer:gesture];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_profilePic clearImage];
    [_profilePic populateProfilePicForLoggedInUser];
}

-(void)loadName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstName = [defaults valueForKey:@"firstname"];
    NSString *lastName = [defaults valueForKey:@"lastname"];
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    editableSettings = [[NSMutableDictionary alloc] init];
    [editableSettings setValue:firstName
                        forKey:@"FIRST NAME"];
    [editableSettings setValue:lastName
                        forKey:@"LAST NAME"];
    [_table reloadData];
    [_name setText:name];
}

-(NSString *)getTitleFor:(int)index{
    NSString *retValue = @"";
    switch (index) {
        case 0:
            retValue = @"FIRST NAME";
            break;
        case 1:
            retValue = @"LAST NAME";
            break;
        default:
            break;
    }
    return retValue;
}

-(void)editProfilePic:(UITapGestureRecognizer *)gesture{
    [[[UIActionSheet alloc]
      initWithTitle:@"Change profile photo"
      delegate:self
      cancelButtonTitle:@"Cancel"
      destructiveButtonTitle:nil
      otherButtonTitles:@"Choose from library", @"Take a photo", nil] showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0)
        [self invokePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    else if (buttonIndex == 1)
        [self invokePicker:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark ImagePickerMethods
-(void)invokePicker:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker
                       animated:YES
                     completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient getPath:@"/users/profile_picture/add"
             parameters:@{}
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *resp = [NSJSONSerialization
                                          JSONObjectWithData: responseObject
                                          options: NSJSONReadingMutableContainers
                                          error: nil];
                    NSString *uploadURL = [resp valueForKey:@"upload_url"];
                    [self uploadImage:chosenImage
                                   to:uploadURL];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@", error);
                }];
    [picker dismissViewControllerAnimated:YES
                               completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES
                               completion:NULL];
}

-(void)navigationController:(UINavigationController *)navigationController
     willShowViewController:(UIViewController *)viewController
                   animated:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}
#pragma mark -

-(void)uploadImage:(UIImage *)image
                to:(NSString *)uploadURL{
    NSArray *comps = [uploadURL componentsSeparatedByString:@"http://photobout-test.appspot.com"];
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSMutableURLRequest *request =
    [httpClient multipartFormRequestWithMethod:@"POST"
                                          path:comps[1]
                                    parameters:@{}
                     constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                         [formData appendPartWithFileData:imageData
                                                     name:@"avatar"
                                                 fileName:@"avatar.jpg"
                                                 mimeType:@"image/jpeg"];
                     }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if(totalBytesWritten == totalBytesExpectedToWrite){
            [NSTimer scheduledTimerWithTimeInterval:2
                                             target:self
                                           selector:@selector(serverSideDoneUpdating)
                                           userInfo:nil
                                            repeats:NO];
            NSLog(@"Done :)");
        }
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
}

-(void)serverSideDoneUpdating{
    [_profilePic clearImage];
    [_profilePic populateProfilePicForLoggedInUser];
}

#pragma mark UITableView methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return [editableSettings count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"optionCell"];
    NSString *title = [self getTitleFor:(int)indexPath.row];
    NSString *detailText = [editableSettings valueForKey:title];
    [[cell textLabel] setText:title];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"SanFranciscoText-Semibold" size:12.0]];
    [[cell detailTextLabel] setText:detailText];
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"SanFranciscoText-Semibold" size:13.0]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(cell.frame) - 1, CGRectGetWidth(cell.frame), 1)];
    separatorLineView.backgroundColor = [Util colorWithHexString:@"C8C8C8"];
    [cell.contentView addSubview:separatorLineView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:_table cellForRowAtIndexPath:indexPath];
    [self showInputDetailsViewFor:cell];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark -

-(void)showInputDetailsViewFor:(UITableViewCell *)cell{
    edv = (EditInputDetailsView *) [Util loadViewWithNibName:@"EditInputDetailsView"
                                                     andType:[EditInputDetailsView class]];
    [_container insertSubview:edv aboveSubview:_table];
    [edv populateFor:[[cell textLabel] text]];
    [edv setTranslatesAutoresizingMaskIntoConstraints:NO];
    [edv setDelegate:self];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(edv);
    NSArray *vertConstraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|[edv]|"
                                options:0
                                metrics:nil
                                views:bindings];
    [_container addConstraints:vertConstraints];
    [_container addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[edv]|"
                          options:0
                          metrics:nil
                          views:bindings]];
}

-(void)valueEntered:(NSString *)input
             forKey:(NSString *)paramKey{
    [edv removeFromSuperview];
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{paramKey:input};
    [httpClient postPath:@"/users/update_profile"
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    if ([paramKey isEqualToString:@"first_name"])
                        [defaults setObject:input
                                     forKey:@"firstname"];
                    else
                        [defaults setObject:input
                                     forKey:@"lastname"];
                    [defaults synchronize];
                    [self loadName];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [Util showMessage:[error localizedDescription]
                            withTitle:@"Error"];
                }];
}

-(IBAction)closePressed:(id)sender{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
