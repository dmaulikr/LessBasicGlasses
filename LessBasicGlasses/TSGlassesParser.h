//
//  TSGlassesParser.h
//  LessBasicGlasses
//
//  Created by Trey Springer on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSGlassesInfo.h"

@class XMLAppDelegate, TSGlassesInfo;

@interface TSGlassesParser : NSObject <NSXMLParserDelegate>
{
    NSMutableString *currentElementValue;
    XMLAppDelegate *appDelegate;
    TSGlassesInfo *aPair;
    NSMutableArray *pairs;
}

@property (nonatomic, retain) NSMutableArray *pairs;
-(TSGlassesParser *) initGlassesParser;

@end
