//
//  CanvasViewController.m
//  Canvas
//
//  Created by Miles Spielberg on 2/25/15.
//  Copyright (c) 2015 OrionNet. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController ()

@property (strong, nonatomic) IBOutlet UIView *trayView;
@property (assign, nonatomic) CGPoint trayOriginalCenter;
@property (strong, nonatomic) UIImageView *newlyCreatedFace;
@property (assign, nonatomic) CGPoint yayNewlyCreatedFaceOriginalCenter;
@property (assign, nonatomic) CGFloat previousScale;

@end

@implementation CanvasViewController

static CGFloat const upPosition = 468.0;
static CGFloat const downPosition = 640.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
//    CGPoint point = [sender locationInView:self.trayView];
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        self.trayOriginalCenter = self.trayView.center;
    } else if ([sender state] == UIGestureRecognizerStateChanged) {
        self.trayView.center = CGPointMake(self.trayOriginalCenter.x, self.trayOriginalCenter.y + [sender translationInView:self.trayView].y);
    } else if ([sender state] == UIGestureRecognizerStateEnded) {
        BOOL movingUp = [sender velocityInView:self.trayView].y < 0.0;
        CGPoint destination = CGPointMake(self.trayOriginalCenter.x, movingUp ? upPosition : downPosition);
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:0 animations:^{
            self.trayView.center = destination;

        } completion:nil];
    } else {
        NSLog(@"Well shit.");
    }
}

- (IBAction)onFacePanGesture:(UIPanGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateBegan) {
        self.newlyCreatedFace = (UIImageView *)sender.view;
        if ([sender.view.superview isEqual:self.trayView]) {

            self.newlyCreatedFace = [[UIImageView alloc] initWithImage:((UIImageView *) sender.view).image];
            self.newlyCreatedFace.center = sender.view.center;
            [self.view addSubview:self.newlyCreatedFace];
            
            self.newlyCreatedFace.center = CGPointMake(self.newlyCreatedFace.center.x, self.newlyCreatedFace.center.y + self.trayView.frame.origin.y);
            
            UIGestureRecognizer *recog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onFacePanGesture:)];
            [self.newlyCreatedFace addGestureRecognizer:recog];
            
            self.newlyCreatedFace.userInteractionEnabled = YES;
            
            UIGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onFacePinchGesture:)];
            [self.newlyCreatedFace addGestureRecognizer:pinchRecognizer];
        }

        self.yayNewlyCreatedFaceOriginalCenter = self.newlyCreatedFace.center;
        [UIView animateWithDuration:0.2 animations:^{
            self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1.2, 1.2);

        }];
    } else if ([sender state] == UIGestureRecognizerStateChanged) {
        self.newlyCreatedFace.center = CGPointMake(self.yayNewlyCreatedFaceOriginalCenter.x + [sender translationInView:self.trayView].x, self.yayNewlyCreatedFaceOriginalCenter.y + [sender translationInView:self.trayView].y);
    } else if ([sender state] == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.newlyCreatedFace.transform = CGAffineTransformIdentity;

        }];

    } else {
        NSLog(@"Well shit #2.");
    }
}

- (IBAction)onFacePinchGesture:(UIPinchGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateBegan) {
        self.previousScale = 1;
    } else if ([sender state] == UIGestureRecognizerStateChanged) {
        NSLog(@"Scale is %f", sender.scale);
        self.newlyCreatedFace.transform = CGAffineTransformScale(self.newlyCreatedFace.transform, sender.scale / self.previousScale, sender.scale / self.previousScale);
        self.previousScale = sender.scale;
    } else if ([sender state] == UIGestureRecognizerStateEnded) {
        
    } else {
        NSLog(@"Well shit #3.");
    }
}

@end
