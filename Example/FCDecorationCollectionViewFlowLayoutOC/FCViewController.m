//
//  FCViewController.m
//  FCDecorationCollectionViewFlowLayoutOC
//
//  Created by 2585299617@qq.com on 08/13/2020.
//  Copyright (c) 2020 2585299617@qq.com. All rights reserved.
//

#import "FCViewController.h"
#import <FCDecorationCollectionViewFlowLayoutOC/FCDecorationCollectionViewFlowLayout.h>
#import "FCCollectionReusableView1.h"
#import "FCCollectionReusableView2.h"
#import <Masonry/Masonry.h>

@interface FCViewController ()<UICollectionViewDataSource,FCDecorationCollectionViewFlowLayoutDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet FCDecorationCollectionViewFlowLayout *flowLayout;

@end

@implementation FCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"aa"];
    
    self.flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
    self.flowLayout.estimatedItemSize = CGSizeMake(100, 100);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(50, 20, 10, 20);
    self.flowLayout.decorationViewDelegate = self;
    self.flowLayout.minimumLineSpacing = 5;
    self.flowLayout.minimumInteritemSpacing = 0;
    
    [self.flowLayout registerClass:FCCollectionReusableView1.class forDecorationViewOfKind:NSStringFromClass(FCCollectionReusableView1.class)];
    [self.flowLayout registerClass:FCCollectionReusableView2.class forDecorationViewOfKind:NSStringFromClass(FCCollectionReusableView2.class)];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 30;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 13;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"aa" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    UILabel *label = [cell.contentView viewWithTag:101];
    if (!label) {
        label = UILabel.new;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = UIColor.redColor;
        label.tag = 101;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(indexPath.row * 5, indexPath.row * 10, indexPath.row * 15, indexPath.row * 20));
        }];
    }
    label.text = [NSString stringWithFormat:@"%ld - %ld",indexPath.section,indexPath.row];
    
    return cell;
}


#pragma mark - FCDecorationCollectionViewFlowLayoutDelegate
- (NSArray<FCDecorationViewMsgModel *> *)collectionView:(UICollectionView *)collectionview layout:(FCDecorationCollectionViewFlowLayout *)layout decorationViewMsgForSection:(NSInteger)section{
    if (section % 2 == 0) {
        
        FCDecorationViewMsgModel *backM = FCDecorationViewMsgModel.new;
        backM.reuseIdentifier = NSStringFromClass(FCCollectionReusableView1.class);
        backM.decorationViewLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass(FCCollectionReusableView1.class) withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        backM.decorationViewLayoutAttributes.zIndex = -1;
        backM.decorationViewEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(-30, -10, 10, -10)];
        
        
        FCDecorationViewMsgModel *backM2 = FCDecorationViewMsgModel.new;
        backM2.reuseIdentifier = NSStringFromClass(FCCollectionReusableView2.class);
        backM2.decorationViewLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass(FCCollectionReusableView2.class) withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        backM2.decorationViewLayoutAttributes.zIndex = 1;
        backM2.decorationViewEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(20, 20, 0, 0)];
        backM2.decorationViewSize = [NSValue valueWithCGSize:CGSizeMake(40, 40)];
        
        
        
        return @[backM,backM2];
        
    }
    return nil;
}

@end
