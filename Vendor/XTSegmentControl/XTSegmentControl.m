//
//  SegmentControl.m
//  GT
//
//  Created by tage on 14-2-26.
//  Copyright (c) 2014年 cn.kaakoo. All rights reserved.
//

#import "XTSegmentControl.h"
#import "AppInfoManager.h"

#define XTSegmentControlItemFont (15)

#define XTSegmentControlHspace (0)

#define XTSegmentControlLineHeight (2)

#define XTSegmentControlAnimationTime (0.1)

#define XTSegmentControlIconWidth (50.0)

#define XTSegmentControlIconSpace (4)

#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define kColorDDD [UIColor redColor]
#define kColorBrandGreen [UIColor greenColor]

#import "NSString+customString.h"

typedef NS_ENUM(NSInteger, XTSegmentControlItemType)
{
    XTSegmentControlItemTypeTitle = 0,
    XTSegmentControlItemTypeIconUrl,
    XTSegmentControlItemTypeTitleAndIcon,
};

@interface XTSegmentControlItem : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *titleIconView;
@property (nonatomic, assign) XTSegmentControlItemType type;

- (void)setSelected:(BOOL)selected;
@end

@implementation XTSegmentControlItem

- (id)initWithFrame:(CGRect)frame title:(NSString *)title type:(XTSegmentControlItemType)type
//- (id)initWithFrame:(CGRect)frame title:(id )title type:(XTSegmentControlItemType)type
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _type = type;
        switch (_type) {
            case XTSegmentControlItemTypeIconUrl:
            {
                CGRect segmentRect = self.bounds;
                _titleIconView = [[UIImageView alloc] initWithFrame:CGRectMake(segmentRect.origin.x, segmentRect.origin.y, segmentRect.size.width, segmentRect.size.height)];
                if (title) {
                    [_titleIconView setImage:[UIImage imageNamed:title]];
                }else{
                    [_titleIconView setImage:[UIImage imageNamed:@"logo"]];
                }
                [self addSubview:_titleIconView];
            }
                break;
            case XTSegmentControlItemTypeTitleAndIcon:
            {
                _titleLabel = ({
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.text = title;
                    label.backgroundColor = [UIColor clearColor];
                    [label sizeToFit];
                    if (label.frame.size.width > CGRectGetWidth(self.bounds) - XTSegmentControlIconSpace - 10) {
                        CGRect frame = label.frame;
                        frame.size.width = CGRectGetWidth(self.bounds) - XTSegmentControlIconSpace - 10;
                        label.frame = frame;
                    }
                    label.center = CGPointMake((CGRectGetWidth(self.bounds) - XTSegmentControlIconSpace - 10) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
                    label;
                });
                
                [self addSubview:_titleLabel];
                
                CGFloat x = CGRectGetMaxX(_titleLabel.frame) + XTSegmentControlIconSpace;
                _titleIconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, (CGRectGetHeight(self.bounds) - 10) * 0.5, 10, 10)];
                [_titleIconView setImage:[UIImage imageNamed:@"tag_list_up"]];
                [self addSubview:_titleIconView];
            }
                break;
            case XTSegmentControlItemTypeTitle:
            default:
            {
                _titleLabel = ({
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XTSegmentControlHspace, 0, CGRectGetWidth(self.bounds) - 2 * XTSegmentControlHspace, CGRectGetHeight(self.bounds))];
                    label.font = [UIFont systemFontOfSize:XTSegmentControlItemFont];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.text = title;
                    label.backgroundColor = [UIColor clearColor];
                    label;
                });
                
                
                [self addSubview:_titleLabel];
            }
                break;
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    switch (_type) {
        case XTSegmentControlItemTypeIconUrl:
        {
        }
            break;
        case XTSegmentControlItemTypeTitleAndIcon:
        {
            if (_titleLabel) {
//                [_titleLabel setTextColor:(selected ? kColorBrandGreen:kColor222)];
            }
            if (_titleIconView) {
                [_titleIconView setImage:[UIImage imageNamed: selected ? @"tag_list_down" : @"tag_list_up"]];
            }
        }
            break;
        default:
        {
            if (_titleLabel) {
//                [_titleLabel setTextColor:(selected ? kColorBrandGreen:kColor222)];
            }
        }
            break;
    }
}

- (void)resetTitle:(NSString *)title
{
    if (_titleLabel) {
        _titleLabel.text = title;
    }
    if (_type == XTSegmentControlItemTypeTitleAndIcon) {
        [_titleLabel sizeToFit];
        if (_titleLabel.frame.size.width > CGRectGetWidth(self.bounds) - XTSegmentControlIconSpace - 10) {
            CGRect frame = _titleLabel.frame;
            frame.size.width = CGRectGetWidth(self.bounds) - XTSegmentControlIconSpace - 10;
            _titleLabel.frame = frame;
        }
        _titleLabel.center = CGPointMake((CGRectGetWidth(self.bounds) - XTSegmentControlIconSpace - 10) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
    
        CGRect frame = _titleIconView.frame;
        frame.origin.x = CGRectGetMaxX(_titleLabel.frame) + XTSegmentControlIconSpace;
        _titleIconView.frame = frame;
    }
}

@end

@interface XTSegmentControl ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *contentView;

@property (nonatomic , strong) UIView *leftShadowView;

@property (nonatomic , strong) UIView *rightShadowView;

@property (nonatomic , strong) UIView *lineView;

@property (nonatomic , strong) NSMutableArray *itemFrames;

@property (nonatomic , strong) NSMutableArray *items, *titleMutArr;

@property (nonatomic , weak) id <XTSegmentControlDelegate> delegate;

@property (nonatomic , copy) XTSegmentControlBlock block;

@property (nonatomic) NSArray *disableIndexArr;

@end

@implementation XTSegmentControl

- (id)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem withIcon:(BOOL)isIcon
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI_IsIcon:isIcon Items:titleItem];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI_IsIcon:NO Items:titleItem];
    }
    return self;
}

- (void)setupUI_IsIcon:(BOOL)isIcon Items:(NSArray *)titleItem
{
    _contentView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        [self addSubview:scrollView];
        
         UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [scrollView addGestureRecognizer:tapGes];
        [tapGes requireGestureRecognizerToFail:scrollView.panGestureRecognizer];
        scrollView;
    });
    self.backgroundColor = [UIColor clearColor];
    
    [self initItemsWithTitleArray:titleItem withIcon:isIcon];
}

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem delegate:(id<XTSegmentControlDelegate>)delegate
{
    if (self = [self initWithFrame:frame Items:titleItem]) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem withIcon:(BOOL)isIcon selectedBlock:(XTSegmentControlBlock)selectedHandle
{
    if (self = [self initWithFrame:frame Items:titleItem withIcon:isIcon]) {
        self.block = selectedHandle;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem selectedBlock:(XTSegmentControlBlock)selectedHandle
{
    if (self = [self initWithFrame:frame Items:titleItem]) {
        self.block = selectedHandle;
    }
    return self;
}

- (void)disableSelectIndex:(NSArray *)disableArr
{
   
}

- (void)doTap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    
    __weak typeof(self) weakSelf = self;
    
    [self checkUserId:_checkType];
    
    [_itemFrames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGRect rect = [obj CGRectValue];
        if ([weakSelf.disableIndexArr containsObject:[NSString stringWithFormat:@"%lu", (unsigned long)idx]]) {
            return;
        }

        if (CGRectContainsPoint(rect, point)) {
            [weakSelf selectIndex:idx];
            
            [weakSelf transformAction:idx];
            
            *stop = YES;
        }
    }];
}

- (void)transformAction:(NSInteger)index
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XTSegmentControlDelegate)] && [self.delegate respondsToSelector:@selector(segmentControl:selectedIndex:)]) {
        
        [self.delegate segmentControl:self selectedIndex:index];
        
    }else if (self.block) {
        
        self.block(index);
    }
}

- (void)initItemsWithTitleArray:(NSArray *)titleArray withIcon:(BOOL)isIcon
{
    _itemFrames = @[].mutableCopy;
    _items = @[].mutableCopy;
    _titleMutArr = [NSMutableArray arrayWithArray:titleArray];
    float y = 0;
    float height = CGRectGetHeight(self.bounds);
//    NSObject *obj = [titleArray firstObject];
    if (!isIcon) {//[obj isKindOfClass:[NSString class]]
        for (int i = 0; i < titleArray.count; i++) {
            float x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
            float width = kScreen_Width/titleArray.count;
            CGRect rect = CGRectMake(x, y, width, height);
            [_itemFrames addObject:[NSValue valueWithCGRect:rect]];
        }
        if (!isIcon) {
            BOOL needResize = NO;
            for (int i = 0; i < titleArray.count; i++) {
                CGRect rect = [_itemFrames[i] CGRectValue];
                NSString *title = titleArray[i];
                if ([title getWidthWithFont:[UIFont systemFontOfSize:XTSegmentControlItemFont] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)] > rect.size.width) {
                    needResize = YES;
                    break;
                }
            }
            if (needResize) {
                [_itemFrames removeAllObjects];
                for (int i = 0; i < titleArray.count; i++) {
                    NSString *title = titleArray[i];
                    float width = [title getWidthWithFont:[UIFont systemFontOfSize:XTSegmentControlItemFont] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)] + 25;
                    float x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
                    CGRect rect = CGRectMake(x, y, width, height);
                    [_itemFrames addObject:[NSValue valueWithCGRect:rect]];
                }
            }
        }
        for (int i = 0; i < titleArray.count; i++) {
            CGRect rect = [_itemFrames[i] CGRectValue];
            NSString *title = titleArray[i];
            XTSegmentControlItem *item = [[XTSegmentControlItem alloc] initWithFrame:rect title:title type: isIcon ?
                                                                                   XTSegmentControlItemTypeTitleAndIcon : XTSegmentControlItemTypeTitle];
            if (!isIcon && i == 0) {
                [item setSelected:YES];
            }
            [_items addObject:item];
            [_contentView addSubview:item];
        }

    }
    else {
        CGRect firstFrame = CGRectMake(0, 0, self.frame.size.width/_titleMutArr.count-1, height);
        [_itemFrames addObject:[NSValue valueWithCGRect:firstFrame]];

        for (int i = 1; i < titleArray.count; i++) {
            float x = CGRectGetMaxX([_itemFrames[i-1] CGRectValue])+1;
            CGRect rect = CGRectMake(x, y, firstFrame.size.width, height);
            [_itemFrames addObject:[NSValue valueWithCGRect:rect]];
        }
        
        for (int i = 0; i < titleArray.count; i++) {
            CGRect rect = [_itemFrames[i] CGRectValue];
            XTSegmentControlItem *item;

                NSString *image = titleArray[i];
                item = [[XTSegmentControlItem alloc]initWithFrame:rect title:image type:XTSegmentControlItemTypeIconUrl];
            if (item) {
                if (i == 0) {
                    [item setSelected:YES];
                }
                [_items addObject:item];
                [_contentView addSubview:item];
            }
        }
    }

    [_contentView setContentSize:CGSizeMake(CGRectGetMaxX([[_itemFrames lastObject] CGRectValue]), CGRectGetHeight(self.bounds))];
    self.currentIndex = 0;
    [self selectIndex:0];
//    if (isIcon) {
//        [self selectIndex:-1];
//        for (int i=1; i<_itemFrames.count; i++) {
//            CGRect rect = [_itemFrames[i] CGRectValue];
//            
//            UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(
//                                                                         CGRectGetMinX(rect),
//                                                                         (CGRectGetHeight(rect) - 14) * 0.5,
//                                                                         1,
//                                                                         14)];
//            lineView.backgroundColor = kColorDDD;
//            [self addSubview:lineView];
//        }
//    }
}

- (void)addRedLine
{
    if (!_lineView) {
        CGRect rect = [_itemFrames[0] CGRectValue];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(
                                                             CGRectGetMinX(rect),
                                                             CGRectGetHeight(rect) - XTSegmentControlLineHeight,
                                                             CGRectGetWidth(rect) - 2 * XTSegmentControlHspace,
                                                             XTSegmentControlLineHeight)];
        _lineView.backgroundColor = kColorBrandGreen;
        [_contentView addSubview:_lineView];
       
//        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(rect)-0.5, CGRectGetWidth(self.bounds), 0.5)];
//        bottomLineView.backgroundColor = kColorDDD;
//        [self addSubview:bottomLineView];
    }
}

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index
{
    XTSegmentControlItem *curItem = [_items objectAtIndex:index];
    [curItem resetTitle:title];
}

- (void)selectIndex:(NSInteger)index
{
//    [self addRedLine];
    if (index < 0) {
        _currentIndex = -1;
        _lineView.hidden = TRUE;
        for (XTSegmentControlItem *curItem in _items) {
            [curItem setSelected:NO];
        }
    } else {
        _lineView.hidden = FALSE;
    
        if (!_currentIndex) {
             XTSegmentControlItem *curItem = [_items objectAtIndex:index];
              __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:XTSegmentControlAnimationTime animations:^{
                
            } completion:^(BOOL finished) {
                [_items enumerateObjectsUsingBlock:^(XTSegmentControlItem *item, NSUInteger idx, BOOL *stop) {
                    [item setSelected:NO];
                    NSString *imgName;
                    
                    if (index == idx) {
                        NSString *name = [weakSelf.titleMutArr objectAtIndex:idx];
                        imgName = [name replace:@"off" withString:@"on"];
                        
                    }else if(weakSelf.currentIndex == idx) {
                        NSString *name = [weakSelf.titleMutArr objectAtIndex:idx];
                        imgName = [name replace:@"on" withString:@"off"];
                    }
                    if (imgName) {
                        [item.titleIconView setImage: [UIImage imageNamed:imgName]];
                    }
                    
                }];
                [curItem setSelected:YES];
                _currentIndex = index;
            }];

        }
        
     else   if (index != _currentIndex ) {
            XTSegmentControlItem *curItem = [_items objectAtIndex:index];
            CGRect rect = [_itemFrames[index] CGRectValue];
            CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + XTSegmentControlHspace, CGRectGetHeight(rect) - XTSegmentControlLineHeight, CGRectGetWidth(rect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
            if (_currentIndex < 0) {
                _lineView.frame = lineRect;
                [curItem setSelected:YES];
                _currentIndex = index;
            } else {
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:XTSegmentControlAnimationTime animations:^{
                    _lineView.frame = lineRect;
                } completion:^(BOOL finished) {
                    [_items enumerateObjectsUsingBlock:^(XTSegmentControlItem *item, NSUInteger idx, BOOL *stop) {
                        [item setSelected:NO];
                        NSString *imgName;
                        
                        if (index == idx) {
                            NSString *name = [weakSelf.titleMutArr objectAtIndex:idx];
                            imgName = [name replace:@"off" withString:@"on"];

                        }
                        
                        else if(weakSelf.currentIndex == idx) {
                            NSString *name = [weakSelf.titleMutArr objectAtIndex:idx];
                            imgName = [name replace:@"on" withString:@"off"];
                        }
                        if (imgName) {
                            item.titleIconView.image = [UIImage imageNamed:imgName];
                        }
                        
                    }];
                    [curItem setSelected:YES];
                    _currentIndex = index;
                }];
            }
        }
        [self setScrollOffset:index];
    }
}

- (void)moveIndexWithProgress:(float)progress
{
    progress = MAX(0, MIN(progress, _items.count));
    
    float delta = progress - _currentIndex;

    CGRect origionRect = [_itemFrames[_currentIndex] CGRectValue];;
    
    CGRect origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + XTSegmentControlHspace, CGRectGetHeight(origionRect) - XTSegmentControlLineHeight, CGRectGetWidth(origionRect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
    
    CGRect rect;
    
    if (delta > 0) {
        if (delta > 1) {
            self.currentIndex += floorf(delta);
            delta -= floorf(delta);
            origionRect = [_itemFrames[_currentIndex] CGRectValue];;
            origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + XTSegmentControlHspace, CGRectGetHeight(origionRect) - XTSegmentControlLineHeight, CGRectGetWidth(origionRect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
        }

        
        
        if (_currentIndex == _itemFrames.count - 1) {
            return;
        }
        
        rect = [_itemFrames[_currentIndex + 1] CGRectValue];
        
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + XTSegmentControlHspace, CGRectGetHeight(rect) - XTSegmentControlLineHeight, CGRectGetWidth(rect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
        
        CGRect moveRect = CGRectZero;
        
        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) + delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        moveRect.origin = CGPointMake(CGRectGetMidX(origionLineRect) + delta * (CGRectGetMidX(lineRect) - CGRectGetMidX(origionLineRect)) - CGRectGetMidX(moveRect), CGRectGetMidY(origionLineRect) - CGRectGetMidY(moveRect));
        _lineView.frame = moveRect;
    } else if (delta < 0){
        
        if (_currentIndex == 0) {
            return;
        }
        rect = [_itemFrames[_currentIndex - 1] CGRectValue];
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + XTSegmentControlHspace, CGRectGetHeight(rect) - XTSegmentControlLineHeight, CGRectGetWidth(rect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
        CGRect moveRect = CGRectZero;
        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) - delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        moveRect.origin = CGPointMake(CGRectGetMidX(origionLineRect) - delta * (CGRectGetMidX(lineRect) - CGRectGetMidX(origionLineRect)) - CGRectGetMidX(moveRect), CGRectGetMidY(origionLineRect) - CGRectGetMidY(moveRect));
        _lineView.frame = moveRect;
        if (delta < -1) {
            self.currentIndex -= 1;
        }
    }    
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    currentIndex = MAX(0, MIN(currentIndex, _items.count));
    
    if (currentIndex != _currentIndex) {
        XTSegmentControlItem *preItem = [_items objectAtIndex:_currentIndex];
        XTSegmentControlItem *curItem = [_items objectAtIndex:currentIndex];
        [preItem setSelected:NO];
        [curItem setSelected:YES];
        _currentIndex = currentIndex;
    }
    [self setScrollOffset:currentIndex];
}

- (void)endMoveIndex:(NSInteger)index
{
    [self selectIndex:index];
}

- (void)setScrollOffset:(NSInteger)index
{
    if (_contentView.contentSize.width <= kScreen_Width) {
        return;
    }
    
    CGRect rect = [_itemFrames[index] CGRectValue];

    float midX = CGRectGetMidX(rect);
    
    float offset = 0;
    
    float contentWidth = _contentView.contentSize.width;
    
    float halfWidth = CGRectGetWidth(self.bounds) / 2.0;
    
    if (midX < halfWidth) {
        offset = 0;
    }else if (midX > contentWidth - halfWidth){
        offset = contentWidth - 2 * halfWidth;
    }else{
        offset = midX - halfWidth;
    }
    
    [UIView animateWithDuration:XTSegmentControlAnimationTime animations:^{
        [_contentView setContentOffset:CGPointMake(offset, 0) animated:NO];
    }];
}

int ExceMinIndex(float f)
{
    int i = (int)f;
    if (f != i) {
        return i+1;
    }
    return i;
}


- (void)checkUserId:(PageControlType)pageType
{
    NSMutableArray *disabledIndex = @[].mutableCopy;
    AppInfoManager *appInfoManager = [AppInfoManager sharedManager];
    switch (pageType) {
        case PAGECONTROLFOUR:{
                if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] &&
                    ![[NSUserDefaults standardUserDefaults] objectForKey:@"accessKey"] ) {
                    [disabledIndex addObject:@"1"];
                    
                }
                if ((![[NSUserDefaults standardUserDefaults] objectForKey:@"ProtocolInfo"] || [appInfoManager checkFWVersion] == NSOrderedAscending)) {
                    [disabledIndex addObject:@"2"];
                }
                if((![appInfoManager getIsSettingMacAdressFinished] || [appInfoManager checkFWVersion] != NSOrderedSame)
                   ){
                    [disabledIndex addObject:@"3"];
                }
            break;}
            
        case PAGECONTROLFIVE:{
             if ((![appInfoManager getIsSettingVeicleFinished] || [appInfoManager checkFWVersion] != NSOrderedSame) ) {
                [disabledIndex addObject:@"0"];
            }
           if ((![appInfoManager getIsSettingMacAdressFinished] || [appInfoManager checkFWVersion] == NSOrderedAscending)){
                 [disabledIndex addObject:@"1"];
                 [disabledIndex addObject:@"2"];
                           }
            if (((![[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] &&
                  ![[NSUserDefaults standardUserDefaults] objectForKey:@"accessKey"]) || [appInfoManager checkFWVersion] == NSOrderedAscending) ) {
                [disabledIndex addObject:@"4"];
                
            }
            break;}
    }
    
    _disableIndexArr = disabledIndex.copy;
}

@end

