//
//  FCDecorationCollectionViewFlowLayout.m
//  FCDecorationCollectionViewFlowLayoutOC
//
//  Created by 石富才 on 2020/8/13.
//

#import "FCDecorationCollectionViewFlowLayout.h"

@interface FCDecorationCollectionViewFlowLayout ()

/** <#aaa#>  */
@property(nonatomic, strong)NSMutableDictionary *decorationMsgs;

@end

@implementation FCDecorationCollectionViewFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    //获取组数
    NSInteger sectionNum = self.collectionView.numberOfSections;
    if (sectionNum <= 0) {
        return;
    }
    //
    [self.decorationMsgs removeAllObjects];
    
    //
    id<UICollectionViewDelegateFlowLayout> delegateFlowLayout = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    
    //获取每个 section 中 DecorationView 的 frame
    for (NSInteger section = 0; section < sectionNum; section++) {
        NSInteger itemNum = [self.collectionView numberOfItemsInSection:section];
        if (!self.decorationViewDelegate || ![self.decorationViewDelegate respondsToSelector:@selector(collectionView:layout:decorationViewMsgForSection:)] || itemNum == 0) {
            continue;
        }
        
        NSArray<FCDecorationViewMsgModel *> *decorationMsgs = [self.decorationViewDelegate collectionView:self.collectionView layout:self decorationViewMsgForSection:section];
        if (decorationMsgs.count == 0) {
            continue;
        }
        
        UICollectionViewLayoutAttributes *firstItemLayoutAttri = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        UICollectionViewLayoutAttributes *lastItemLayoutAttri = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:itemNum - 1 inSection:section]];
        
        //获取当前 section 的边距
        UIEdgeInsets sectionInset = self.sectionInset;
        if ([delegateFlowLayout respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            sectionInset = [delegateFlowLayout collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        }
        
        //计算 DecorationView 的 frame
        CGRect sectionFrame = CGRectUnion(firstItemLayoutAttri.frame, lastItemLayoutAttri.frame);
        
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {//水平
            CGFloat x = sectionFrame.origin.x - sectionInset.left;
            CGFloat y = sectionInset.top;
            CGFloat w = sectionFrame.size.width + sectionInset.left + sectionInset.right;
            CGFloat h = self.collectionView.frame.size.height - sectionInset.top - sectionInset.bottom;
            sectionFrame = CGRectMake(x, y, w, h);
        }else{
            CGFloat x = sectionInset.left;
            CGFloat y = sectionFrame.origin.y - sectionInset.top;
            CGFloat w = self.collectionView.frame.size.width - sectionInset.left - sectionInset.right;
            CGFloat h = sectionFrame.size.height + sectionInset.top + sectionInset.bottom;
            sectionFrame = CGRectMake(x, y, w, h);
        }
        
        //
        NSMutableArray<UICollectionViewLayoutAttributes *> *sectionDecorationViewLayoutAttributes = NSMutableArray.array;
        for (FCDecorationViewMsgModel *model in decorationMsgs) {
            if (model.reuseIdentifier && model.decorationViewLayoutAttributes) {
                if (model.decorationViewEdgeInsets) {
                    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                        UIEdgeInsets decorationViewEdgeInsets = model.decorationViewEdgeInsets.UIEdgeInsetsValue;
                        CGFloat dx = sectionFrame.origin.x - decorationViewEdgeInsets.left;
                        CGFloat dy = sectionFrame.origin.y + decorationViewEdgeInsets.top;
                        CGFloat dw = sectionFrame.size.width + decorationViewEdgeInsets.left + decorationViewEdgeInsets.right;
                        CGFloat dh = sectionFrame.size.height - decorationViewEdgeInsets.top - decorationViewEdgeInsets.bottom;
                        sectionFrame = CGRectMake(dx, dy, dw, dh);
                    }else{
                        UIEdgeInsets decorationViewEdgeInsets = model.decorationViewEdgeInsets.UIEdgeInsetsValue;
                        CGFloat dx = sectionFrame.origin.x + decorationViewEdgeInsets.left;
                        CGFloat dy = sectionFrame.origin.y - decorationViewEdgeInsets.top;
                        CGFloat dw = sectionFrame.size.width - decorationViewEdgeInsets.left - decorationViewEdgeInsets.right;
                        CGFloat dh = sectionFrame.size.height + decorationViewEdgeInsets.top + decorationViewEdgeInsets.bottom;
                        sectionFrame = CGRectMake(dx, dy, dw, dh);
                    }
                    
                }
                if (model.decorationViewSize) {
                    CGSize decorationViewSize = model.decorationViewSize.CGSizeValue;
                    sectionFrame = CGRectMake(sectionFrame.origin.x, sectionFrame.origin.y, decorationViewSize.width, decorationViewSize.height);
                }
                model.decorationViewLayoutAttributes.frame = sectionFrame;
                [sectionDecorationViewLayoutAttributes addObject:model.decorationViewLayoutAttributes];
            }else{
                continue;
            }
        }
        self.decorationMsgs[@(section)] = sectionDecorationViewLayoutAttributes;
    }
}
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:arr];
    NSArray *decorationLayoutAttributeSet = self.decorationMsgs.allValues;
    
    for (NSArray *decorationLayoutAttributes in decorationLayoutAttributeSet) {
        for (UICollectionViewLayoutAttributes *layoutAttributes in decorationLayoutAttributes) {
            if (CGRectIntersectsRect(rect, layoutAttributes.frame)) {
                [mArr addObject:layoutAttributes];
            }
        }
    }
    return mArr;
}



- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    if (self.decorationViewDelegate && [self.decorationViewDelegate respondsToSelector:@selector(collectionView:layout:decorationViewMsgForSection:)]) {
        NSArray<FCDecorationViewMsgModel *> *decorationMsgs = [self.decorationViewDelegate collectionView:self.collectionView layout:self decorationViewMsgForSection:indexPath.section];
        for (FCDecorationViewMsgModel *msgM in decorationMsgs) {
            NSArray *decorationViewLayoutAttributes = self.decorationMsgs[@(indexPath.section)];
            for (UICollectionViewLayoutAttributes *layoutAttributes in decorationViewLayoutAttributes) {
                if ([layoutAttributes isEqual:msgM] && [elementKind isEqualToString:msgM.reuseIdentifier]) {
                    return layoutAttributes;
                }
            }
        }
    }
    
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}



#pragma mark - getter 方法
- (NSMutableDictionary *)decorationMsgs{
    if (!_decorationMsgs) {
        _decorationMsgs = NSMutableDictionary.dictionary;
    }
    return _decorationMsgs;
}

@end

@implementation FCDecorationViewMsgModel

@end

