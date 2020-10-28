//
//  FCDecorationCollectionViewFlowLayout.h
//  FCDecorationCollectionViewFlowLayoutOC
//
//  Created by 石富才 on 2020/8/13.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FCDecorationCollectionViewFlowLayoutHorizontalAlign){
    FCDecorationCollectionViewFlowLayoutHorizontalAlignNormal,//系统默认
    FCDecorationCollectionViewFlowLayoutHorizontalAlignLeft,//向左对齐
    FCDecorationCollectionViewFlowLayoutHorizontalAlignRight,//向右对齐
};

@protocol FCDecorationCollectionViewFlowLayoutDelegate;
@interface FCDecorationCollectionViewFlowLayout : UICollectionViewFlowLayout


/** 水平对齐方式  */
@property(nonatomic, assign)FCDecorationCollectionViewFlowLayoutHorizontalAlign horizontalAlign;
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

@protocol FCCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

- (FCDecorationCollectionViewFlowLayoutHorizontalAlign)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout horizontalAlignInSection:(NSInteger)section;

@end
