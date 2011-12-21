//
//  GalleryViewController.h
//  TestGlassesPicker
//
//  Created by Trey Springer on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FamousViewDelegate
-(void)faceSelected:(UIViewController *)fvc;
-(void)faceCancelled;
@end

@interface FamousViewController : UIViewController <UITableViewDelegate>
{
    id<FamousViewDelegate> delegate;
    NSString *faceFileName;
    UITableView *facesTable;
    NSMutableArray *faces;
    BOOL faceOnlineState;
}

@property (nonatomic, assign) id<FamousViewDelegate> delegate; 
-(NSString *)getFaceFileName;
-(BOOL)getOnlineState;
@property (retain, nonatomic) IBOutlet UITableView *facesTable;
- (IBAction)selectionCancelled:(id)sender;
@property (nonatomic, retain) NSMutableArray *faces;




@end


