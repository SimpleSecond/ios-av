//
//  WDAudioTool.h
//  wd-audio
//
//  Created by WangDongya on 2017/12/13.
//  Copyright © 2017年 example. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface WDAudioTool : NSObject

// 播放音乐 fileName: 音乐文件
+ (AVAudioPlayer *)playMusicWithFileName:(NSString *)fileName;
// 暂停音乐 fileName: 音乐文件
+ (void)pauseMusicWithFileName:(NSString *)fileName;
// 停止音乐 fileName: 音乐文件
+ (void)stopMusicWithFileName:(NSString *)fileName;
// 播放音效 soundName: 音效文件
+ (void)playSoundWithSoundName:(NSString *)soundName;


@end
