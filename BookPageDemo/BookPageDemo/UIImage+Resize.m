//
//  UIImage+Resize.m
//  CopyView
//
//  Created by 王锐 on 2019/2/27.
//  Copyright © 2019 wangrui. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIImage *retImage = croppedImage;
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    if (alphaInfo == kCGImageAlphaNoneSkipLast || alphaInfo == kCGImageAlphaNoneSkipFirst ) {
        NSData *data = UIImageJPEGRepresentation(croppedImage, .7f);
        if (data) {
            retImage = [UIImage imageWithData:data];
        }
    }
    return retImage;
}

- (UIImage *)croppedImageWithTargetRatio:(CGFloat)targetRatio
{
    CGFloat imgWidth = self.size.width;
    CGFloat imgHeight = self.size.height;
    CGFloat imgRatio = 1;
    if (imgWidth*imgHeight > 0) {
        imgRatio = imgWidth/imgHeight;
    }
    CGRect rect = CGRectMake(0, (imgHeight-imgHeight/targetRatio)*.5f, imgWidth, imgHeight/targetRatio);
    if (imgRatio < targetRatio) {
        rect = CGRectMake((imgWidth-imgHeight*targetRatio)*.5f, 0, imgHeight*targetRatio, imgHeight);
    }
    UIImage *retImage = [self croppedImage:rect];
    return retImage;
}

@end
