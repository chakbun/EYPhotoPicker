//
//  ViewController.h
//  PhotoPickerDemo
//
//  Created by Eugene Yagrushkin on 12-01-31.
//

#import <UIKit/UIKit.h>
#import "EYPhotoPicker.h"

@interface ViewController : UIViewController{
    EYPhotoPicker *selectPhoto;
}

@property (weak, nonatomic) IBOutlet UIImageView *anImageView;


- (IBAction)selectImage:(id)sender;
- (void) setImage:(CGImageRef)imageRef;

@end
