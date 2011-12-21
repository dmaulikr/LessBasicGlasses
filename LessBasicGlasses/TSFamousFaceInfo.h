//
//  TSFamousFaceInfo.h
//  TSWebGalleryTableViewController
//
//  Created by Trey Springer on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSFamousFaceInfo : NSObject
{
    NSInteger faceID;
    NSString *name;
    NSString *facePath;
    BOOL isOnline;
}

@property (nonatomic, readwrite) NSInteger faceID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *facePath;
@property (nonatomic, readwrite) BOOL isOnline;

@end
