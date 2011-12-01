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
@synthesize canvas;
@synthesize glasses;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - generic private methods for gestures
- (void)showOverlayWithFrame:(CGRect)frame {
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
    _marque.position = CGPointMake(frame.origin.x + canvas.frame.origin.x, frame.origin.y + canvas.frame.origin.y);
    
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
    
    CGAffineTransform currentTransform = glasses.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [glasses setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer *)sender scale];
    [self showOverlayWithFrame:glasses.frame];
}

- (void)rotate:(id)sender {
    if([(UIRotationGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded) {
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer *)sender rotation]);
    
    CGAffineTransform currentTransform = glasses.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, rotation);
    
    [glasses setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer *)sender rotation];
    [self showOverlayWithFrame:glasses.frame];
}

- (void)move:(id)sender {
    CGPoint translatedPoint = [(UIPanGestureRecognizer *)sender translationInView:canvas];
    
    if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [canvas center].x;
        _firstY = [canvas center].y;
    }
    
    translatedPoint = CGPointMake(_firstX + translatedPoint.x, _firstY + translatedPoint.y);
    
    //[glasses setCenter:translatedPoint];
    [canvas setCenter:translatedPoint];
    [self showOverlayWithFrame:glasses.frame];
}

-(void)tapped:(id)sender {
    _marque.hidden = YES;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (!_marque) {
        _marque = [[CAShapeLayer layer] retain];
        _marque.fillColor = [[UIColor clearColor] CGColor];
        _marque.strokeColor = [[UIColor grayColor] CGColor];
        _marque.lineWidth = 1.0f;
        _marque.lineJoin = kCALineJoinRound;
        _marque.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:5], nil];
        _marque.bounds = CGRectMake(glasses.frame.origin.x, glasses.frame.origin.y, 0, 0);
        _marque.position = CGPointMake(canvas.frame.origin.x + glasses.frame.origin.x, canvas.frame.origin.y + glasses.frame.origin.y);
    }
    
    [[self.view layer] addSublayer:_marque];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] autorelease];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] autorelease];
    [rotationRecognizer setDelegate:self];
    [self.view addGestureRecognizer:rotationRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] autorelease];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [canvas addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer *tapProfileImageRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
    [tapProfileImageRecognizer setNumberOfTapsRequired:1];
    [tapProfileImageRecognizer setDelegate:self];
    [canvas addGestureRecognizer:tapProfileImageRecognizer];
}

- (void)viewDidUnload
{
    [self setCanvas:nil];
    [self setGlasses:nil];
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
    [canvas release];
    [glasses release];
    [_marque release];
    [super dealloc];
}



#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}


@end
