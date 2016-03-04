//
//  FFWVerificationTool.h
//  hbjt
//
//  Created by 方秋鸣 on 16/1/27.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTVerifier : NSObject

+ (BOOL)verify:(NSString *)string withRegex:(NSString *)regex;
+ (BOOL)validIDNumberText:(NSString *)string;

@end
