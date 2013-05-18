//
//  UIImage+PictureScale.h
//  Picture_zip
//
//  Created by qm on 13-4-22.
//  Copyright (c) 2013年 qm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PictureScale)

+(UIImage*)scaleToSize:(UIImage *)image size:(CGSize)aSize;
+(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
+(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

@end
