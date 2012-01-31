//
//  ViewController.m
//  PhotoPickerDemo
//
//  Created by Eugene Yagrushkin on 12-01-31.
//

#import "ViewController.h"

@implementation ViewController
@synthesize anImageView;

#pragma mark - View lifecycle
- (void)viewDidUnload
{
    [self setAnImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)selectImage:(id)sender {
    selectPhoto = [[EYPhotoPiker alloc] init];
    [selectPhoto showFromView:self completion:^(UIImage *image) {
        
        if (image != nil) {
            CGImageRef imageRef = [image CGImage];
            
            CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
            CGDataProviderRef imageDataProvider = CGDataProviderCreateWithCFData(imageData);
            if (imageData != NULL) {
                CFRelease(imageData);
            }
            
            CGImageRef imageRefPrepared = CGImageCreate(CGImageGetWidth(imageRef),
                                                        CGImageGetHeight(imageRef),
                                                        CGImageGetBitsPerComponent(imageRef),
                                                        CGImageGetBitsPerPixel(imageRef),
                                                        CGImageGetBytesPerRow(imageRef),
                                                        CGImageGetColorSpace(imageRef),
                                                        CGImageGetBitmapInfo(imageRef),
                                                        imageDataProvider,
                                                        CGImageGetDecode(imageRef),
                                                        CGImageGetShouldInterpolate(imageRef),
                                                        CGImageGetRenderingIntent(imageRef));
            if (imageDataProvider != NULL) {
                CGDataProviderRelease(imageDataProvider);
            }
            
            UIImage *imagePrepared = [UIImage imageWithCGImage:imageRefPrepared];
            dispatch_async(dispatch_get_main_queue(), ^{
                [anImageView setImage:imagePrepared];
            });
            CGImageRelease(imageRefPrepared);
        }
        
        NSLog(@"Selected Image %@", [image description]);
        
    } failure:^(NSError *error) {
        
        UIImage *imagePrepared = [UIImage imageNamed:@"iOS.png"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [anImageView setImage:imagePrepared];
        });
        
        NSLog(@"failure %@", [error description]);
    }];
}

- (void) setImage:(CGImageRef)imageRef{
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    [anImageView setImage:image];
}


@end
