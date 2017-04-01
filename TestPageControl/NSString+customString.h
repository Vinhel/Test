//
//  NSString+customString.h
//  SONICPITNew
//
//  Created by noah on 2017/03/13.
//  Copyright © 2017年 noah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (customString)

- (NSString *)replaceStr:(NSString *)str0 withString:(NSString *)str1;

- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
