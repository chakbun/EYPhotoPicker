//
//  ViewController.h
//  PhotoPickerDemo
//
//  Created by Eugene Yagrushkin on 12-01-31.
//

#import <UIKit/UIKit.h>
#import "EYPhotoPiker.h"

@interface ViewController : UIViewController{
    EYPhotoPiker *selectPhoto;
}

@property (weak, nonatomic) IBOutlet UIImageView *anImage;


- (IBAction)selectImage:(id)sender;

@end
