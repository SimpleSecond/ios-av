//
//  NSString+WDExtension.m
//  wd-audio
//
//  Created by WangDongya on 2017/12/13.
//  Copyright © 2017年 example. All rights reserved.
//

#import "NSString+WDExtension.h"

@implementation NSString (WDExtension)

+ (NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger min = time / 60;
    NSInteger sec = (int)round(time) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}

@end
