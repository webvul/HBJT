//
//  FTViewModel.h
//  FTools
//
//  Created by 方秋鸣 on 16/2/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTAPIManager.h"

@interface FTViewModel : NSObject

+ (nonnull instancetype)viewModel;
- (void)startWithSender:(nullable id)sender;
- (void)modulate;
- (void)didReceiveMemoryWarning;

@end
