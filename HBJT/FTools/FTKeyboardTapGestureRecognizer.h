//
//  FTKeyboardTapGestureRecognizer.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/7.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTKeyboardTapGestureRecognizer : UITapGestureRecognizer <UIGestureRecognizerDelegate>

+ (void)addRecognizerFor:(UIView *)view;
+ (instancetype)recognizer;

@end
