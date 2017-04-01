//
//  NSString+customString.m
//  SONICPITNew
//
//  Created by noah on 2017/03/13.
//  Copyright © 2017年 . All rights reserved.
//

#import "NSString+customString.h"
#import <CoreGraphics/CGGeometry.h>

@implementation NSString (customString)

- (NSString *)replaceStr:(NSString *)str0 withString:(NSString *)str1
{
//    NSString*replacedStr = [self stringByReplacingOccurrencesOfString:
//                            str0 withString:str1];
    
//    NSString *replacedStr = [self stringByReplacingOccurrencesOfString:str0 withString:str1 options:NSRegularExpressionSearch range:NSMakeRange(0, self.length-1) ];
    
    //NO.1
    NSMutableArray *strArr = [self componentsSeparatedByString:@"_"].mutableCopy;
//    NSString *comStr = [self stringByReplacingOccurrencesOfString:str0 withString:str1 options:NSRegularExpressionSearch range:NSMakeRange(0, [NSString stringWithFormat:@"%@", [strArr lastObject]].length-1) ];
    NSString *comStr = [[NSString stringWithFormat:@"%@", [strArr lastObject]] stringByReplacingOccurrencesOfString:str0 withString:str1];
     [strArr replaceObjectAtIndex:strArr.count-1 withObject:comStr];
    NSString *replacedStr = [strArr componentsJoinedByString:@"_"];
    
    
    //NO.2
    NSMutableString *string= self.mutableCopy; // 假设我们已经有了一个名为 string 的字符串
    // 现在要去掉它的一个前缀，做法如下:
//    NSString *prefix = str0;
//    NSRange r = [string rangeOfString:prefix options:NSAnchoredSearch range:NSMakeRange(0, string.length) locale:nil];
//    if (r.location != NSNotFound) {
////        [string deleteCharactersInRange:r];
//        [string replaceOccurrencesOfString:str0 withString:str1 options:NSAnchoredSearch range:r];
//    }
    
    [string replaceOccurrencesOfString:str0 withString:str1 options:NSBackwardsSearch range:NSMakeRange(self.length-3,3)];
   

   
    return string.copy;
}

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    resultSize = [self boundingRectWithSize:CGSizeMake(floor(size.width), floor(size.height))//用相对小的 width 去计算 height / 小 heigth 算 width
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: font,
                                              NSParagraphStyleAttributeName: style}
                                    context:nil].size;
    resultSize = CGSizeMake(floor(resultSize.width + 1), floor(resultSize.height + 1));//上面用的小 width（height） 来计算了，这里要 +1
    return resultSize;
}

- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].height;
}
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].width;
}



@end
