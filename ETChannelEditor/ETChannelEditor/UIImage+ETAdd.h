//
//  UIImage+ETAdd.h
//  ETChannelEditor
//
//  Created by Jian on 2018/12/29.
//  Copyright © 2018 Oscar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ETAdd)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;
@end

NS_ASSUME_NONNULL_END
