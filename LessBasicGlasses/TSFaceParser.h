//
//  TSFaceParser.h
//  TSWebGalleryTableViewController
//
//  Created by Trey Springer on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSFamousFaceInfo.h"

@class XMLAppDelegate, TSFamousFaceInfo;

@interface TSFaceParser : NSObject <NSXMLParserDelegate>
{
    NSMutableString *currentElementValue;
    XMLAppDelegate *appDelegate;
    TSFamousFaceInfo *aFace;
    NSMutableArray *faces;
}

@property (nonatomic, retain) NSMutableArray *faces;
-(TSFaceParser *) initFaceParser;

@end
