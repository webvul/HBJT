//
//  FTLog.h
//  ftools
//
//  Created by 方秋鸣 on 16/2/18.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//
#if DEBUG
#define NSLog(format, ...) \
do { \
NSLog(@"%@:%d %.2f [ %@ ]", \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
__LINE__, \
CFAbsoluteTimeGetCurrent() - markTime, \
[NSString stringWithFormat:format, ##__VA_ARGS__]); \
} while(0)
#else
#define NSLog(format, ...)
#endif

#import <Foundation/Foundation.h>

extern CFAbsoluteTime markTime;

/*
#define FTLog(FORMAT, ...) [FTLog log:__FILE__ line:__LINE__ objects:FORMAT, ##__VA_ARGS__]

@interface FTLog : NSObject

+ (void)log:(char *)file line:(int)line objects:(id)format, ...;

@end*/
