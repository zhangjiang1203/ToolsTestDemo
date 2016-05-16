//
//  ZJToolHelper.m
//  ToolsTestDemo
//
//  Created by pg on 16/5/13.
//  Copyright © 2016年 DZHFCompany. All rights reserved.
//

#import "ZJToolHelper.h"
#import <objc/runtime.h>


#pragma clang diagnostic ignored"-Wdeprecated-declarations"

static const char AlertBlockKey;

#define ZJ_IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define ZJ_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@implementation ZJToolHelper

//单例
+ (ZJToolHelper *) sharedInstance{
    static ZJToolHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZJToolHelper alloc] init];
    });
    return instance;
}

#pragma mark -设置弹出的alertView
+(void)alertShowTitle:(nullable NSString *)title
              message:(nullable NSString *)message
    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
    otherButtonTitles:(nullable NSString *)otherButtonTitles
                block:(nullable continueBlock)alertBlock
{
    [[ZJToolHelper sharedInstance] ZJ_AlertShowTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles block:^(NSInteger buttonIndex) {
        if (alertBlock) {
            alertBlock(buttonIndex);
        }
    }];
}

-(void)ZJ_AlertShowTitle:(nullable NSString*)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString*)cancelButtontitle otherButtonTitles:(nullable NSString*)otherButtonTitles block:(nullable continueBlock)continueAlertBlock{
    if (ZJ_IOS9) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        if (![ZJToolHelper isBlankString:cancelButtontitle]){
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:cancelButtontitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                continueAlertBlock(0);
            }];
            [alert addAction:defaultAction];
        }
        
        if (![ZJToolHelper isBlankString:otherButtonTitles]) {
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                continueAlertBlock(1);
            }];
            [alert addAction:defaultAction];
        }
        
        UIViewController *currentViewController = [ZJToolHelper getCurrentViewController];
        [currentViewController presentViewController:alert animated:YES completion:nil];
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtontitle otherButtonTitles:otherButtonTitles , nil];
        //添加运行时的设置传递，处理代理方法的设置
        objc_removeAssociatedObjects(alertView);
        alertView.delegate = self;
        objc_setAssociatedObject(alertView, &AlertBlockKey, continueAlertBlock, OBJC_ASSOCIATION_COPY);
        [alertView show];
    }
}

//alertView的代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    continueBlock alertBlock = (continueBlock)objc_getAssociatedObject(alertView, &AlertBlockKey);
    if (alertBlock) {
        alertBlock(buttonIndex);
    }
}


#pragma mark -字符串的方法
+ (BOOL)isBlankString:(nullable NSString *)string
{
    if (string == nil || string == NULL ||[string isEqual:@""]||[string isEqual:@"<null>"])
        return YES;
    
    if ([string isKindOfClass:[NSNull class]])
        return YES;
    //判断是不是空格
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        return YES;
    
    return NO;
}


+(BOOL)isContainsString:(nullable NSString *)firstStr second:(nullable NSString*)secondStr{
    
    if (ZJ_IOS8) {
        return [firstStr containsString:secondStr];
    }else{
        NSRange lengthRange = [firstStr rangeOfString:secondStr];
        return  lengthRange.length?YES: NO;
    }
}


//计算并绘制字符串文本的高度
+(CGSize)getSuitSizeWithString:(nullable NSString *)text fontSize:(float)fontSize bold:(BOOL)bold sizeOfX:(float)x
{
    UIFont *font ;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    CGSize constraint = CGSizeMake(x, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    // 返回文本绘制所占据的矩形空间。
    CGSize contentSize = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return contentSize;
}


+ (nullable NSString *)getSubString:(nullable NSString *)allString toIndex:(NSUInteger)toIndex{
    if (![self isBlankString:allString]) {
        if (allString.length > toIndex) {
            return [allString substringToIndex:toIndex];
        }else{
            return allString;
        }
    }else{
        return @"";
    }

}


#pragma mark -系统方法
/**
 *  获取当前的显示的ViewController
 */
+ (nullable UIViewController *)getCurrentViewController{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


/**
 *  获取当前的网络状态
 */
+ (NETWORK_STATE)getNetworkTypeFromStatusBar {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            dataNetworkItemView = subview;
            break;
        }
        
    }
    NETWORK_STATE nettype = NETWORK_STATE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    return nettype;
}


//app版本号
+ (nullable NSString *)getAppVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle]infoDictionary];
    return [NSString stringWithFormat:@"%@",infoDict[@"CFBundleShortVersionString"]];
}


#pragma mark -UIKIT的方法
+ (nullable NSString *)converseToJsonWithObject:(nullable id)obj{
    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString ;
    if ([jsonData length] > 0 && error == nil){
        //NSData转换为String
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON String = %@", jsonString);
        
        return jsonString;
    }
    else if ([jsonData length] == 0 &&
             error == nil){
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@", error);
    }
    
    return nil;

}


+ (nullable NSArray *)arrayWithMemberIsOnly:(nullable NSArray *)array
{
    NSMutableArray *categoryArray = [NSMutableArray array];
    for (unsigned i = 0; i < [array count]; i++) {
        
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
            [categoryArray addObject:[array objectAtIndex:i]];
            
        }
    }
    return categoryArray;
}


+ (nullable UIImage *)clipsToRect:(CGRect)rect image:(nullable UIImage*)originImage{
    CGRect maxRect = CGRectMake(0, 0, originImage.size.width, originImage.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage,maxRect);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, originImage.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextDrawImage(ctx, CGRectMake(rect.origin.x, rect.origin.y, originImage.size.width, rect.size.height), originImage.CGImage);
    CGContextClipToRect(ctx, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    return image;
}


#pragma mark -图片压缩处理
+ (nonnull UIImage *)scaleToSize:(nonnull UIImage *)originImage size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [originImage drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


+ (void)setImageFitWithImageView:(nonnull UIImageView*)imageView{
    
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds  = YES;
}

+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;

}

+ (nullable UIImage*) createGradientImage:(nullable NSArray*)colors withFrame: (CGRect)frame{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    //开始生成
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //定义颜色空间
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    //设置起点和终点
    CGPoint start,end;;
    start = CGPointMake(0.0, frame.size.height);
    end = CGPointMake(frame.size.width, 0.0);
    //绘制图形
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    //生成图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //释放
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    
    return image;

}

+ (nullable CAGradientLayer*)createGradientLayer:(nullable NSArray*)colorsArr location:(nullable NSArray*)locationArr start:(CGPoint)startPoint end:(CGPoint)endPoint frame:(CGRect)layerFrame{
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame            = layerFrame;
    //设置颜色渐变的方向
    layer.startPoint       = startPoint;
    layer.endPoint         = endPoint;
    //设置颜色组,颜色转换
    NSMutableArray *colors = [NSMutableArray array];
    for (UIColor *color in colorsArr) {
        [colors addObject:(__bridge id)color.CGColor];
    }
    layer.colors = colors;
    //设置颜色的分割点
    layer.locations = locationArr;
    
    return layer;
}

@end
