//
//  renderToImage.m
//  LessBasicGlasses
//
//  Created by Trey Springer on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "renderToImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Ext)
- (UIImage *) renderToImage
{
    // IMPORTANT: using weak link on UIKit
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.frame.size);
    }
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    return image;
}

@end
