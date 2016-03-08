//
//  FTDataAnalyzer.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/8.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FTDataAnalyzerStatus) {
    FTDataAnalyzerStatusOK = 0,
    FTDataAnalyzerStatusError =1,
    FTDataAnalyzerStatusUnknown =2
};

@interface FTDataAnalyzer : NSObject

@property (strong, nonatomic) NSDictionary *data;
@property (assign, nonatomic) FTDataAnalyzerStatus status;
@property (strong, nonatomic) NSString *responseDescription;

@end
