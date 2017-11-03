//
//  UIWindow+K9Guide.m
//  GetZ
//
//  Created by K999999999 on 2017/11/2.
//  Copyright © 2017年 K999999999. All rights reserved.
//

#import "UIWindow+K9Guide.h"
#import <objc/runtime.h>

static char K9_WINDOW_GUIDE;

@interface K9WindowGuideView : UIView

@property (nonatomic, strong)   NSString                *guide;
@property (nonatomic)           CGRect                  forRect;
@property (nonatomic)           CGFloat                 cornerRadius;
@property (nonatomic, strong)   K9WindowGuideStyle      *style;
@property (nonatomic, copy)     void                    (^tapBlock)(void);
@property (nonatomic, copy)     void                    (^orientationBlock)(void);

@property (nonatomic, strong)   UIBezierPath            *rectPath;
@property (nonatomic, strong)   CAShapeLayer            *guideLayer;
@property (nonatomic, strong)   UILabel                 *textLabel;
@property (nonatomic, strong)   UITapGestureRecognizer  *tapGesture;

@end

@implementation K9WindowGuideView

#pragma mark - Life Cycle

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self refreshUI];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.style.shouldInterceptEvent) {
        return YES;
    }
    if (![self.rectPath containsPoint:point]) {
        
        if (self.tapBlock) {
            self.tapBlock();
        }
        return NO;
    }
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action Methods

- (void)onTapGesture {
    
    if (self.tapBlock) {
        self.tapBlock();
    }
}

- (void)orientationDidChange {
    
    if (self.orientationBlock) {
        self.orientationBlock();
    }
}

#pragma mark - Private Methods

- (void)refreshUI {
    
    self.backgroundColor = self.style.coverColor;
    if (!self.guideLayer.superlayer) {
        [self.layer addSublayer:self.guideLayer];
    }
    if (!self.textLabel.superview) {
        [self addSubview:self.textLabel];
    }
    if (![self.gestureRecognizers containsObject:self.tapGesture]) {
        [self addGestureRecognizer:self.tapGesture];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self refreshMask];
    [self refreshLayout];
}

- (void)refreshMask {
    
    self.rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(0.f, 0.f, self.window.bounds.size.width, self.window.bounds.size.height)];
    [self.rectPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:self.forRect cornerRadius:self.cornerRadius] bezierPathByReversingPath]];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = self.rectPath.CGPath;
    self.layer.mask = mask;
}

- (void)refreshLayout {
    
    BOOL underRect = YES;
    if (CGRectGetMidY(self.forRect) > self.window.bounds.size.height * .5f) {
        underRect = NO;
    }
    CGFloat textMaxHeight = underRect ? (self.window.bounds.size.height - CGRectGetMaxY(self.forRect) - 10.f - self.style.textInsets.top - self.style.textInsets.bottom - self.style.guideSpacing) : (CGRectGetMinY(self.forRect) - 10.f - self.style.textInsets.top - self.style.textInsets.bottom - self.style.guideSpacing);
    CGFloat guideWidth = self.style.guideWidth;
    CGFloat textWidth = guideWidth - self.style.textInsets.left - self.style.textInsets.right;
    CGFloat textHeight = MIN(textMaxHeight, [self.guide boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.style.textFont} context:nil].size.height);
    CGFloat guideRectHeight = self.style.textInsets.top + self.style.textInsets.bottom + textHeight;
    CGFloat guideHeight = guideRectHeight + 6.f;
    CGFloat y = underRect ? (CGRectGetMaxY(self.forRect) + 4.f) : (CGRectGetMinY(self.forRect) - 4.f - guideHeight);
    CGFloat x = CGRectGetMidX(self.forRect) - guideWidth * .5f;
    if (self.window.bounds.size.width - CGRectGetMidX(self.forRect) < guideWidth * .5f) {
        x = self.window.bounds.size.width - self.style.guideSpacing - guideWidth;
    } else if (CGRectGetMidX(self.forRect) < guideWidth * .5f) {
        x = self.style.guideSpacing;
    }
    CGFloat arrowMidX = CGRectGetMidX(self.forRect) - x;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.f, underRect ? 6.f : 0.f, guideWidth, guideRectHeight) cornerRadius:self.style.guideCornerRadius];
    [path moveToPoint:CGPointMake(arrowMidX - 6.f, underRect ? 6.f : guideRectHeight)];
    [path addLineToPoint:CGPointMake(arrowMidX, underRect ? 0.f : guideHeight)];
    [path addLineToPoint:CGPointMake(arrowMidX + 6.f, underRect ? 6.f : guideRectHeight)];
    self.guideLayer.path = path.CGPath;
    self.guideLayer.frame = CGRectMake(x, y, guideWidth, guideHeight);
    self.textLabel.frame = CGRectMake(x + self.style.textInsets.left, underRect ? (y + 6.f + self.style.textInsets.top) : (y + self.style.textInsets.top), textWidth, textHeight);
}

#pragma mark - Getters

- (CAShapeLayer *)guideLayer {
    
    if (!_guideLayer) {
        
        _guideLayer = [CAShapeLayer layer];
        _guideLayer.fillColor = self.style.guideColor.CGColor;
        if (self.style.showShadow) {
            
            _guideLayer.shadowColor = self.style.shadowColor.CGColor;
            _guideLayer.shadowOffset = self.style.shadowOffset;
            _guideLayer.shadowRadius = self.style.shadowRadius;
            _guideLayer.shadowOpacity = self.style.shadowOpacity;
        }
    }
    return _guideLayer;
}

- (UILabel *)textLabel {
    
    if (!_textLabel) {
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = self.style.textColor;
        _textLabel.font = self.style.textFont;
        _textLabel.textAlignment = self.style.textAlignment;
        _textLabel.numberOfLines = 0;
        _textLabel.text = self.guide;
    }
    return _textLabel;
}

- (UITapGestureRecognizer *)tapGesture {
    
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)];
    }
    return _tapGesture;
}

@end

@implementation UIWindow (K9Guide)

#pragma mark - Public Methods

- (void)k9_showGuide:(NSString *)guide
             forView:(UIView *)forView {
    
    [self k9_showGuide:guide
               forView:forView
          dismissBlock:nil];
}

- (void)k9_showGuide:(NSString *)guide
             forView:(UIView *)forView
        dismissBlock:(void(^)(void))dismissBlock {
    
    [self k9_showGuide:guide
               forView:forView
          dismissBlock:dismissBlock
                 style:[K9WindowGuideStyle shareStyle]];
}

- (void)k9_showGuide:(NSString *)guide
             forView:(UIView *)forView
        dismissBlock:(void(^)(void))dismissBlock
               style:(K9WindowGuideStyle *)style {
    
    CGRect forRect = [self convertRect:forView.frame fromView:forView.superview];
    __weak typeof(self)weakSelf = self;
    [self k9_showGuide:guide
               forRect:forRect
          cornerRadius:forView.layer.cornerRadius
      orientationBlock:^CGRect{
          
          __strong typeof(weakSelf)self = weakSelf;
          CGRect newRect = [self convertRect:forView.frame fromView:forView.superview];
          return newRect;
      } dismissBlock:dismissBlock
                 style:style];
}

- (void)k9_showGuide:(NSString *)guide
             forRect:(CGRect)forRect
        cornerRadius:(CGFloat)cornerRadius {
    
    [self k9_showGuide:guide
               forRect:forRect
          cornerRadius:cornerRadius
      orientationBlock:nil];
}

- (void)k9_showGuide:(NSString *)guide
             forRect:(CGRect)forRect
        cornerRadius:(CGFloat)cornerRadius
    orientationBlock:(CGRect(^)(void))orientationBlock {
    
    [self k9_showGuide:guide
               forRect:forRect
          cornerRadius:cornerRadius
      orientationBlock:orientationBlock
          dismissBlock:nil];
}

- (void)k9_showGuide:(NSString *)guide
             forRect:(CGRect)forRect
        cornerRadius:(CGFloat)cornerRadius
    orientationBlock:(CGRect(^)(void))orientationBlock
        dismissBlock:(void(^)(void))dismissBlock {
    
    [self k9_showGuide:guide
               forRect:forRect
          cornerRadius:cornerRadius
      orientationBlock:orientationBlock
          dismissBlock:dismissBlock
                 style:[K9WindowGuideStyle shareStyle]];
}

- (void)k9_showGuide:(NSString *)guide
             forRect:(CGRect)forRect
        cornerRadius:(CGFloat)cornerRadius
    orientationBlock:(CGRect(^)(void))orientationBlock
        dismissBlock:(void(^)(void))dismissBlock
               style:(K9WindowGuideStyle *)style {
    
    K9WindowGuideView *oldGuide = [self k9_guideView];
    if (oldGuide) {
        
        [oldGuide removeFromSuperview];
        objc_setAssociatedObject(self, &K9_WINDOW_GUIDE, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    K9WindowGuideView *guideView = [[K9WindowGuideView alloc] init];
    guideView.guide = guide;
    guideView.forRect = forRect;
    guideView.cornerRadius = cornerRadius;
    guideView.style = style;
    __weak typeof(self)weakSelf = self;
    guideView.tapBlock = ^{
        
        __strong typeof(weakSelf)self = weakSelf;
        K9WindowGuideView *view = [self k9_guideView];
        if (view) {
            
            [view removeFromSuperview];
            objc_setAssociatedObject(self, &K9_WINDOW_GUIDE, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (dismissBlock) {
                dismissBlock();
            }
        });
    };
    guideView.orientationBlock = ^{
        
        __strong typeof(weakSelf)self = weakSelf;
        K9WindowGuideView *view = [self k9_guideView];
        if (view) {
            
            if (orientationBlock) {
                view.forRect = orientationBlock();
            }
            view.frame = self.bounds;
        }
    };
    guideView.frame = self.bounds;
    [self addSubview:guideView];
    objc_setAssociatedObject(self, &K9_WINDOW_GUIDE, guideView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)k9_isShowingGuide {
    return (nil != [self k9_guideView].superview);
}

#pragma mark - Private Methods

- (K9WindowGuideView *)k9_guideView {
    return (K9WindowGuideView *)objc_getAssociatedObject(self, &K9_WINDOW_GUIDE);
}

@end

@implementation K9WindowGuideStyle

#pragma mark - Life Cycle

- (instancetype)initWithDefaultStyle {
    
    self = [super init];
    if (self) {
        
        _shouldInterceptEvent = NO;
        
        _coverColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        
        _guideColor = [UIColor colorWithRed:1.f green:.6f blue:0.f alpha:1.f];
        _guideWidth = 130.f;
        _guideSpacing = 10.f;
        _guideCornerRadius = 8.f;
        
        _textColor = [UIColor whiteColor];
        _textFont = [UIFont systemFontOfSize:12.f];
        _textAlignment = NSTextAlignmentLeft;
        _textInsets = UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
        
        _showShadow = YES;
        _shadowColor = [UIColor blackColor];
        _shadowOffset = CGSizeMake(0.f, 4.f);
        _shadowRadius = 8.f;
        _shadowOpacity = .29f;
    }
    return self;
}

+ (instancetype)shareStyle {
    
    static dispatch_once_t onceToken;
    static K9WindowGuideStyle *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] initWithDefaultStyle];
    });
    return instance;
}

- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

+ (instancetype)new NS_UNAVAILABLE {
    return nil;
}

@end
