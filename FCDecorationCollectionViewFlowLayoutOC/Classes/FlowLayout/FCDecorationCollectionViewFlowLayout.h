//
//  FCDecorationCollectionViewFlowLayout.h
//  FCDecorationCollectionViewFlowLayoutOC
//
//  Created by 石富才 on 2020/8/13.
//

#import <UIKit/UIKit.h>

@protocol FCDecorationCollectionViewFlowLayoutDelegate;
@interface FCDecorationCollectionViewFlowLayout : UICollectionViewFlowLayout

/** <#aaa#>  */
@property(nonatomic, weak)id<FCDecorationCollectionViewFlowLayoutDelegate> decorationViewDelegate;

@end


@class FCDecorationViewMsgModel;
@protocol FCDecorationCollectionViewFlowLayoutDelegate <NSObject>

- (NSArray<FCDecorationViewMsgModel *> *)collectionView:(UICollectionView *)collectionview layout:(FCDecorationCollectionViewFlowLayout *)layout decorationViewMsgForSection:(NSInteger)section;

@end

@interface FCDecorationViewMsgModel : NSObject

/** <#aaa#>  */
@property(nonatomic, strong)NSString *reuseIdentifier;
/** zIndex用于设置front-to-back层级；值越大，优先布局在上层；cell的zIndex为0  */
@property(nonatomic, strong)UICollectionViewLayoutAttributes *decorationViewLayoutAttributes;

//这两个属性决定 decorationViewAttributes 的 frame
/** UIEdgeInsets  */
@property(nonatomic)NSValue *decorationViewEdgeInsets;
/** CGSize  */
@property(nonatomic)NSValue *decorationViewSize;

@end
