//
//  WXMScanBottomView.m
//  ModuleDebugging
//
//  Created by edz on 2019/5/5.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "WXMScanBottomView.h"

@implementation WXMScanBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) [self initializationInterface];
    return self;
}

- (void)initializationInterface {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
}
@end
