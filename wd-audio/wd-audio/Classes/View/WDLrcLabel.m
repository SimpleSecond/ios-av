//
//  WDLrcLabel.m
//  wd-audio
//
//  Created by WangDongya on 2017/12/14.
//  Copyright © 2017年 example. All rights reserved.
//

#import "WDLrcLabel.h"

@implementation WDLrcLabel

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    [[UIColor greenColor] set];
    //    UIRectFill(fillRect);
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

@end
