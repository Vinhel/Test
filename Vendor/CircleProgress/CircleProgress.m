//
//  CircleProgress.m
//  TestProcessView
//
//  Created by noah on 2017/03/21.
//  Copyright © 2017年 noah. All rights reserved.
//

#import "CircleProgress.h"

@interface CircleProgress ()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) UIBezierPath *path;

@end

@implementation CircleProgress



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupProgress];
    }
    return  self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupProgress];
    }
    return self;
}


- (void)setupProgress
{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = self.frame;

    CGFloat lineWidth = 0;
    CGFloat radius = CGRectGetWidth(self.frame) / 2 - lineWidth / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI_2 endAngle:(2*M_PI + M_PI_2) clockwise:YES];
    
    
    _shapeLayer.path = path.CGPath;
    
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth = 6.0f;

}

- (void)layoutSubviews
{
    _shapeLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGFloat lineWidth = 0;
    CGFloat radius = CGRectGetWidth(self.frame) / 2 - lineWidth / 2;
    _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI_2 endAngle:(2*M_PI + M_PI_2) clockwise:YES];
    _shapeLayer.path = _path.CGPath;
    
    
    [self.layer addSublayer:_shapeLayer];
}


- (void)setProgress:(CGFloat)endFloat withColor:(CGColorRef)color
{
    
    CGFloat lineWidth = 0;
    CGFloat radius = CGRectGetWidth(self.frame) / 2 - lineWidth / 2;
    _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI_2 endAngle:(2*M_PI + M_PI_2) clockwise:YES];
    
    
    _shapeLayer.path = _path.CGPath;
    _shapeLayer.strokeColor = color;
    
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 1.0f;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:endFloat];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [_shapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
}


@end
