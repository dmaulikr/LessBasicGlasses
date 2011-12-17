//
//  TSFaceParser.m
//  TSWebGalleryTableViewController
//
//  Created by Trey Springer on 12/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "TSFaceParser.h"

@implementation TSFaceParser
@synthesize faces;

-(TSFaceParser *) initFaceParser
{
    [super init];
    
    appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"in didStartElement");
    if([elementName isEqualToString:@"faces"]) {
        // init the array.
        faces = [[NSMutableArray alloc] init];
    } else if([elementName isEqualToString:@"face"]) {
        // init the face
        aFace = [[TSFamousFaceInfo alloc] init];
        aFace.faceID = [[attributeDict objectForKey:@"id"] integerValue];
        NSLog(@"reading ID value: %i", aFace.faceID);
    }
    NSLog(@"processing element %@",elementName);
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"in foundCharacters");
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [string componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    
    string = [filteredArray componentsJoinedByString:@" "];
    if (!string || (string.length == 0) || ([string isEqualToString:@" "]))
        return;
    
    if(!currentElementValue)
    {
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        [currentElementValue appendString:string];
    }
    NSLog(@"processing value %@",currentElementValue);
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"in didEndElement");
    if([elementName isEqualToString:@"faces"])
    {
        return;
    }
    
    if([elementName isEqualToString:@"face"])
    {
        aFace.isOnline = [aFace.facePath hasPrefix:@"http"];
        [faces addObject:aFace];
        [aFace release];
        aFace = nil;
    } else {
        NSLog(@"Adding %@ to %@",currentElementValue,elementName);
        [aFace setValue:currentElementValue forKey:elementName];
        [currentElementValue release];
        currentElementValue = nil;
    }
}

- (void) dealloc
{    
    [aFace release];
    [currentElementValue release];
    [super dealloc];
}

@end
