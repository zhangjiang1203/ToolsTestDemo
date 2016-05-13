//
//  ZJToolHelper.h
//  ToolsTestDemo
//
//  Created by pg on 16/5/13.
//  Copyright © 2016年 DZHFCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,NETWORK_STATE) {
    NETWORK_STATE_NONE = 0,
    NETWORK_STATE_2G   = 1,
    NETWORK_STATE_3G   = 2,
    NETWORK_STATE_4G   = 3,
    NETWORK_STATE_5G   = 4,
    NETWORK_STATE_WIFI = 5,
};


typedef void(^continueBlock )(NSInteger buttonIndex);

@interface ZJToolHelper : NSObject<UIAlertViewDelegate>

#pragma mark -弹出的block
/**
 *  设置弹出的alertView，已经适配ios9
 *
 *  @param title             标题
 *  @param message           信息
 *  @param cancelButtonTitle 取消按钮,@"",没有取消按钮
 *  @param otherButtonTitles 其他按钮,@"",没有确定按钮
 *  @param alertBlock        返回的block
 */
+ (void)alertShowTitle:(nullable NSString *)title
              message:(nullable NSString *)message
    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
    otherButtonTitles:(nullable NSString *)otherButtonTitles
                block:(nullable continueBlock)alertBlock;



#pragma mark -字符串方法
/**
 *  判断字符串是否为空
 *  @return 为空时 返回YES
 */
+ (BOOL)isBlankString:(nullable NSString *)string;


/**
 *  两个字符串是否是包含关系
 *  包含的话 返回YES
 */
+ (BOOL)isContainsString:(nullable NSString *)firstStr second:(nullable NSString*)secondStr;

/**
 *  计算并绘制字符串文本的高度
 *
 *  @param text     传入的文本
 *  @param fontSize 字体大小
 *  @param bold     是否是粗体
 *  @param x        最大的宽度
 *
 *  @return 文本所占的长宽
 */
+ (CGSize)getSuitSizeWithString:(nullable NSString *)text fontSize:(float)fontSize bold:(BOOL)bold sizeOfX:(float)x;

/**
 *  截取字符串中指定的范围的字符，避免了空字符造成的奔溃现象
 *
 *  @param timeStr 被截取的字符串
 *  @param range   截取到的位置
 *
 *  @return 截取之后返回的字符串
 */
+ (nullable NSString *)getSubString:(nullable NSString *)allString toIndex:(NSUInteger)toIndex;


#pragma mark -系统方法
/**
 *  获取当前的显示的ViewController
 */
+ (nullable UIViewController *)getCurrentViewController;


/**
 *  获取当前的网络状态
 */
+ (NETWORK_STATE)getNetworkTypeFromStatusBar;


/**
 *  获取app版本号
 *
 *  @return 返回系统版本号
 */
+ (nullable NSString *)getAppVersion;


#pragma mark -UIKIT的方法
/**
 *  字典或者数组转json
 *
 *  @param obj 要转换的字典或者数组
 *
 *  @return 返回的json字符串
 */
+(nullable NSString *)converseToJsonWithObject:(nullable id)obj;



/**
 *  将数组重复的对象去除，只保留一个
 *
 *  @param array 传入的数组
 *
 *  @return 去除重复对象的数组
 */
+ (nullable NSArray *)arrayWithMemberIsOnly:(nullable NSArray *)array;


/**
 *  裁剪图片
 *
 *  @param rect        裁剪的大小区域
 *  @param orangeImage 要裁剪的图片
 *
 *  @return 裁剪之后的图片
 */
+ (nullable UIImage *)clipsToRect:(CGRect)rect image:(nullable UIImage*)originImage;

/**
 *  图片压缩处理
 *
 *  @param img  要压缩的图片
 *  @param size 压缩之后的大小
 *
 *  @return 压缩之后的图片
 */
+ (nonnull UIImage *)scaleToSize:(nonnull UIImage *)originImage size:(CGSize)size;


/**
 *  设置图片的自适应大小 不会变形
 *
 *  @param imageView 设置的imageView
 */
+ (void)setImageFitWithImageView:(nonnull UIImageView*)imageView;


/**
 *  生成一个纯颜色背景图
 *
 *  @param color 颜色值
 *
 *  @return 返回的图片
 */
+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color;


/**
 *  生成一个颜色渐变的背景图
 *
 *  @param colors 传递的颜色值
 *  @param frame  设置图片大小
 *
 *  @return 生成的图片
 */
+ (nullable UIImage*)createGradientImage:(nullable NSArray*)colors withFrame: (CGRect)frame;

/**
 *  利用CAGradientLayer创建颜色渐变的图层
 *
 *  @param colorsArr   颜色数组
 *  @param locationArr 分割点数组
 *  @param startPoint  颜色渐变的起点 (0,0),(0,1)……
 *  @param endPoint    颜色渐变的终点 (0,0),(0,1)……
 *  @param layerFrame  生成的图层的frame
 *
 *  @return 颜色渐变的图层
 */
+ (nullable CAGradientLayer*)createGradientLayer:(nullable NSArray*)colorsArr location:(nullable NSArray*)locationArr start:(CGPoint)startPoint end:(CGPoint)endPoint frame:(CGRect)layerFrame;
@end
