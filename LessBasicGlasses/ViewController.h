//
//  ViewController.h
//  LessBasicGlasses
//
//  Created by Trey Springer on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIButton *addViewButton;
    
    int pairsVisible;
    
    UIView *glassesView;
    CAShapeLayer *_marque;
    CGFloat _lastScale;
    CGFloat _lastRotation;
    CGFloat _lastX;
    CGFloat _lastY;
    
    UIBarButtonItem *changeImageButton;
    UIImagePickerController *imagePicker;
    UITableViewController *photoSourcePicker;
    IBOutlet UIImageView *backgroundImage;
    
    UIBarButtonItem *removeGlassesButton;
}

- (IBAction)addViewButtonPressed:(id)sender;
- (IBAction)changeImageButtonPressed:(id)sender;
- (IBAction)removeGlassesButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *glassesView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *changeImageButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *removeGlassesButton;
@property (retain, nonatomic) UIImageView *backgroundImage;

@end
