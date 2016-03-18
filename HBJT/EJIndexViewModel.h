//
//  EJIndexViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/2.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJIndexViewModel : FTViewModel

//Receiver
@property (assign, nonatomic) NSInteger numberOfSrollViewPage;
@property (assign, nonatomic) NSNumber *scrollViewOffset;
//Sender
@property (strong, nonatomic) RACSignal *pageIndicatorTintSignal;
@property (strong, nonatomic) RACSignal *scrollViewRotateSignal;

@end
