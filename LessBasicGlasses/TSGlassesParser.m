//
//  TSGlassesParser.m
//  LessBasicGlasses
//
//  Created by Trey Springer on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TSGlassesParser.h"

@implementation TSGlassesParser
@synthesize pairs;

-(TSGlassesParser *) initGlassesParser
{
    [super init];
    
    appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"in didStartElement");
    if([elementName isEqualToString:@"glasses"]) {
        // init the array.
        pairs = [[NSMutableArray alloc] init];
    } else if([elementName isEqualToString:@"pair"]) {
        // init the pair
        aPair = [[TSGlassesInfo alloc] init];
        aPair.pairID = [[attributeDict objectForKey:@"id"] integerValue];
        NSLog(@"reading ID value: %i", aPair.pairID);
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
    if([elementName isEqualToString:@"glasses"])
    {
        return;
    }
    
    if([elementName isEqualToString:@"pair"])
    {
        aPair.isOnline = [aPair.pairPath hasPrefix:@"http"];
        [pairs addObject:aPair];
        [aPair release];
        aPair = nil;
    } else {
        NSLog(@"Adding %@ to %@",currentElementValue,elementName);
        [aPair setValue:currentElementValue forKey:elementName];
        [currentElementValue release];
        currentElementValue = nil;
    }
}

- (void) dealloc
{    
    [aPair release];
    [currentElementValue release];
    [super dealloc];
}
@end
