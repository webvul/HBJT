//
//  EJNewsTableViewCell.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/15.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EJNewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markNewImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (weak, nonatomic) IBOutlet UILabel *laudLabel;
@property (weak, nonatomic) IBOutlet UIButton *laudButton;

@property (nonatomic, copy) void (^laudButtonClick)(NSInteger index);

@end
