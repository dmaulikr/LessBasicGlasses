//
//  GalleryViewController.m
//  TestGlassesPicker
//
//  Created by Trey Springer on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FamousViewController.h"
#import "UIImageView+WebCache.h"
#import "TSFaceParser.h"
#import "TSUtils.h"

@implementation FamousViewController
@synthesize facesTable, delegate, faces;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.treyspringer.com/see/famous-faces/faces.xml"];
    NSXMLParser *xmlParser;
    
    if (![TSUtils connectedToNetwork])
    {
        NSLog(@"Pulling locally");
        NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"faces" ofType:@"xml"];
        NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
        xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    } else {
        xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    }
    [url release];
    
    
    // initialize delegate
    TSFaceParser *parser = [[TSFaceParser alloc] initFaceParser];
    
    // set delegate
    [xmlParser setDelegate:parser];
    BOOL success = [xmlParser parse];
    
    if(success) {
        NSLog(@"No errors");
        faces = [[NSMutableArray alloc] initWithArray:parser.faces];
    } else {
        NSLog(@"Error'd");
        NSLog(@"%@",xmlParser.parserError.localizedDescription);
        NSLog(@"%@",xmlParser.parserError.localizedFailureReason);
        NSLog(@"%@",xmlParser.parserError.localizedRecoverySuggestion);
    }
}

- (void)viewDidUnload
{
    [self setFacesTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [faces release];
    faces = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSString *)getFaceFileName
{
    return faceFileName;
}

-(BOOL)getOnlineState
{
    return faceOnlineState;
}

#pragma mark UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return faces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[(TSFamousFaceInfo *)[faces objectAtIndex:indexPath.row] name]];
    if ([(TSFamousFaceInfo *)[faces objectAtIndex:indexPath.row] isOnline]) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:[(TSFamousFaceInfo *)[faces objectAtIndex:indexPath.row] facePath]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        [cell.imageView setImage:[UIImage imageNamed:[(TSFamousFaceInfo *)[faces objectAtIndex:indexPath.row] facePath]]];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    faceFileName = [(TSFamousFaceInfo *)[faces objectAtIndex:indexPath.row] facePath];
    faceOnlineState = [(TSFamousFaceInfo *)[faces objectAtIndex:indexPath.row] isOnline];
    [delegate faceSelected:self];
}


#pragma mark memory stuff

- (void)dealloc {
    [facesTable release];
    [super dealloc];
}
- (IBAction)selectionCancelled:(id)sender {
    [delegate faceCancelled];
}
@end
