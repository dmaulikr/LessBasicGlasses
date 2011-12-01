//
//  ViewController.h
//  LessBasicGlasses
//
//  Created by Trey Springer on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate> {
    CGFloat _lastScale;
    CGFloat _lastRotation;
    CGFloat _firstX;
    CGFloat _firstY;
    
    UIImageView *glasses;
    UIView *canvas;
    
    CAShapeLayer *_marque;
}

@property (retain, nonatomic) IBOutlet UIView *canvas;
@property (retain, nonatomic) IBOutlet UIImageView *glasses;

@end
