//
//  ViewController.m
//  K9WindowGuideDemo
//
//  Created by K999999999 on 2017/11/3.
//  Copyright © 2017年 K999999999. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "UIWindow+K9Guide.h"

@interface ViewController ()

@property (nonatomic, strong)   UILabel     *label1;
@property (nonatomic, strong)   UILabel     *label2;
@property (nonatomic, strong)   UILabel     *label3;

@property (nonatomic, strong)   UIButton    *button1;
@property (nonatomic, strong)   UIButton    *button2;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.label1 = [[UILabel alloc] init];
    self.label1.backgroundColor = [UIColor blackColor];
    self.label1.textColor = [UIColor whiteColor];
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.text = @"label 1";
    self.label1.clipsToBounds = YES;
    self.label1.layer.cornerRadius = 30.f;
    [self.view addSubview:self.label1];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).with.offset(60.f);
        make.left.equalTo(self.view).with.offset(20.f);
        make.width.height.mas_equalTo(60.f);
    }];
    
    self.label2 = [[UILabel alloc] init];
    self.label2.backgroundColor = [UIColor blackColor];
    self.label2.textColor = [UIColor whiteColor];
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.text = @"label 2";
    self.label2.clipsToBounds = YES;
    self.label2.layer.cornerRadius = 30.f;
    [self.view addSubview:self.label2];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).with.offset(80.f);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(60.f);
    }];
    
    self.label3 = [[UILabel alloc] init];
    self.label3.backgroundColor = [UIColor blackColor];
    self.label3.textColor = [UIColor whiteColor];
    self.label3.textAlignment = NSTextAlignmentCenter;
    self.label3.text = @"label 3";
    [self.view addSubview:self.label3];
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).with.offset(100.f);
        make.right.equalTo(self.view).with.offset(-20.f);
        make.width.height.mas_equalTo(60.f);
    }];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button1.backgroundColor = [UIColor redColor];
    [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button1 setTitle:@"button 1" forState:UIControlStateNormal];
    [self.button1 addTarget:self action:@selector(onButton1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button1];
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100.f, 40.f));
    }];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button2.backgroundColor = [UIColor blueColor];
    [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button2 setTitle:@"button 2" forState:UIControlStateNormal];
    self.button2.clipsToBounds = YES;
    self.button2.layer.cornerRadius = 20.f;
    [self.button2 addTarget:self action:@selector(onButton2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button2];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view).with.offset(-60.f);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100.f, 40.f));
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self showContinuousGuide];
}

#pragma mark - Action Methods

- (void)onButton1 {
    
    [self.view.window k9_showGuide:@"This button 2 guide ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                           forView:self.button2];
}

- (void)onButton2 {
    
    [self.view.window k9_showGuide:@"This button 1 guide ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                           forView:self.button1];
}

#pragma mark - Private Methods

- (void)showContinuousGuide {
    
    K9WindowGuideStyle *style = [[K9WindowGuideStyle alloc] initWithDefaultStyle];
    style.shouldInterceptEvent = YES;
    __weak typeof(self)weakSelf = self;
    [self.view.window k9_showGuide:@"This is label 1 ~~~~"
                           forView:self.label1
                      dismissBlock:^{
                          
                          __strong typeof(weakSelf)self = weakSelf;
                          CGRect forRect1 = [self.view.window convertRect:self.label2.frame fromView:self.label2.superview];
                          forRect1.origin.x -= 10.f;
                          forRect1.origin.y -= 10.f;
                          forRect1.size.width += 20.f;
                          forRect1.size.height += 20.f;
                          __weak typeof(self)weakSelf = self;
                          [self.view.window k9_showGuide:@"This is label 2 ~~~~~~~~~~~~~~"
                                                 forRect:forRect1
                                            cornerRadius:0.f
                                        orientationBlock:^CGRect{
                                            
                                            __strong typeof(weakSelf)self = weakSelf;
                                            CGRect forRect2 = [self.view.window convertRect:self.label2.frame fromView:self.label2.superview];
                                            forRect2.origin.x -= 10.f;
                                            forRect2.origin.y -= 10.f;
                                            forRect2.size.width += 20.f;
                                            forRect2.size.height += 20.f;
                                            return forRect2;
                                        } dismissBlock:^{
                                            
                                            __strong typeof(weakSelf)self = weakSelf;
                                            CGRect forRect3 = [self.view.window convertRect:self.label3.frame fromView:self.label3.superview];
                                            forRect3.origin.x -= 10.f;
                                            forRect3.origin.y -= 10.f;
                                            forRect3.size.width += 20.f;
                                            forRect3.size.height += 20.f;
                                            [self.view.window k9_showGuide:@"This is label 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                                                                   forRect:forRect3
                                                              cornerRadius:forRect3.size.width * .5f orientationBlock:^CGRect{
                                                                  
                                                                  CGRect forRect4 = [self.view.window convertRect:self.label3.frame fromView:self.label3.superview];
                                                                  forRect4.origin.x -= 10.f;
                                                                  forRect4.origin.y -= 10.f;
                                                                  forRect4.size.width += 20.f;
                                                                  forRect4.size.height += 20.f;
                                                                  return forRect4;
                                                              } dismissBlock:nil
                                                                     style:style];
                                        } style:style];
    } style:style];
}

@end
