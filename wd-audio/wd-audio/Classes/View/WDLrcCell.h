//
//  WDLrcCell.h
//  wd-audio
//
//  Created by WangDongya on 2017/12/14.
//  Copyright © 2017年 example. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDLrcLabel;
@interface WDLrcCell : UITableViewCell
@property (nonatomic, weak) WDLrcLabel *lrcLabel;

+(instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
