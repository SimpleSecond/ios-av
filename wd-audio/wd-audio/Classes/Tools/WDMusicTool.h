//
//  WDMusicTool.h
//  wd-audio
//
//  Created by WangDongya on 2017/12/13.
//  Copyright © 2017年 example. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDMusic;
@interface WDMusicTool : NSObject

// 所有音乐
+ (NSArray *)musics;

// 当前播放的音乐
+ (WDMusic *)playingMusic;

// 设置默认的音乐
+ (void)setupPlayingMusic:(WDMusic *)playingMusic;

// 返回上一首音乐
+ (WDMusic *)preMusic;

// 返回下一首音乐
+ (WDMusic *)nextMusic;

@end
