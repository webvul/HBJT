//
//  CommonTool.m
//  StudyDrive
//
//  Created by fanggao on 15/11/24.
//  Copyright © 2015年 fanggao. All rights reserved.
//

#import "CommonTool.h"

@implementation CommonTool


//计算文本需要显示的尺寸
+(CGRect)getHeightWithText:(NSString *)text AndWidth:(CGFloat)width AndFont:(UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil];
    return rect ;
}



@end
