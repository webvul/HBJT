//
//  EJNewsPictureTableViewCell.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/15.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EJNewsPictureTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markNewImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (weak, nonatomic) IBOutlet UIButton *laudButton;
@property (weak, nonatomic) IBOutlet UILabel *laudLabel;

@property (nonatomic, copy) void (^laudButtonClick)(NSInteger index);

@end
