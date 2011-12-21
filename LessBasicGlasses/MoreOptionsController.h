//
//  MoreOptionsController.h
//  LessBasicGlasses
//
//  Created by Trey Springer on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol MoreOptionsDelegate
-(void)saveImage;
-(void)tweetImage;
-(void)mailImage;
-(void)gotoSEEOnline;
-(void)signUpForSpecialOffers;
-(void)endOptions;
@end

@interface MoreOptionsController : UIViewController <UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    UITableView *moreOptionsTable;
    NSArray *optionsList;
    UIImage *image;
    id<MoreOptionsDelegate> delegate;
}

@property (retain, nonatomic) IBOutlet UITableView *moreOptionsTable;
@property (nonatomic, retain) id<MoreOptionsDelegate> delegate;
@property (nonatomic, retain) UIImage *image;
- (IBAction)backButtonPressed:(id)sender;

@end
