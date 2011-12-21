//
//  ViewController.m
//  LessBasicGlasses
//
//  Created by Trey Springer on 11/30/11.
//  Copyright (c) 2011 Three Springs Software. All rights reserved.
//
//  Most view controller code created by Roger Chapman. You're the greatest.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "renderToImage.h"


@implementation ViewController
@synthesize glassesView, changeImageButton, backgroundImage, removeGlassesButton, moreOptionsButton, wrapperView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark UIGesture stuff

- (void)showOverlayWithFrame:(CGRect)frame {
    //NSLog(@"showoverlay");
    
    if (![_marque actionForKey:@"linePhase"]) {
        CABasicAnimation *dashAnimation;
        dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.5f];
        [dashAnimation setRepeatCount:HUGE_VALF];
        [_marque addAnimation:dashAnimation forKey:@"linePhase"];
    }
    _marque.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
    //_marque.position = CGPointMake(frame.origin.x + canvas.frame.origin.x, frame.origin.y + canvas.frame.origin.y);
    _marque.position = CGPointMake(frame.origin.x, frame.origin.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frame);
    [_marque setPath:path];
    CGPathRelease(path);
    
    _marque.hidden = NO;
    
}

- (void)scale:(id)sender {
    if([(UIPinchGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer *)sender scale]);
    NSLog(@"scale: %f",scale);
    CGAffineTransform currentTransform = [[(UIPinchGestureRecognizer*)sender view] transform];
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer *)sender scale];
    [self showOverlayWithFrame:[[(UIPinchGestureRecognizer*)sender view] frame]];
}

- (void)rotate:(id)sender {
    if([(UIRotationGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded) {
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer *)sender rotation]);
    
    CGAffineTransform currentTransform = [[(UIPinchGestureRecognizer*)sender view] transform];
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, rotation);
    
    [[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer *)sender rotation];
    [self showOverlayWithFrame:[[(UIPinchGestureRecognizer*)sender view] frame]];
}

- (void)move:(id)sender {
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer *)sender translationInView:self.view];
    
    if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
        _lastX = [[sender view] center].x;
        _lastY = [[sender view] center].y;
        removeGlassesButtonToggle = NO;
    }
    if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded) {
        removeGlassesButtonToggle = YES;
    }
    
    translatedPoint = CGPointMake(_lastX + translatedPoint.x, _lastY + translatedPoint.y);
    
    [[sender view] setCenter:translatedPoint];
    [self showOverlayWithFrame:[[(UIPinchGestureRecognizer*)sender view] frame]];
    
    
    // figure out where the corner is
    NSInteger deviceHeight, deviceWidth, deviceX, deviceY;
    CGFloat boundM, boundB;
    
    deviceHeight = [[UIScreen mainScreen] bounds].size.height;
    deviceWidth = [[UIScreen mainScreen] bounds].size.width;
    if([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)
    {
        deviceX = deviceWidth;
        deviceY = deviceHeight;
    } else {
        deviceX = deviceHeight;
        deviceY = deviceWidth;
    }
    boundM = 100.0/(40.0-(deviceX/4.0));
    boundB = -100.0*deviceX/(160.0-deviceX);
    // || (abspoint.x > trashRatio*deviceX && (abspoint.y - .5*abspoint.x > 383))
    
    CGPoint abspoint = [[sender view].superview convertPoint:[sender view].center toView:glassesView];
    NSLog(@"%f, %f",abspoint.x, abspoint.y);
    CGFloat abspointZ = deviceY-abspoint.y;
    if ((abspoint.x <= 40 && abspointZ <= 100) || ((abspoint.x > 40) && (abspointZ < boundM*abspoint.x + boundB))) {
        [(UIPanGestureRecognizer*)sender view].alpha = 0.5;
        removeGlassesButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
        if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
            [[(UIPanGestureRecognizer*)sender view] removeFromSuperview];
            removeGlassesButton.tintColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
            pairsVisible--;
            if (pairsVisible == 0)
            {
                removeGlassesButton.enabled = NO;
            }
        }
    } else {
        [(UIPanGestureRecognizer*)sender view].alpha = 1;
        removeGlassesButton.tintColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    }
    
}

-(void)tapped:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    _marque.hidden = YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    pairsVisible = 0;
    removeGlassesButtonToggle = YES;
    removeGlassesButton.enabled = NO;
    
}

- (void)viewDidUnload
{
    [self setGlassesView:nil];
    [self setChangeImageButton:nil];
    [self setRemoveGlassesButton:nil];
    [self setMoreOptionsButton:nil];
    [self setWrapperView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [_marque release];
    [glassesView release];
    [changeImageButton release];
    [super dealloc];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

- (IBAction)addViewButtonPressed:(id)sender {
    GalleryViewController *gvc = [[GalleryViewController alloc] init];
    gvc.delegate = self;
    [self presentModalViewController:gvc animated:YES];
    [gvc release];
}

#pragma mark image picking stuff
- (IBAction)changeImageButtonPressed:(id)sender
{
    UIActionSheet *actionSheet = [UIActionSheet alloc];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        actionSheet = [actionSheet initWithTitle:@"Pick Background Source:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library",@"Famous Faces",nil];
    } else {
        actionSheet = [actionSheet initWithTitle:@"Pick Background Source:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library",@"Famous Faces",nil];
    }
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark more options picking stuff
- (IBAction)moreOptionsButtonPressed:(id)sender
{
    NSLog(@"more options");
    MoreOptionsController *moc = [[MoreOptionsController alloc] init];
    moc.delegate = self;
    moc.image = [wrapperView renderToImage];
    [self presentModalViewController:moc animated:YES];
    [moc release];

}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index %i",buttonIndex);
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        buttonIndex++;
    }
    
    if(buttonIndex == 0)
    {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
    } else if(buttonIndex == 1) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
    } else if(buttonIndex == 2) {
        FamousViewController *fvc = [[FamousViewController alloc] init];
        fvc.delegate = self;
        [self presentModalViewController:fvc animated:YES];
        [fvc release];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    
    [self->imagePicker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    backgroundImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[glassesView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    pairsVisible = 0;
    removeGlassesButton.enabled = NO;
    [self->imagePicker dismissModalViewControllerAnimated:YES];
}

#pragma mark delete glasses section and UIAlertViewDelegate

- (IBAction)removeGlassesButtonPressed:(id)sender
{
    if (removeGlassesButtonToggle) {
        NSLog(@"remove glasses");
        UIAlertView *removeAllGlassesAlert = [[UIAlertView alloc] initWithTitle:@"Remove all glasses?" message:@"This will remove all glasses from the current picture." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete All", nil];
        [removeAllGlassesAlert show];
        [removeAllGlassesAlert release];
    }
        
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && pairsVisible > 0) {
        [[glassesView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
        pairsVisible = 0;
        removeGlassesButton.enabled = NO;
    }
}

#pragma mark GalleryViewDelegate methods
- (void)glassesSelected:(GalleryViewController *)gvc
{
    pairsVisible++;
    removeGlassesButton.enabled = YES;
    
    if (pairsVisible > 10)
    {
        UIAlertView *glassesAlert = [[UIAlertView alloc] initWithTitle:@"Too many pairs!" message:@"Sorry, you can only have 10 pairs of glasses at a time. Remove some by clicking the trash button below before adding more." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [glassesAlert show];
        [glassesAlert release];
    } else {
        UIImage *image;
        if([gvc getOnlineState])
        {
            // glasses are online, need to download them
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[gvc getGlassesFileName]]]];
        } else {
             image = [UIImage imageNamed:[gvc getGlassesFileName]];
        }
        
        UIView *canvas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 100)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[canvas frame]];
        [imageView setImage:image];
        [canvas addSubview:imageView];
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
        [pinchRecognizer setDelegate:self];
        [canvas addGestureRecognizer:pinchRecognizer];
        
        UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
        [rotationRecognizer setDelegate:self];
        [canvas addGestureRecognizer:rotationRecognizer];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelegate:self];
        [canvas addGestureRecognizer:panRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setDelegate:self];
        [canvas addGestureRecognizer:tapRecognizer];
        
        [self.glassesView addSubview:canvas];
    }
    [self dismissModalViewControllerAnimated:YES];
    [self reloadInputViews];
}

- (void)glassesCancelled
{
    [self dismissModalViewControllerAnimated:YES];
    [self reloadInputViews];
}

#pragma mark face selector
- (void)faceSelected:(FamousViewController *)fvc
{
    if([fvc getOnlineState])
    {
        // glasses are online, need to download them
        [backgroundImage setImageWithURL:[NSURL URLWithString:[fvc getFaceFileName]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        [backgroundImage setImage:[UIImage imageNamed:[fvc getFaceFileName]]];
    }
    [[glassesView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    pairsVisible = 0;
    removeGlassesButton.enabled = NO;
    [self dismissModalViewControllerAnimated:YES];
    [self reloadInputViews];
}

- (void)faceCancelled
{
    [self dismissModalViewControllerAnimated:YES];
    [self reloadInputViews];
}

#pragma mark MoreOptionsDelegate methods
-(void)saveImage
{
    [self dismissModalViewControllerAnimated:YES];
    [self reloadInputViews];
}

-(void)tweetImage
{    
    // don't do anything hurr
}

-(void)mailImage
{
    [self dismissModalViewControllerAnimated:YES];
    [self reloadInputViews];
}
-(void)gotoSEEOnline
{
    NSURL *url = [NSURL URLWithString:@"http://www.seeeyewear.com"];
    [[UIApplication sharedApplication] openURL:url];
    [self dismissModalViewControllerAnimated:YES];
    [self reloadInputViews];
}
-(void)signUpForSpecialOffers
{
    NSURL *url = [NSURL URLWithString:@"http://seeeyewear.com/bribes_and_secret_offers.aspx"];
    [[UIApplication sharedApplication] openURL:url];
    [self dismissModalViewControllerAnimated:YES];
    [self reloadInputViews];
}
-(void)endOptions
{
    [self dismissModalViewControllerAnimated:YES];
    [self reloadInputViews];
}



@end
