//
//  WDMusicTool.m
//  wd-audio
//
//  Created by WangDongya on 2017/12/13.
//  Copyright © 2017年 example. All rights reserved.
//

#import "WDMusicTool.h"
#import "WDMusic.h"
#import <MJExtension/MJExtension.h>

@implementation WDMusicTool

#pragma mark - 初始化
static NSArray *_musics;
static WDMusic *_playingMusic;

+(void)initialize
{
    if (_musics == nil) {
        _musics = [WDMusic mj_objectArrayWithFilename:@"Musics.plist"];
    }
    if (_playingMusic == nil) {
        _playingMusic = _musics[1];
    }
}

#pragma mark - 类方法
+(NSArray *)musics
{
    return _musics;
}
+(WDMusic *)playingMusic
{
    return _playingMusic;
}
+(void)setupPlayingMusic:(WDMusic *)playingMusic
{
    _playingMusic = playingMusic;
}
+(WDMusic *)preMusic
{
    // 1. 获取当前音乐的下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    // 2. 获取上一首音乐的下标值
    NSInteger previousIndex = --currentIndex;
    WDMusic *preMusic = nil;
    if (previousIndex < 0) {
        previousIndex = _musics.count - 1;
    }
    preMusic = _musics[previousIndex];
    return preMusic;
}
+(WDMusic *)nextMusic
{
    // 1. 获取当前音乐的下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    // 2. 获取下一首音乐的下标值
    NSInteger nextIndex = ++currentIndex;
    WDMusic *nextMusic = nil;
    if (nextIndex >= _musics.count) {
        nextIndex = 0;
    }
    nextMusic = _musics[nextIndex];
    return nextMusic;
}


@end
