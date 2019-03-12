//
//  ViewController.m
//  BookPageDemo
//
//  Created by 王锐 on 2019/3/12.
//  Copyright © 2019 wangrui. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import "UIImage+Resize.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<UIImage *> *imageArray;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) UIView *leftContainerView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIView *rightContainerView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIImageView *nextImageView;

@property (nonatomic, strong) UIImage *currentLeftImage;
@property (nonatomic, strong) UIImage *currentRightImage;

@property (nonatomic, strong) UIImage *nextLeftImage;
@property (nonatomic, strong) UIImage *prevRightImage;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.screenWidth = self.view.bounds.size.width;
    self.screenHeight = self.view.bounds.size.height;
    
    [self initImageViewArray];
    
    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)initImageViewArray
{
    self.imageArray = [@[] mutableCopy];
    
    CGFloat paddingLeft = self.screenWidth*.1f;
    CGFloat paddingTop = self.screenHeight*.1f;
    
    CGFloat imgMaxWidth = self.screenWidth-paddingLeft*2;
    CGFloat imgMaxHeight = self.screenHeight-paddingTop*2;
    
    self.nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(paddingLeft, paddingTop, imgMaxWidth, imgMaxHeight)];
    self.nextImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.nextImageView.clipsToBounds = YES;
    [self.view addSubview:self.nextImageView];
    
    self.leftContainerView = [[UIView alloc]initWithFrame:CGRectMake(paddingLeft-imgMaxWidth*.25f, paddingTop, imgMaxWidth+imgMaxWidth*.25f, imgMaxHeight)];
    self.leftContainerView.clipsToBounds = YES;
    [self.view addSubview:self.leftContainerView];
    
    self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imgMaxWidth*.5f, 0, imgMaxWidth*.5f, imgMaxHeight)];
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.leftImageView.layer.anchorPoint = CGPointMake(1, .5f);
    [self.leftContainerView addSubview:self.leftImageView];
    
    self.rightContainerView = [[UIView alloc]initWithFrame:CGRectMake(paddingLeft+imgMaxWidth*.25f, paddingTop, imgMaxWidth+imgMaxWidth*.25f, imgMaxHeight)];
    [self.view addSubview:self.rightContainerView];
    
    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgMaxWidth*.5f, imgMaxHeight)];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.rightImageView.layer.anchorPoint = CGPointMake(0, .5f);
    self.rightImageView.clipsToBounds = YES;
    [self.rightContainerView addSubview:self.rightImageView];
    
    for (NSInteger index = 1; index <= 7; index++) {
        NSString *fileName = [NSString stringWithFormat:@"%@", @(index)];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        image = [image croppedImageWithTargetRatio:(imgMaxWidth/imgMaxHeight)];
        [self.imageArray addObject:image];
    }
    self.currentIndex = 0;
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0].CGColor;
    
    [self setupCurrentView];
}

- (void)setupCurrentView
{
    UIImage *currentImage = self.imageArray[self.currentIndex];
    self.leftImageView.image = [currentImage croppedImage:CGRectMake(0, 0, currentImage.size.width*.5f, currentImage.size.height)];
    self.rightImageView.image = [currentImage croppedImage:CGRectMake(currentImage.size.width*.5f, 0, currentImage.size.width*.5f, currentImage.size.height)];
    if (self.currentIndex == 0) {
        UIImage *nextImage = self.imageArray[self.currentIndex+1];
        self.nextImageView.image = nextImage;
    }
    else if (self.currentIndex == self.imageArray.count-1) {
        UIImage *prevImage = self.imageArray[self.currentIndex-1];
        self.nextImageView.image = prevImage;
    }
    else {
        UIImage *nextImage = self.imageArray[self.currentIndex+1];
        self.nextImageView.image = nextImage;
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.currentIndex >= 0 && self.currentIndex < self.imageArray.count) {
                UIImage *currentImage = self.imageArray[self.currentIndex];
                self.currentLeftImage = [currentImage croppedImage:CGRectMake(0, 0, currentImage.size.width*.5f, currentImage.size.height)];
                self.currentRightImage = [currentImage croppedImage:CGRectMake(currentImage.size.width*.5f, 0, currentImage.size.width*.5f, currentImage.size.height)];
            }
            if (self.currentIndex < self.imageArray.count-1) {
                UIImage *nextImage = self.imageArray[self.currentIndex+1];
                self.nextLeftImage = [nextImage croppedImage:CGRectMake(0, 0, nextImage.size.width*.5f, nextImage.size.height)];
                self.nextLeftImage = [UIImage imageWithCGImage:self.nextLeftImage.CGImage scale:self.nextLeftImage.scale orientation:UIImageOrientationUpMirrored];
            }
            if (self.currentIndex > 0) {
                UIImage *prevImage = self.imageArray[self.currentIndex-1];
                self.prevRightImage = [prevImage croppedImage:CGRectMake(prevImage.size.width*.5f, 0, prevImage.size.width*.5f, prevImage.size.height)];
                self.prevRightImage = [UIImage imageWithCGImage:self.prevRightImage.CGImage scale:self.prevRightImage.scale orientation:UIImageOrientationUpMirrored];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            self.distance = [gesture translationInView:self.view].x;
            [self updateOverlay:self.distance];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.shapeLayer removeFromSuperlayer];
            [self followUpActionWithDistance:self.distance
                                    velocity:[gesture velocityInView:self.view]];
            break;
        }
            
        default:
            break;
    }
}

- (void)updateOverlay:(CGFloat)distance {
    CGFloat ratio = fabs(distance)/(self.screenWidth*.5f);
    CATransform3D transform = CATransform3DIdentity;
    CGFloat angle = ratio*M_PI_2;
    if (distance < 0) {
        //left
        if (self.currentIndex < self.imageArray.count-1) {
            UIImage *nextImage = self.imageArray[self.currentIndex+1];
            UIColor *color = nil;
            if (ratio > 1) {
                self.rightImageView.image = self.nextLeftImage;
                color = [UIColor colorWithWhite:0 alpha:(ratio-1)*.3f];
            }
            else {
                self.rightImageView.image = self.currentRightImage;
                color = [UIColor colorWithWhite:1 alpha:ratio*.3f];
            }
            [self.view bringSubviewToFront:self.rightContainerView];
            self.nextImageView.image = nextImage;
            self.rightImageView.layer.transform = CATransform3DRotate(transform, angle, 0, 1, 0);
            [self.shapeLayer removeFromSuperlayer];
            [self.rightImageView.layer addSublayer:self.shapeLayer];
            self.shapeLayer.frame = self.rightImageView.bounds;
            self.shapeLayer.backgroundColor = color.CGColor;
        }
    }
    else {
        if (self.currentIndex > 0) {
            UIImage *prevImage = self.imageArray[self.currentIndex-1];
            UIColor *color = nil;
            if (ratio > 1) {
                self.leftImageView.image = self.prevRightImage;
                color = [UIColor colorWithWhite:1 alpha:(2-ratio)*.3f];
            }
            else {
                self.leftImageView.image = self.currentLeftImage;
                color = [UIColor colorWithWhite:0 alpha:ratio*.3f];
            }
            [self.view bringSubviewToFront:self.leftContainerView];
            self.nextImageView.image = prevImage;
            self.leftImageView.layer.transform = CATransform3DRotate(transform, angle, 0, 1, 0);
            [self.shapeLayer removeFromSuperlayer];
            [self.leftImageView.layer addSublayer:self.shapeLayer];
            self.shapeLayer.frame = self.leftImageView.bounds;
            self.shapeLayer.backgroundColor = color.CGColor;
        }
    }
}

- (void)followUpActionWithDistance:(CGFloat)distance velocity:(CGPoint)velocity {
    self.panGesture.enabled = NO;
    CGFloat ratio = fabs(distance)/(self.screenWidth*.5f);
    if (fabs(distance) < self.screenWidth*.3f) {
        CGFloat duration = .5f*(1-ratio);
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.leftImageView.layer.transform = CATransform3DIdentity;
            self.rightImageView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            self.panGesture.enabled = YES;
        }];
    }
    else {
        CATransform3D transform = CATransform3DIdentity;
        CGFloat angle = 2*M_PI_2;
        CGFloat duration = .5f*(2-ratio);
        if (distance < 0 && self.currentIndex < self.imageArray.count-1) {
            self.rightImageView.image = self.nextLeftImage;
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.rightImageView.layer.transform = CATransform3DRotate(transform, angle, 0, 1, 0);
            } completion:^(BOOL finished) {
                self.leftImageView.layer.transform = CATransform3DIdentity;
                self.rightImageView.layer.transform = CATransform3DIdentity;
                self.currentIndex ++;
                [self setupCurrentView];
                self.panGesture.enabled = YES;
            }];
        }
        else if (distance > 0 && self.currentIndex > 0){
            self.leftImageView.image = self.prevRightImage;
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.leftImageView.layer.transform = CATransform3DRotate(transform, angle, 0, 1, 0);
            } completion:^(BOOL finished) {
                self.leftImageView.layer.transform = CATransform3DIdentity;
                self.rightImageView.layer.transform = CATransform3DIdentity;
                self.currentIndex --;
                [self setupCurrentView];
                self.panGesture.enabled = YES;
            }];
        }
        else {
            self.panGesture.enabled = YES;
        }
    }
}

@end
