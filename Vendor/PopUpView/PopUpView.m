//
//  PopUpView.m
//  TestPop
//
//  Created by noah on 2017/04/05.
//  Copyright © 2017年 noah. All rights reserved.
//

#import "PopUpView.h"
#import "NSArray+CustomArray.h"

@interface PopUpView ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *innerView;
@property (nonatomic) BOOL isShow;
@end

@implementation PopUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
        _innerView.frame = CGRectMake(0, 64-kScreen_Height*0.7, kScreen_Width, kScreen_Height*0.7);
//        [_textView setContentInset:UIEdgeInsetsMake(15, 15, 10, 15)];
        _textView.textContainerInset = UIEdgeInsetsMake(20, 15, 10, 15);
        _isShow = NO;
        [self setTap];
    }
    return self;
}

- (void)tapBackAction
{
    [self dismissFromSuperView];
}

+ (instancetype)defaultPopupView{
    return [[PopUpView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
}


- (IBAction)dismissViewSlideAction:(id)sender{
    [self dismissFromSuperView];
}

- (void)dismissFromSuperView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = _innerView.frame;
        weakSelf.innerView.frame = CGRectMake(rect.origin.x, rect.origin.y-rect.size.height, rect.size.width, rect.size.height);
    } completion:^(BOOL finished) {
        weakSelf.isShow = NO;
        weakSelf.hidden = YES;
    }];
}

- (void)setLongTextArr:(NSArray *)longTextArr
{
    _longTextArr = longTextArr;
    if (_longTextArr.count>0) {
        NSString *longText = [_longTextArr arrayConvertToString];
        self.textView.text = longText;
    }else{
        self.textView.text = @"No message";
    }
    
}

- (void)setTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissFromSuperView)];
    [self addGestureRecognizer:tap];
}

- (void)show
{
    self.hidden = NO;
    __weak typeof(self) weakSelf = self;
    if (!_isShow) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.innerView.frame = CGRectMake(0, 64, kScreen_Width, kScreen_Height*0.7);
        } completion:^(BOOL finished) {
            weakSelf.isShow = YES;
        }];
    }else {
        [self dismissFromSuperView];
    }
}

@end
