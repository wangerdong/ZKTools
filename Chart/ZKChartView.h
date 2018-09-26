//
//  ZKChartView.h
//  VantageFX
//
//  Created by Evan on 2018/9/25.
//

#import <UIKit/UIKit.h>
#import "ZKChartConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZKChartView : UIView

@property (nonatomic, strong) ZKChartConfig *config;

- (void)drawWithValues:(NSArray *)values minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

@end

NS_ASSUME_NONNULL_END
