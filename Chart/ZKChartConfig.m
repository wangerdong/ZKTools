//
//  ZKChartConfig.m
//  VantageFX
//
//  Created by Evan on 2018/9/25.
//

#import "ZKChartConfig.h"

@implementation ZKChartConfig

+ (ZKChartConfig *)defaultConfig {
	
	ZKChartConfig *config = [[ZKChartConfig alloc] init];
	config.contentInset = UIEdgeInsetsMake(4, 4, 8, 4);
	config.numberOfLongitude = 7;
	config.numberOfLatitude = 5;
	config.showsVerticalIndicator = YES;
	config.showsHorizontalIndicator = YES;
	config.enableBezierCurve = YES;
	config.lineWidth = 1.0;
	config.lineColor = [UIColor colorWithRed:198.0/255.0 green:157.0/255.0 blue:94.0/255.0 alpha:1.0];
	
	return config;
}

@end
