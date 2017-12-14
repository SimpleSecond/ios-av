//
//  WDLrcCell.m
//  wd-audio
//
//  Created by WangDongya on 2017/12/14.
//  Copyright © 2017年 example. All rights reserved.
//

#import "WDLrcCell.h"
#import "WDLrcLabel.h"
#import <Masonry/Masonry.h>

@implementation WDLrcCell

+(instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    WDLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WDLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 1.初始化XMGLrcLabel
        WDLrcLabel *lrcLabel = [[WDLrcLabel alloc] init];
        [self.contentView addSubview:lrcLabel];
        self.lrcLabel = lrcLabel;
        
        // 2.添加约束
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        lrcLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

@end
