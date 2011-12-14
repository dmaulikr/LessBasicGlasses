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

@implementation ViewController
@synthesize glassesView, changeImageButton, backgroundImage, removeGlassesButton;

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
    
    // CGPoint relpoint = [[sender view].superview convertPoint:[sender view].frame.origin toView:nil];
    
    CGPoint abspoint = [[sender view].superview convertPoint:[sender view].center toView:glassesView];
    if ((abspoint.x <= 25 && abspoint.y >= 395) || (abspoint.x > 25 && (abspoint.y - .5*abspoint.x > 383))) {
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index %i",buttonIndex);
    if(buttonIndex == 0 || (buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]))
    {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && buttonIndex == 1)
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        backgroundImage.image = [UIImage imageNamed:@"obama.png"];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    
    [self->imagePicker dismissModalViewControllerAnimated:YES];
    [picker release];
}

- (void)imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    backgroundImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self->imagePicker dismissModalViewControllerAnimated:YES];
    [picker release];
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
        UIImage *image = [UIImage imageNamed:[gvc getGlassesFileName]];
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



@end
