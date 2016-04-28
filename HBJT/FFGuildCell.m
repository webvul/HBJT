//
//  FFGuildCell.m
//  HBJT
//
//  Created by fanggao on 16/4/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FFGuildCell.h"
#import "Masonry.h"
//获取屏幕宽度
#define FFScreenWidth [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define FFScreenHeight [UIScreen mainScreen].bounds.size.height
//获取颜色的RGB
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
@implementation FFGuildCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = 0 ;
        
        self.leftLabel = [[UILabel alloc]init];
        self.leftLabel.numberOfLines = 0 ;
        self.leftLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(10.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(90, 40));
        }];
        
        
        self.rightLabel = [[UILabel alloc]init];
        self.rightLabel.numberOfLines = 0 ;
        self.rightLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right).with.offset(10.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(FFScreenWidth-140, 20));
        }];
        
        
//        self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.detailButton setTitle:@"点击查看详情" forState:UIControlStateNormal];
//        [self.detailButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        self.detailButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        [self.contentView addSubview:self.detailButton];
//        [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.leftLabel.mas_right).with.offset(10.0f);
//            make.centerY.equalTo(self.contentView.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(80, 20));
//        }];
        
        
        UIView  *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGB(229, 229, 229);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rightLabel.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(FFScreenWidth-140, 1));
        }];
    }
    return self ;
}


- (void)getCellHeight:(CGFloat)height
{
    [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right).with.offset(10.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(FFScreenWidth-140, height));
    }];
}

@end
