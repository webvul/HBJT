//
//  FTLog.h
//  ftools
//
//  Created by 方秋鸣 on 16/2/18.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <Foundation/Foundation.h>
#define FTLog(FORMAT, ...) [FTLog log:__FILE__ line:__LINE__ objects:FORMAT, ##__VA_ARGS__]

@interface FTLog : NSObject

+ (void)log:(char *)file line:(int)line objects:(id)format, ...;

@end
