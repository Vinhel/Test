//
//  PopUpView.h
//  TestPop
//
//  Created by noah on 2017/04/05.
//  Copyright © 2017年 noah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpView : UIView

@property (strong, nonatomic) NSArray *longTextArr;
+ (instancetype)defaultPopupView;
- (void)show;

@end
