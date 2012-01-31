//
//  ViewController.m
//  PhotoPickerDemo
//
//  Created by Eugene Yagrushkin on 12-01-31.
//

#import "ViewController.h"

@implementation ViewController
@synthesize anImage;

#pragma mark - View lifecycle
- (void)viewDidUnload
{
    [self setAnImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)selectImage:(id)sender {
    selectPhoto = [[EYPhotoPiker alloc] init];
    [selectPhoto showFromView:self completion:^(UIImage *image) {
        
//        UIButton *button = (UIButton*)sender;
//        [images setValue:image forKey:[NSString stringWithFormat:@"image1", tag]];
//        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        NSLog(@"Selected Image %@", [image description]);
        
    } failure:^(NSError *error) {
        NSLog(@"failure %@", [error description]);
        
    }];
}
@end
