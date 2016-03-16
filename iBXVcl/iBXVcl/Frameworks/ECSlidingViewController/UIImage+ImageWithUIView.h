//
//  UIImage+ImageWithUIView.h
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (ImageWithUIView)

+ (UIImage *)imageWithUIView:(UIView *)view;
+ (UIImage *)imageWithAllUIView:(UIView *)view;
+ (UIImage*)imageFromView:(UIView *)view;

@end