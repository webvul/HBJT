//
//  EJIndexViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/2.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTViewModel.h"

@interface EJIndexViewModel : FTViewModel

@property (assign, nonatomic) NSInteger numberOfPageInScrollView;
@property (assign, nonatomic) CGFloat scrollViewWidth;

//Receiver
@property (assign, nonatomic) CGFloat scrollViewOffset;
//Sender
@property (strong, nonatomic) RACSignal *pageIndicatorTintSignal;
@property (strong, nonatomic) RACSignal *scrollViewRotateSignal;

@end
