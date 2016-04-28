//
//  ResultTableViewCell.m
//  HBJT
//
//  Created by 方秋鸣 on 16/4/21.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJGuildResultTableViewCell.h"

@interface EJGuildResultTableViewCell ()

@end

@implementation EJGuildResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.resultLabel.layer.cornerRadius = 5.0f;
    self.resultLabel.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
