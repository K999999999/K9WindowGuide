//
//  UIWindow+K9Guide.h
//  GetZ
//
//  Created by K999999999 on 2017/11/2.
//  Copyright © 2017年 K999999999. All rights reserved.
//

#import <UIKit/UIKit.h>

@class K9WindowGuideStyle;

@interface UIWindow (K9Guide)

- (void)k9_showGuide:(NSString *)guide
             forView:(UIView *)forView;

- (void)k9_showGuide:(NSString *)guide
             forView:(UIView *)forView
        dismissBlock:(void(^)(void))dismissBlock;

- (void)k9_showGuide:(NSString *)guide
             forView:(UIView *)forView
        dismissBlock:(void(^)(void))dismissBlock
               style:(K9WindowGuideStyle *)style;

- (void)k9_showGuide:(NSString *)guide
             forRect:(CGRect)forRect
        cornerRadius:(CGFloat)cornerRadius;

- (void)k9_showGuide:(NSString *)guide
             forRect:(CGRect)forRect
        cornerRadius:(CGFloat)cornerRadius
    orientationBlock:(CGRect(^)(void))orientationBlock;

- (void)k9_showGuide:(NSString *)guide
             forRect:(CGRect)forRect
        cornerRadius:(CGFloat)cornerRadius
    orientationBlock:(CGRect(^)(void))orientationBlock
        dismissBlock:(void(^)(void))dismissBlock;

- (void)k9_showGuide:(NSString *)guide
             forRect:(CGRect)forRect
        cornerRadius:(CGFloat)cornerRadius
    orientationBlock:(CGRect(^)(void))orientationBlock
        dismissBlock:(void(^)(void))dismissBlock
               style:(K9WindowGuideStyle *)style;

- (BOOL)k9_isShowingGuide;

- (void)k9_hideGuide;

@end

@interface K9WindowGuideStyle : NSObject

@property (nonatomic)           BOOL            shouldInterceptEvent;

@property (nonatomic, strong)   UIColor         *coverColor;

@property (nonatomic, strong)   UIColor         *guideColor;
@property (nonatomic)           CGFloat         guideWidth;
@property (nonatomic)           CGFloat         guideSpacing;
@property (nonatomic)           CGFloat         guideCornerRadius;

@property (nonatomic, strong)   UIColor         *textColor;
@property (nonatomic, strong)   UIFont          *textFont;
@property (nonatomic)           NSTextAlignment textAlignment;
@property (nonatomic)           UIEdgeInsets    textInsets;

@property (nonatomic)           BOOL            showShadow;
@property (nonatomic, strong)   UIColor         *shadowColor;
@property (nonatomic)           CGSize          shadowOffset;
@property (nonatomic)           CGFloat         shadowRadius;
@property (nonatomic)           CGFloat         shadowOpacity;

- (instancetype)initWithDefaultStyle NS_DESIGNATED_INITIALIZER;

+ (instancetype)shareStyle;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end
