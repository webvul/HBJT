//
//  EJIndexViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/2.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJIndexViewModel.h"

@implementation EJIndexViewModel

- (void)modulate
{
    if (self.scrollView.contentOffset.x > self.scrollViewOffsetx*4.99) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollViewOffsetx*1.0, 0) animated:NO];
    }
    if (self.scrollView.contentOffset.x < self.scrollViewOffsetx*0.01) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollViewOffsetx*4.0, 0) animated:NO];
    }
    if ((self.scrollView.contentOffset.x < self.scrollViewOffsetx)||((self.scrollView.contentOffset.x >= self.scrollViewOffsetx*4) && (self.scrollView.contentOffset.x < self.scrollViewOffsetx*5))) {
        self.pageControl.currentPage = 3;
    }
    if ((self.scrollView.contentOffset.x >= self.scrollViewOffsetx*5)||((self.scrollView.contentOffset.x >= self.scrollViewOffsetx*1) && (self.scrollView.contentOffset.x < self.scrollViewOffsetx*2))) {
        self.pageControl.currentPage = 0;
    }
    if ((self.scrollView.contentOffset.x >= self.scrollViewOffsetx*2) && (self.scrollView.contentOffset.x < self.scrollViewOffsetx*3)) {
        self.pageControl.currentPage = 1;
    }
    if ((self.scrollView.contentOffset.x >= self.scrollViewOffsetx*3) && (self.scrollView.contentOffset.x < self.scrollViewOffsetx*4)) {
        self.pageControl.currentPage = 2;

}

@end
