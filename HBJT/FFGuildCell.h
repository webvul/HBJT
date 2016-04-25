//
//  FFGuildCell.h
//  HBJT
//
//  Created by fanggao on 16/4/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFGuildCell : UITableViewCell

@property (nonatomic, strong) UILabel  * leftLabel ;
@property (nonatomic, strong) UILabel  * rightLabel ;

@property (nonatomic, strong) UIButton * detailButton ;

- (void)getCellHeight:(CGFloat)height ;

@end
