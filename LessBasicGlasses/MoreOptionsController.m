//
//  MoreOptionsController.m
//  LessBasicGlasses
//
//  Created by Trey Springer on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreOptionsController.h"
#import <Twitter/Twitter.h>

@implementation MoreOptionsController
@synthesize moreOptionsTable, delegate, image;

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
    optionsList = [[NSArray alloc] initWithObjects:@"Save Picture",@"Tweet Picture",@"Mail Picture",@"Go to SEE Online",@"Sign Up for Special Offers",@"About", nil];
}

- (void)viewDidUnload
{
    [self setMoreOptionsTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)composeTweet
{
    if([TWTweetComposeViewController canSendTweet] && image)
    {
        NSLog(@"attempting tweet");
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        BOOL temp;
        temp = [tweetSheet setInitialText:@"I tried on some hip new glasses with SEE Eyewear's Glasses Inspector!"];
        temp = [tweetSheet addImage:image];
        [self presentModalViewController:tweetSheet animated:YES];
        [tweetSheet release];
    } else {
        // can't tweet, tell them so
        UIAlertView *tweetAlert = [[UIAlertView alloc] initWithTitle:@"Twitter not set up!" message:@"Please set up a Twitter account in the device settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tweetAlert show];
        [tweetAlert release];
    }
    
}

-(void)composeMail
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
        mcvc.mailComposeDelegate = self;
        [mcvc setSubject:@"I tried on glasses with SEE's Eyeglass Inspector!"];
        [mcvc setMessageBody:@"Check out out my new style in these glasses!" isHTML:NO];
        NSData *data = UIImagePNGRepresentation(image);
        [mcvc addAttachmentData:data mimeType:@"image/png" fileName:@"SEEGlasses"];
        [self presentModalViewController:mcvc animated:YES];
        [mcvc release];
    } else {
        UIAlertView *mailAlert = [[UIAlertView alloc] initWithTitle:@"Mail not set up!" message:@"Can not send mail message. Please set up a mail account on this device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [mailAlert show];
        [mailAlert release];
    }
}



#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return optionsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [cell.textLabel setText:[optionsList objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            NSLog(@"Saving image");
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [delegate saveImage];
            break;
        case 1:
            [self composeTweet];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [delegate tweetImage];
            break;
        case 2:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self composeMail];
            [delegate mailImage];
            break;
        case 3:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [delegate gotoSEEOnline];
            break;
        case 4:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [delegate signUpForSpecialOffers];
            break;
        default:
            [delegate endOptions];
            break;
    }
}

#pragma mark Other Methods

- (IBAction)backButtonPressed:(id)sender {
    [delegate endOptions];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissModalViewControllerAnimated:YES];
    
}


- (void)dealloc {
    [moreOptionsTable release];
    [optionsList release];
    optionsList = nil;
    [super dealloc];
}
@end
