//
//  WDLrcTool.m
//  wd-audio
//
//  Created by WangDongya on 2017/12/13.
//  Copyright © 2017年 example. All rights reserved.
//

#import "WDLrcTool.h"
#import "WDLrcLine.h"

@implementation WDLrcTool

+ (NSArray *)lrcToolWithLrcName:(NSString *)lrcName
{
    // 1. 获取路径
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    // 2. 获取歌词
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 3. 转化成歌词数组
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lrcLineString in lrcArray) {
        // 4. 过滤不需要的字符串
        if ([lrcLineString hasPrefix:@"[ti:"] ||
            [lrcLineString hasPrefix:@"[ar:"] ||
            [lrcLineString hasPrefix:@"[al:"] ||
            ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        // 5. 将歌词转化成模型
        WDLrcLine *lrcLine = [WDLrcLine LrcLineString:lrcLineString];
        [tempArray addObject:lrcLine];
    }
    return tempArray;
}

@end
