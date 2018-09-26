//
//  ZKChartConfig.h
//  VantageFX
//
//  Created by Evan on 2018/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZKChartConfig : NSObject

@property (nonatomic, assign) UIEdgeInsets contentInset;	// 内边距
@property (nonatomic, assign) NSInteger numberOfLongitude;	// 经线个数
@property (nonatomic, assign) NSInteger numberOfLatitude;	// 纬线个数
@property (nonatomic, assign) BOOL showsVerticalIndicator;	// 显示水平等分线
@property (nonatomic, assign) BOOL showsHorizontalIndicator;// 显示垂直等分线
@property (nonatomic, assign) BOOL enableBezierCurve;		// 贝塞尔曲线
@property (nonatomic, assign) CGFloat lineWidth;			// 线条宽度
@property (nonatomic, strong) UIColor *lineColor;			// 线条颜色

+ (ZKChartConfig *)defaultConfig;

@end

NS_ASSUME_NONNULL_END
