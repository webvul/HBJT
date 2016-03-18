//
//  FTViewModel+EJSAPIManager.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/15.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTViewModel.h"
#import "EJSAPIManager.h"

@interface FTViewModel (EJSAPIManager)
- (RACSignal *)createSignalForAPIManager:(EJSAPIManager *)apiManager;
- (void)subscribeNetworkSignal:(RACSignal *)signal apiManger:(EJSAPIManager *)apiManager;
@end
