//
//  TSGlassesInfo.m
//  LessBasicGlasses
//
//  Created by Trey Springer on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TSGlassesInfo.h"

@implementation TSGlassesInfo
@synthesize pairID, name, pairPath, isOnline;

-(void)dealloc {
    [name release];
    [pairPath release];
    [super dealloc];
}
@end
