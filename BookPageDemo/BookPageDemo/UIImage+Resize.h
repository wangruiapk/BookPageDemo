//
//  UIImage+Resize.h
//  CopyView
//
//  Created by 王锐 on 2019/2/27.
//  Copyright © 2019 wangrui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Resize)

- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)croppedImageWithTargetRatio:(CGFloat)targetRatio;

@end

NS_ASSUME_NONNULL_END
