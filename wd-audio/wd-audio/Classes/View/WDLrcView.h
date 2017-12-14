//
//  WDLrcView.h
//  wd-audio
//
//  Created by WangDongya on 2017/12/14.
//  Copyright © 2017年 example. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDLrcLabel;
@interface WDLrcView : UIScrollView

// 歌词名
@property (nonatomic, copy) NSString *lrcName;
/** 当前播放器播放的时间 */
@property (nonatomic, assign) NSTimeInterval currentTime;
/** 主界面歌词的Lable */
@property (nonatomic, weak) WDLrcLabel *lrcLabel;
/** 当前播放器总时间时间 */
@property (nonatomic, assign) NSTimeInterval duration;

@end
