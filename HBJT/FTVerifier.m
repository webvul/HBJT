//
//  FFWVerificationTool.m
//  hbjt
//
//  Created by 方秋鸣 on 16/1/27.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTVerifier.h"

@implementation FTVerifier

+ (BOOL)verify:(NSString *)string withRegex:(NSString *)regex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicate evaluateWithObject:string];
}

+ (BOOL)validateIdentityCardNumberString:(NSString *)string
{
    if ([self verify:string withRegex:@"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$"]&&(string.length == 18)) {
        NSArray * idWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1",
                                @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        NSArray * idYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5",
                               @"4", @"3", @"2"];
        NSInteger idWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[string substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idWiIndex = [[idWiArray objectAtIndex:i] integerValue];
            idWiSum+= subStrIndex * idWiIndex;
        }
        NSInteger idMod=idWiSum%11;
        NSString * idLast= [string substringWithRange:NSMakeRange(17, 1)];
        return (idMod==2? ([idLast isEqualToString:@"X"]||[idLast isEqualToString:@"x"]):([idLast isEqualToString: [idYArray objectAtIndex:idMod]]));
    } else {
        return NO;
    }
}

@end
