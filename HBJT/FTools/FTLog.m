//
//  FTLog.m
//  ftools
//
//  Created by 方秋鸣 on 16/2/18.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTLog.h"

CFAbsoluteTime markTime = 0;

/*@implementation FTLog

+ (void)log:(char *)file line:(int)line objects:(id)format, ...;
{
    va_list arglist;
    va_start(arglist,format);
    if ([format isKindOfClass:[NSString class]]) {
        NSString *output = [[NSString alloc]initWithFormat:format arguments:arglist];
        NSLog(@"%@(%d):%@",[[[NSString stringWithFormat:@"%s",file] componentsSeparatedByString:@"/"] lastObject],line,output);
    } else if (format == 0)
    {
        NSString *output = [[NSString alloc]init];
        id arg;
        while((arg = va_arg(arglist, id))) {
            output = [output stringByAppendingString:[NSString stringWithFormat:@"\n(%@) %@",[arg class],arg]];
        }
        va_end(arglist);
        NSLog(@"%@(%d):{%@\n}",[[[NSString stringWithFormat:@"%s",file] componentsSeparatedByString:@"/"] lastObject],line,output);
    } else
    {
        NSLog(@"FTLog Format Error");
    }
}

@end*/