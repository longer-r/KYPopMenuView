//
//  KYPopMenuView.h
//  FBSnapshotTestCase
//
//  Created by zr on 2019/10/22.
//

#import <UIKit/UIKit.h>

extern int const kTagKYPopMenuViewArrowView;
extern int const kTagKYPopMenuView;

NS_ASSUME_NONNULL_BEGIN

@class KYPopMenuView;
@protocol KYPopMenuViewDelegate <NSObject>

@optional
/// 点击每一栏时通过代理回调
/// @param menuView menuView
/// @param index 每一栏的索引,从0开始
- (void)popMenuView:(KYPopMenuView *)menuView clickedAtIndex:(NSInteger)index;

@end



@interface KYPopMenuView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) id<KYPopMenuViewDelegate>delegate;

/// 背景色,默认grayColor
@property (nonatomic, strong) UIColor *bgColor;

/// 三角形填充颜色,默认grayColor
@property (nonatomic, strong) UIColor *shapeFillColor;

/// cell背景颜色,默认clearColor
@property (nonatomic, strong) UIColor *cellBgColor;

/// 文字颜色,默认黑色
@property (nonatomic, strong) UIColor *textColor;

/// 圆角,默认10
@property (nonatomic, assign) CGFloat cornerRadius;

/// 下划线内边距
@property (nonatomic, assign) UIEdgeInsets separatorInset;

/// 下划线颜色,默认grayColor
@property (nonatomic, strong) UIColor *separatorColor;

/// 字体大小,默认13
@property (nonatomic, assign) CGFloat textFont;

/// 菜单栏高度,默认44
@property (nonatomic, assign) CGFloat rowHeight;

///是否可以滚动,默认为NO
@property (nonatomic, assign) BOOL scrollEnabled;

/// 是否已显示
@property (nonatomic, assign) BOOL isShowedInSuperview;

/// 点击每一栏时通过block回调,索引从0开始
@property (nonatomic, copy) void (^clickedBlock)(NSInteger index);

/// 初始化对象
/// @param frame 菜单frame
/// @param shapeSize 三角形箭头大小,默认为(12,8)
/// @param shapeOffsetX 三角箭头偏移X,相对于menu的frame
/// @param imageArray 图片对象
/// @param titleArray 显示的标题
- (instancetype)initWithMenuFrame:(CGRect)frame shapeSize:(CGSize)shapeSize shapeOffsetX:(CGFloat)shapeOffsetX images:(NSArray <UIImage *> * _Nullable)imageArray titleArray:(NSArray<NSString *> *)titleArray;


/// 移除对象
- (void)dismissView;

/// 添加对象
/// @param superView 父视图
- (void)showInSuperView:(UIView *)superView;

@end


NS_ASSUME_NONNULL_END
