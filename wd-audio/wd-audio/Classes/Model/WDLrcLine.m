//
//  WDLrcLine.m
//  wd-audio
//
//  Created by WangDongya on 2017/12/13.
//  Copyright © 2017年 example. All rights reserved.
//

#import "WDLrcLine.h"

@implementation WDLrcLine

- (instancetype)initWithLrcLineString:(NSString *)lrcLineString
{
    if (self = [super init]) {
        // [00:42.00]这晚以后音讯隔绝
        NSArray *lrcArray = [lrcLineString componentsSeparatedByString:@"]"];
        self.text = lrcArray[1];
        self.time = [self timeWithString:[lrcArray[0] substringFromIndex:1]];
    }
    return self;
}

+ (instancetype)LrcLineString:(NSString *)lrcLineString
{
    return [[self alloc] initWithLrcLineString:lrcLineString];
}

- (NSTimeInterval)timeWithString:(NSString *)timeString
{
    // 00:42.00
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger sec = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger hs = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    return min*60 + sec + hs*0.01;
}

@end
