//
//  WXMScanCenterrView.m
//  ModuleDebugging
//
//  Created by edz on 2019/5/5.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "WXMScanCenterView.h"
@interface WXMScanCenterView ()
@property (nonatomic, strong) UIImageView *animationImage;
@end

@implementation WXMScanCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializationInterface];
        [self baseInterfaceSetup];
        [self moveImageAnimations];
    }
    return self;
}

- (void)initializationInterface {
    
    /** 四个角和线条 */
    [self.array enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        CGFloat wh = 20;
        CGFloat x = (idx % 2 == 1)  ? (self.frame.size.width - wh) : 0;
        CGFloat y = (idx >= 2) ? (self.frame.size.height - wh) : 0;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
        imgView.image = [UIImage imageNamed:obj];
       
        //24和13坐标
        CGFloat linew = (idx % 2 == 1) ? 0.5 : self.frame.size.width - wh * 2;
        CGFloat lineh = (idx % 2 == 1) ? (self.frame.size.width - wh * 2) : 0.5;
        CGFloat linex = (idx % 2 == 1) ? 0.25 :wh;
        CGFloat liney = (idx % 2 == 1) ? wh : 0.25;
        if (idx == 2) liney = self.frame.size.height - lineh - liney;
        if (idx == 3) linex = self.frame.size.width - linew - linex;
        
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(linex, liney, linew, lineh);
        line.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:line];
        [self addSubview:imgView];
    }];
}

- (void)moveImageAnimations {
    _animationImage = [[UIImageView alloc] initWithFrame:self.bounds];
    _animationImage.alpha = 0.8;
    _animationImage.userInteractionEnabled = NO;
    _animationImage.image = [UIImage imageNamed:@"scan_net"];
    [self addSubview:_animationImage];
    
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath = @"transform.translation.y";
    scanNetAnimation.fromValue = @(-_animationImage.frame.size.height);
    scanNetAnimation.toValue = @(0);
    scanNetAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scanNetAnimation.duration = 2.2;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"opacity";
    animation.fromValue = @(1);
    animation.toValue = @(0);
    animation.duration = 0.25;
    animation.beginTime = scanNetAnimation.duration - 0.15;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.duration = scanNetAnimation.duration + animation.duration - 0.15;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.repeatCount = MAXFLOAT;
    group.animations = @[scanNetAnimation, animation];
    [_animationImage.layer addAnimation:group forKey:nil];
}

/** 基本设置 */
- (void)baseInterfaceSetup {
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.layer.masksToBounds = YES;
}

- (void)reductionOld {
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:nil];
}

- (NSArray *)array {
    return @[@"qr_top_left",@"qr_top_right",@"qr_bottom_left",@"qr_bottom_right"];
}

@end
