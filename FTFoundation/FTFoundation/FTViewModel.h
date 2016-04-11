//
//  FTViewModel.h
//  FTools
//
//  Created by 方秋鸣 on 16/2/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTAPIManager.h"
#import "FTools.h"

@interface FTViewModel : NSObject

@property (assign, nonatomic) BOOL isConnected;
@property (assign, nonatomic) BOOL isNetworkProceed;
@property (strong, nonatomic, nullable) NSString *networkHintText;
@property (strong, nonatomic, nullable) RACSignal *networkHintSignal;

+ (nonnull instancetype)viewModel;
/**
 *  约定如何处理来自View Controller的输入并制作输出信号。
 */
- (void)autoStart;
/**
 *  接受输入;
 */
- (void)connect;
/**
 *  屏蔽输出;
 */
- (void)disconnect;
/**
 *  停止所有在进行的任务，做好被释放的准备;
 */
- (void)stop;
- (void)start;

@end
