//
//  ZKChartView.m
//  VantageFX
//
//  Created by Evan on 2018/9/25.
//

#import "ZKChartView.h"

@interface ZKChartView ()

@property (nonatomic, strong) CAShapeLayer *valueLayer;
@property (nonatomic, strong) CAShapeLayer *longitudeLayer;
@property (nonatomic, strong) CAShapeLayer *latitudeLayer;
@property (nonatomic, strong) NSMutableArray *valuePoins;

@end

@implementation ZKChartView

- (instancetype)init {
	if (self = [super init]) {
		
		self.clipsToBounds = YES;
		self.config = [ZKChartConfig defaultConfig];
	}
	return self;
}

- (void)drawWithValues:(NSArray *)values minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
	
	// 初始化
	_valueLayer.path = [UIBezierPath bezierPath].CGPath;
	_longitudeLayer.path = [UIBezierPath bezierPath].CGPath;
	_latitudeLayer.path = [UIBezierPath bezierPath].CGPath;
	
	// 计算图表开始坐标、结束坐标、X轴Y轴两点间隔
	CGFloat startX = self.config.contentInset.left;
	CGFloat startY = self.config.contentInset.top;
	CGFloat endX = CGRectGetWidth(self.frame) - self.config.contentInset.right;
	CGFloat endY = CGRectGetHeight(self.frame) - self.config.contentInset.bottom;
	CGFloat xPadding = (endX - startX) / (self.config.numberOfLongitude - 1);
	CGFloat yPadding = (endY - startY) / (self.config.numberOfLatitude - 1);
	
	// 计算数值对应的坐标
	self.valuePoins = [NSMutableArray array];
	[values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		// 计算数值在坐标系上对应的点
		float value = [obj floatValue];
		float x = startX + idx * xPadding;
		float y = startY + (maxValue - value) / (maxValue - minValue) * (endY - startY);
		
		[self.valuePoins addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
	}];
	// 数据画线
	UIBezierPath *bezierPath = [self bezierPathWithPoints:self.valuePoins];
	self.valueLayer.path = bezierPath.CGPath;
	// Y轴刻度线
	if (self.config.showsVerticalIndicator) {
		if (!self.latitudeLayer) {
			
			self.latitudeLayer = [CAShapeLayer layer];
			[self.layer addSublayer:self.latitudeLayer];
		}
		for (NSInteger i = 0; i < self.config.numberOfLatitude; i++) {
			
			CGPoint startPoint = CGPointMake(startX, startY + i * yPadding);
			CGPoint endPoint = CGPointMake(endX, startPoint.y);
			
			CAShapeLayer *dashLayer = [self dashLineWithStart:startPoint end:endPoint pattern:@[ @(2), @(2) ]];
			[self.latitudeLayer addSublayer:dashLayer];
		}
		[self.layer insertSublayer:self.latitudeLayer below:self.valueLayer];
	}
	// X轴刻度线
	if (self.config.showsHorizontalIndicator) {
		
		UIBezierPath *bezierPath = [UIBezierPath bezierPath];
		for (NSInteger i = 0; i < self.config.numberOfLongitude; i++) {
			
			CGPoint startPoint = CGPointMake(startX + i * xPadding, CGRectGetHeight(self.frame));
			CGPoint endPoint = CGPointMake(startPoint.x, startPoint.y - 4);
			
			[bezierPath moveToPoint:startPoint];
			[bezierPath addLineToPoint:endPoint];
		}
		self.longitudeLayer.path = bezierPath.CGPath;;
		[self.layer insertSublayer:self.longitudeLayer below:self.valueLayer];
	}
}

#pragma mark - 绘制贝塞尔曲线

// 贝塞尔曲线
- (UIBezierPath *)bezierPathWithPoints:(NSArray *)points {

	UIBezierPath *bezierPath= [UIBezierPath bezierPath];
	CGPoint startPoint;
	for (NSUInteger idx = 0; idx < points.count; idx++) {
		
		NSValue *value = points[idx];
		if (idx == 0) { // 起点
			
			startPoint = [value CGPointValue];
			[bezierPath moveToPoint:startPoint];
			continue;
		}
		// 折线
		CGPoint endPoint = [value CGPointValue];
		if (!self.config.enableBezierCurve) {
			
			[bezierPath addLineToPoint:endPoint];
			startPoint = endPoint;
			continue;
		}
		// 贝塞尔曲线
		CGPoint midPoint = CGPointMake((startPoint.x + endPoint.x) / 2, (startPoint.y + endPoint.y) / 2);
		[bezierPath addQuadCurveToPoint:midPoint controlPoint:[self controlPointForStartPoint:midPoint endPoint:startPoint]];
		[bezierPath addQuadCurveToPoint:endPoint controlPoint:[self controlPointForStartPoint:midPoint endPoint:endPoint]];
		
		startPoint = endPoint;
	}
	
	return bezierPath;
}

// 贝塞尔曲线控制点
- (CGPoint)controlPointForStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
	
	CGPoint controlPoint = CGPointMake((startPoint.x + endPoint.x) / 2, (startPoint.y + endPoint.y) / 2);
	CGFloat diffY = fabs(endPoint.y - controlPoint.y);
	if (startPoint.y < endPoint.y) {
		
		controlPoint.y += diffY;
	} else if (startPoint.y > endPoint.y) {
		
		controlPoint.y -= diffY;
	}
	return controlPoint;
}

// 绘制虚线
- (CAShapeLayer *)dashLineWithStart:(CGPoint)startPoint end:(CGPoint)endPoint pattern:(NSArray *)pattern {
	
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.strokeColor = kColorEAEAEA.CGColor;
	shapeLayer.lineWidth = 1;
	shapeLayer.lineJoin = kCALineJoinRound;
	shapeLayer.lineDashPattern = pattern;
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
	CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
	shapeLayer.path = path;
	CGPathRelease(path);
	
	return shapeLayer;
}

#pragma mark - Getter

- (CAShapeLayer *)valueLayer {
	
	if (!_valueLayer) {
		
		_valueLayer = [CAShapeLayer layer];
		_valueLayer.fillColor = [UIColor clearColor].CGColor;
		_valueLayer.strokeColor = self.config.lineColor.CGColor;
		_valueLayer.lineWidth = self.config.lineWidth;
		
		[self.layer addSublayer:_valueLayer];
	}
	return _valueLayer;
}

- (CAShapeLayer *)longitudeLayer {
	
	if (!_longitudeLayer) {
		
		_longitudeLayer = [CAShapeLayer layer];
		_longitudeLayer.strokeColor = kColorD6D6D6.CGColor;
		_longitudeLayer.lineWidth = 1.5;
		
		[self.layer addSublayer:_longitudeLayer];
	}
	return _longitudeLayer;
}

@end
