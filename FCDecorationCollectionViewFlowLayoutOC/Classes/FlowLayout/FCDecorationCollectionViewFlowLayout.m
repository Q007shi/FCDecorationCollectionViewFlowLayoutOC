//
//  FCDecorationCollectionViewFlowLayout.m
//  FCDecorationCollectionViewFlowLayoutOC
//
//  Created by 石富才 on 2020/8/13.

//https://stackoverflow.com/questions/13017257/how-do-you-determine-spacing-between-cells-in-uicollectionview-flowlayout
//

#import "FCDecorationCollectionViewFlowLayout.h"

//================

@interface UICollectionViewLayoutAttributes (LeftAlign)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset;

@end

@implementation UICollectionViewLayoutAttributes (LeftAlign)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset
{
    CGRect frame = self.frame;
    frame.origin.x = sectionInset.left;
    self.frame = frame;
}

@end

//---------

//================

@interface UICollectionViewLayoutAttributes (RightAlign)

- (void)rightAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset;

@end

@implementation UICollectionViewLayoutAttributes (RightAlign)

- (void)rightAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset
{
    CGRect frame = self.frame;
    frame.origin.x = sectionInset.left;
    self.frame = frame;
}

@end

//---------


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
    id<FCCollectionViewDelegateFlowLayout> delegateFlowLayout = (id<FCCollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    
    //获取每个 section 中 DecorationView 的 frame
    for (NSInteger section = 0; section < sectionNum; section++) {
        NSInteger itemNum = [self.collectionView numberOfItemsInSection:section];
        if (!self.decorationViewDelegate || ![self.decorationViewDelegate respondsToSelector:@selector(collectionView:layout:decorationViewMsgForSection:)] || itemNum == 0) {
            continue;
        }
        
        NSArray<FCDecorationViewMsgModel *> *decorationMsgs = [self.decorationViewDelegate collectionView:self.collectionView layout:self decorationViewMsgForSection:section];
        if (decorationMsgs == nil || ![decorationMsgs isKindOfClass:NSArray.class] || decorationMsgs.count == 0) {
            continue;
        }
        
        UICollectionViewLayoutAttributes *firstItemLayoutAttri = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        
        //获取当前 section 的边距
        UIEdgeInsets sectionInset = self.sectionInset;
        if ([delegateFlowLayout respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            sectionInset = [delegateFlowLayout collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        }
        
        //计算 DecorationView 的 frame
        CGRect sectionFrame = firstItemLayoutAttri.frame;
        for (NSInteger item = 0; item < itemNum; item++) {
            UICollectionViewLayoutAttributes *layoutAttri = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            sectionFrame = CGRectUnion(sectionFrame, layoutAttri.frame);
        }
        
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
    //
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:arr];
    
    FCDecorationCollectionViewFlowLayoutHorizontalAlign horizontalAlign = self.horizontalAlign;
    id<FCCollectionViewDelegateFlowLayout> delegate = (id<FCCollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    for (UICollectionViewLayoutAttributes *attributes in arr) {
        if (!attributes.representedElementKind) {
            if (delegate && [delegate respondsToSelector:@selector(collectionView:layout:horizontalAlignInSection:)]) {
                horizontalAlign = [delegate collectionView:self.collectionView layout:self horizontalAlignInSection:attributes.indexPath.section];
            }
            if (horizontalAlign == FCDecorationCollectionViewFlowLayoutHorizontalAlignLeft) {
                NSUInteger index = [mArr indexOfObject:attributes];
                mArr[index] = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
            }
            
        }
    }
    
    NSArray *decorationLayoutAttributeSet = self.decorationMsgs.allValues;
    for (NSArray *decorationLayoutAttributes in decorationLayoutAttributeSet) {
        for (UICollectionViewLayoutAttributes *layoutAttributes in decorationLayoutAttributes) {
            if (CGRectIntersectsRect(rect, layoutAttributes.frame) && ![mArr containsObject:layoutAttributes]) {
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
    
    FCDecorationCollectionViewFlowLayoutHorizontalAlign horizontalAlign = self.horizontalAlign;
    id<FCCollectionViewDelegateFlowLayout> delegate = (id<FCCollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if (delegate && [delegate respondsToSelector:@selector(collectionView:layout:horizontalAlignInSection:)]) {
        horizontalAlign = [delegate collectionView:self.collectionView layout:self horizontalAlignInSection:indexPath.section];
    }
    if (horizontalAlign == FCDecorationCollectionViewFlowLayoutHorizontalAlignLeft) {
        UICollectionViewLayoutAttributes* currentItemAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
        UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:indexPath.section];
        
        BOOL isFirstItemInSection = indexPath.item == 0;
        CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
        
        if (isFirstItemInSection) {
            [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
            return currentItemAttributes;
        }
        
        NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
        CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
        CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
        CGRect currentFrame = currentItemAttributes.frame;
        CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left,
                                                  currentFrame.origin.y,
                                                  layoutWidth,
                                                  currentFrame.size.height);
        // if the current frame, once left aligned to the left and stretched to the full collection view
        // width intersects the previous frame then they are on the same line
        BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
        
        if (isFirstItemInRow) {
            // make sure the first item on a line is left aligned
            [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
            return currentItemAttributes;
        }
        
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = previousFrameRightPoint + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
        currentItemAttributes.frame = frame;
        return currentItemAttributes;
    }
    
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}
- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        id<FCCollectionViewDelegateFlowLayout> delegate = (id<FCCollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id<FCCollectionViewDelegateFlowLayout> delegate = (id<FCCollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    } else {
        return self.sectionInset;
    }
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

