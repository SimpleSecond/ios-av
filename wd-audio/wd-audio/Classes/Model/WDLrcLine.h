//
//  WDLrcLine.h
//  wd-audio
//
//  Created by WangDongya on 2017/12/13.
//  Copyright © 2017年 example. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDLrcLine : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSTimeInterval time;


- (instancetype)initWithLrcLineString:(NSString *)lrcLineString;
+ (instancetype)LrcLineString:(NSString *)lrcLineString;

@end
