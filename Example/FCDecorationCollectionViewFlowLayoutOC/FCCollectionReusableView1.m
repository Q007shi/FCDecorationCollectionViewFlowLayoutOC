//
//  FCCollectionReusableView1.m
//  FCDecorationCollectionViewFlowLayoutOC_Example
//
//  Created by 石富才 on 2020/8/13.
//  Copyright © 2020 2585299617@qq.com. All rights reserved.
//

#import "FCCollectionReusableView1.h"


@implementation FCCollectionReusableView1

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        
        self.layer.cornerRadius = 50;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
