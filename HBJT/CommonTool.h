//
//  CommonTool.h
//  StudyDrive
//
//  Created by fanggao on 15/11/24.
//  Copyright © 2015年 fanggao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonTool : NSObject

//计算文本需要显示的尺寸
+(CGRect)getHeightWithText:(NSString *)text AndWidth:(CGFloat)width AndFont:(UIFont *)font ;

@end
