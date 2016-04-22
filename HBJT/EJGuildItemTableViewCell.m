//
//  EJGuildItemTableViewCell.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJGuildItemTableViewCell.h"
#import "Masonry.h"
//获取屏幕宽度
#define FFScreenWidth [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define FFScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation EJGuildItemTableViewCell

- (void)awakeFromNib {
    
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(20.0f);
        make.right.equalTo(self.contentView.mas_right).with.offset(-20.0f);
        make.top.equalTo(self.contentView.mas_top).with.offset(10.0f);
    }];
    
    self.subLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5.0f);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
