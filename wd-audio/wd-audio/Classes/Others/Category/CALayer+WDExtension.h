//
//  CALayer+WDExtension.h
//  wd-audio
//
//  Created by WangDongya on 2017/12/13.
//  Copyright © 2017年 example. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (WDExtension)

// 暂停动画
- (void)pauseAnimate;

// 恢复动画
- (void)resumeAnimate;

@end
