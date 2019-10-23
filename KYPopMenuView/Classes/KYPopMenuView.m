//
//  KYPopMenuView.m
//  FBSnapshotTestCase
//
//  Created by zr on 2019/10/22.
//

#import "KYPopMenuView.h"

int const kTagKYPopMenuViewArrowView = 53206362;
int const kTagKYPopMenuView = 53206363;

@interface KYPopMenuView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) UIView *shapeView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation KYPopMenuView

- (instancetype)initWithMenuFrame:(CGRect)frame shapeSize:(CGSize)shapeSize shapeOffsetX:(CGFloat)shapeOffsetX images:(NSArray <UIImage *> * _Nullable)imageArray titleArray:(NSArray<NSString *> *)titleArray;
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initalConfig];
        self.tag = kTagKYPopMenuView;
        //初始化三角形箭头
        _point = CGPointMake(frame.origin.x +shapeOffsetX , frame.origin.y - shapeSize.height);
        _shapeView = [[UIView alloc] init];
        _shapeView.frame = CGRectMake(_point.x, _point.y, shapeSize.width, shapeSize.height);
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = CGRectMake(0, 0, shapeSize.width, shapeSize.height);
        shapeLayer.fillColor = _shapeFillColor.CGColor;
        [_shapeView.layer addSublayer:shapeLayer];
        _shapeLayer = shapeLayer;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(shapeSize.width / 2.0, 0)];
        [bezierPath addLineToPoint:CGPointMake(0, shapeSize.height)];
        [bezierPath addLineToPoint:CGPointMake(shapeSize.width, shapeSize.height)];
        [bezierPath addLineToPoint:CGPointMake(shapeSize.width / 2.0, 0)];
        shapeLayer.path = bezierPath.CGPath;
        
        _titleArray = titleArray;
        self.imageArray = imageArray;
              
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = _cornerRadius;
        _tableView.separatorInset = _separatorInset;
        _tableView.separatorColor = _separatorColor;
        _tableView.backgroundColor = _bgColor;
        _tableView.scrollEnabled = _scrollEnabled;
    
    }
    
    return self;
}

- (void)initalConfig {
    
    _shapeFillColor = UIColor.grayColor;
    _bgColor = UIColor.grayColor;
    _cellBgColor = UIColor.clearColor;
    _textColor = UIColor.blackColor;
    _rowHeight = 44;
    _textFont = 13;
    _cornerRadius = 10;
    _separatorInset = UIEdgeInsetsZero;
    _separatorColor = UIColor.grayColor;
}

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
    _separatorInset = separatorInset;
    _tableView.separatorInset = _separatorInset;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    _tableView.separatorColor = _separatorColor;
}

-(void)setShapeFillColor:(UIColor *)shapeFillColor{
    _shapeFillColor = shapeFillColor;
    _shapeLayer.fillColor = _shapeFillColor.CGColor;
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    _tableView.layer.cornerRadius = cornerRadius;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    _tableView.backgroundColor = bgColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:_textFont];
        cell.textLabel.textColor = _textColor;
        cell.backgroundColor = _cellBgColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.imageView.image = [_imageArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (_clickedBlock) {
        _clickedBlock(indexPath.row);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(navigationMenuView:clickedAtIndex:)]) {
        [_delegate navigationMenuView:self clickedAtIndex:indexPath.row];
    }
    [self dismissView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissView];
}

- (void)dismissView
{
    [UIView animateWithDuration:.2f animations:^{
        self.tableView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        self.tableView.alpha = 0.0f;
        self.shapeView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [self.shapeView removeFromSuperview];
        [self.tableView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (BOOL)isShowedInSuperview
{
    for (UIView *view in self.superview.subviews) {
        if (view.tag == kTagKYPopMenuView) {
            return YES;
        }
    }
    return NO;
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        CGRect tableViewFrame = _tableView.frame;
        
        UIViewController *nextResponder = (UIViewController *)[newSuperview nextResponder];
        if (!_shapeView.superview && [nextResponder isKindOfClass:[UIViewController class]]) {
            if (nextResponder.navigationController && _shapeView.frame.origin.y < 64) {
                
                [nextResponder.navigationController.view addSubview:_shapeView];
                [nextResponder.navigationController.view addSubview:_tableView];
                
            }else {
                [self addSubview:_shapeView];
                [self addSubview:_tableView];
            }
        }
        
        _tableView.layer.anchorPoint = CGPointMake((_point.x - tableViewFrame.origin.x)/tableViewFrame.size.width, 0);
        _tableView.center = CGPointMake(_point.x, _point.y + _shapeView.bounds.size.height);
        
        _tableView.alpha = 0.0f;
        _shapeView.alpha = 0.0f;
        _tableView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
        [UIView animateWithDuration:.2f animations:^{
            self.tableView.transform = CGAffineTransformMakeScale(1, 1);
            self.tableView.alpha = 1.0f;
            self.shapeView.alpha = 1.0f;
            
        }];
        
    }
    
}

- (void)showInSuperView:(UIView *)superView
{
    for (UIView *view in superView.subviews) {
        if (view.tag == kTagKYPopMenuView) {
            return;
        }
    }
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
}

@end

