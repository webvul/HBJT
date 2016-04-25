//
//  EJNewsTableViewCell.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/15.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJNewsTableViewCell.h"

@interface EJNewsTableViewCell()

@end

@implementation EJNewsTableViewCell

- (void)awakeFromNib
{
    if (self.laudButton!=nil) {
        [self.laudButton addTarget:self action:@selector(laudButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)laudButtonClcik:(UIButton *)btn
{
    self.laudButtonClick(btn.tag);
}

@end
