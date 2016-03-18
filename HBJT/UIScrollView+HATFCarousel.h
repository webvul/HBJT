//
//  UIScrollView+HATFCarousel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/16.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HATFCarousel)

@property (assign, readonly, nonatomic) NSInteger indexOfCurrentHorse;

@property (assign, readonly, nonatomic) CGFloat lastObservedRelativeContentOffset;
/**
 *  实现轮转效果。
 *
 *  @param numberOfHorses 要显示的轮转页数量。
 */
- (void)buildCarousel:(NSInteger)numberOfHorses previousBlock:(void (^)(NSInteger index))previousBlock nextBlock:(void (^)(NSInteger index))nextBlock;

@end
