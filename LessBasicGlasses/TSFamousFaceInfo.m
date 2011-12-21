//
//  TSFamousFaceInfo.m
//  TSWebGalleryTableViewController
//
//  Created by Trey Springer on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TSFamousFaceInfo.h"

@implementation TSFamousFaceInfo

@synthesize faceID, name, facePath, isOnline;

-(void)dealloc {
    [name release];
    [facePath release];
    [super dealloc];
}

@end
