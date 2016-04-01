//
//  UIScrollView+HATFCarousel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/16.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//


#import "UIScrollView+HATFCarousel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <objc/runtime.h>

@implementation UIScrollView (HATFCarousel)

-(NSInteger)indexOfCurrentHorse
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

-(void)setIndexOfCurrentHorse:(NSInteger)indexOfCurrentHorse
{
    objc_setAssociatedObject(self, @selector(indexOfCurrentHorse), @(indexOfCurrentHorse), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)lastObservedRelativeContentOffset
{
    return (CGFloat)[objc_getAssociatedObject(self, _cmd) floatValue];
}

-(void)setLastObservedRelativeContentOffset:(CGFloat)lastObservedRelativeContentOffset
{
    objc_setAssociatedObject(self, @selector(lastObservedRelativeContentOffset), @(lastObservedRelativeContentOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)buildCarousel:(NSInteger)numberOfHorses previousBlock:(void (^)(NSInteger index))previousBlock nextBlock:(void (^)(NSInteger index))nextBlock
{
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    //self.directionalLockEnabled = YES;
    if (numberOfHorses > 0) {
        @weakify(self);
        [[[RACObserve(self, contentOffset) map:^id(id value) {
            @strongify(self);
            CGFloat relativeContentOffset = (self.contentOffset.x / self.frame.size.width);
            if (relativeContentOffset > NSIntegerMax - 1 && relativeContentOffset < NSIntegerMin + 1) {
                return nil;
            }
            if (relativeContentOffset <=0.01) {
                NSLog(@"previous");
                if (previousBlock) {
                    previousBlock(floor(relativeContentOffset));
                }
                
            }
            else if (relativeContentOffset >=1.99) {
                NSLog(@"next");
                if (nextBlock) {
                    nextBlock(ceil(relativeContentOffset));
                }
            }
            self.lastObservedRelativeContentOffset = relativeContentOffset;
            CGFloat modifiedRelativeContentOffset = (relativeContentOffset > numberOfHorses + 0.5? relativeContentOffset - numberOfHorses : (relativeContentOffset < 0.5? relativeContentOffset + numberOfHorses: relativeContentOffset));
            self.indexOfCurrentHorse = floor(modifiedRelativeContentOffset + 0.5);
            return (relativeContentOffset >= numberOfHorses + 0.99? @(1):(relativeContentOffset <= 0.01? @(numberOfHorses): nil));
        }] filter:^BOOL(id value) {
            return value;
        }] subscribeNext:^(id x) {
            @strongify(self);
            //NSLog(@"previous or next");
            //([x integerValue] == 1? (previousBlock? previousBlock(1): nil): (nextBlock? nextBlock(numberOfHorses): nil));
            [self setContentOffset:CGPointMake(self.frame.size.width * [x floatValue], 0) animated:NO];
            self.lastObservedRelativeContentOffset =  (self.contentOffset.x / self.frame.size.width);
            ;
        }];
    }
    else
    {
        NSLog(@"参数输入有误");
        [self buildCarousel:1 previousBlock:nil nextBlock:nil];
    }
}


@end
