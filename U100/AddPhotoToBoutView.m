//
//  AddPhotoToBoutView.m
//
//  Created by admin on 08/04/15.
//

#import "AddPhotoToBoutView.h"
#import "AFHTTPClient.h"
#import "AFNetworking/AFHTTPRequestOperation.h"
#import "Util.h"

@implementation AddPhotoToBoutView

-(IBAction)addPhoto:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    lv = [Util showLoadingViewOver:self
                              with:@""];
    [httpClient getPath:@"/bouts/photos/add"
              parameters:@{}
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [lv removeFromSuperview];
                     NSDictionary *resp = [NSJSONSerialization
                                           JSONObjectWithData: responseObject
                                           options: NSJSONReadingMutableContainers
                                           error: nil];
                     uploadURL = [resp valueForKey:@"upload_url"];
                     [self startPhotoUpload];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [lv removeFromSuperview];
                     [btn setUserInteractionEnabled:true];
                     NSLog(@"%@", error);
                 }];
}

-(void)startPhotoUpload{
    [[[UIActionSheet alloc]
      initWithTitle:@"Change profile photo"
      delegate:self
      cancelButtonTitle:@"Cancel"
      destructiveButtonTitle:nil
      otherButtonTitles:@"Choose from library", @"Take a photo", nil] showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0)
        [self invokePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    else if (buttonIndex == 1)
        [self invokePicker:UIImagePickerControllerSourceTypeCamera];
    else
        [self close:nil];
}

-(IBAction)close:(id)sender{
    [self removeFromSuperview];
    [_delegate moveToNextView:nil];
}

#pragma mark ImagePickerMethods
-(void)invokePicker:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [_delegate presentController:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSArray *comps = [uploadURL componentsSeparatedByString:@"http://photobout-test.appspot.com"];
    
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    lv = [Util showLoadingViewOver:self with:@""];
    NSMutableURLRequest *request =
    [httpClient multipartFormRequestWithMethod:@"POST"
                                          path:comps[1]
                                    parameters:@{@"bout_id":[_delegate getBoutID]}
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
        }
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    [picker dismissViewControllerAnimated:YES
                               completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES
                               completion:NULL];
    [self close:nil];
}

-(void)navigationController:(UINavigationController *)navigationController
     willShowViewController:(UIViewController *)viewController
                   animated:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [viewController.navigationItem setTitle:@"Select a photo"];
}
#pragma mark -

-(void)serverSideDoneUpdating{
    [lv removeFromSuperview];
    [_delegate moveToNextView:nil];
    [self removeFromSuperview];
}

@end
