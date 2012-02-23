//
//  EYSelectPhoto.h
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


    // TODO:
    // 2. NSError
    // 3. zoom image as a parameter
    // 4. add social services (Google +, Facebook, flickr, 500p)

    // DONE
    // 1. Singletone: autorelease issue ARC
    // 2. class methods + showFromView

#import <UIKit/UIKit.h>

typedef enum{
    EYPhotoPickerModeAll,
    EYPhotoPickerModeLocal,
    EYPhotoPickerModePhotoOnly,
    EYPhotoPickerModeImagesOnly
}EYPhotoPickerMode;

typedef void (^__completionBlock)(UIImage* image);
typedef void (^__failureBlock)(NSError* error);

@interface EYPhotoPicker : NSObject<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    
@private
    __completionBlock completionBlock;
    __failureBlock failureBlock;
    UIViewController *viewController;
    
    EYPhotoPickerMode mode;
}

+ (void) showFromView:(UIViewController*)aViewController completion:(__completionBlock) aCompletionBlock;
+ (void) showFromView:(UIViewController*)aViewController completion:(__completionBlock) aCompletionBlock failure:(__failureBlock) aFailureBlock;
+ (void) showFromView:(UIViewController*)aViewController completion:(__completionBlock) aCompletionBlock failure:(__failureBlock) aFailureBlock withMode:(EYPhotoPickerMode) mode;

@end
