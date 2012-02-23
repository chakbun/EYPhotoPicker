//
//  EYSelectPhoto.m
//
//  Version 0.9
//
//  Created by Evgeny Yagrushkin on 12-01-29.
//  Copyright (c) 2012 Evgeny Yagrushkin All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "EYPhotoPicker.h"


@interface EYPhotoPicker()

- (void) showFromView:(UIViewController*)aViewController completion:(__completionBlock) aCompletionBlock failure:(__failureBlock) aFailureBlock withMode:(EYPhotoPickerMode) mode;

@end

@implementation EYPhotoPicker
static EYPhotoPicker *photoPicker;

#pragma mark - Class singleton methods
+ (void) showFromView:(UIViewController*)aViewController completion:(__completionBlock) aCompletionBlock{
    @synchronized(self) {
        if (!photoPicker) {
            photoPicker = [[EYPhotoPicker alloc] init];
        }
    }
    
    [photoPicker showFromView:aViewController completion:aCompletionBlock failure:nil withMode:EYPhotoPickerModeLocal];
}

+ (void) showFromView:(UIViewController*)aViewController completion:(__completionBlock) aCompletionBlock failure:(__failureBlock) aFailureBlock{
    @synchronized(self) {
        if (!photoPicker) {
            photoPicker = [[EYPhotoPicker alloc] init];
        }
    }
    
    [photoPicker showFromView:aViewController completion:aCompletionBlock failure:aFailureBlock withMode:EYPhotoPickerModeLocal];
}

+ (void) showFromView:(UIViewController*)aViewController completion:(__completionBlock) aCompletionBlock failure:(__failureBlock) aFailureBlock withMode:(EYPhotoPickerMode) mode{
    @synchronized(self) {
        if (!photoPicker) {
            photoPicker = [[EYPhotoPicker alloc] init];
        }
    }
    
    [photoPicker showFromView:aViewController completion:aCompletionBlock failure:aFailureBlock withMode:mode];
}

#pragma mark - instance methods
- (void) showFromView:(UIViewController*)aViewController completion:(__completionBlock) aCompletionBlock failure:(__failureBlock) aFailureBlock withMode:(EYPhotoPickerMode) aMode
{
    completionBlock = aCompletionBlock;
    failureBlock = aFailureBlock;
    viewController = aViewController;
    mode = aMode;

    switch (mode) {
        case EYPhotoPickerModeLocal:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Load picture:", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Library", nil), nil];
                [action showInView:aViewController.view];
            }
            else
            {
                [self actionSheet:nil clickedButtonAtIndex:1];
            }
            break;
            
        case EYPhotoPickerModeImagesOnly:
            [self actionSheet:nil clickedButtonAtIndex:1];
            break;
            
        case EYPhotoPickerModePhotoOnly:
            [self actionSheet:nil clickedButtonAtIndex:0];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        failureBlock(nil);
    }
    else{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        
        if (buttonIndex == 0) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.showsCameraControls = YES;
            imagePicker.allowsEditing = YES;
        }    
        else{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            else{
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                }
                else{
                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                    [errorDetail setValue:@"Device doesn't support either photo source" forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"MultiPhotoPicker" code:100 userInfo:errorDetail];
                    failureBlock(error);
                }
            }
        }
        
        [viewController presentModalViewController:imagePicker animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    failureBlock(nil);
    photoPicker = nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    failureBlock(nil);
    photoPicker = nil;
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

// resize image ? 
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
//    UIGraphicsEndImageContext();

    completionBlock(image);
    photoPicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
    failureBlock(nil);
    photoPicker = nil;
}


@end
