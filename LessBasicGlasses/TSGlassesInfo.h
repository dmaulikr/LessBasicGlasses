//
//  TSGlassesInfo.h
//  LessBasicGlasses
//
//  Created by Trey Springer on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSGlassesInfo : NSObject
{
    NSInteger pairID;
    NSString *name;
    NSString *pairPath;
    BOOL isOnline;
}

@property (nonatomic, readwrite) NSInteger pairID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *pairPath;
@property (nonatomic, readwrite) BOOL isOnline;
@end
