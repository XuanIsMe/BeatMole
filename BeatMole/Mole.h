//
//  Mole.h
//  BeatMole
//
//  Created by LZXuan on 15-5-8.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <UIKit/UIKit.h>
//地鼠 显示 有图片 和被点击 所以继承与 UIbutton
//扩展出地鼠新功能  出洞  发出声音
@interface Mole : UIButton
//初始化地鼠 第几行第几列的地鼠
- (instancetype)initWithRow:(NSInteger)row
                        col:(NSInteger) col;
/**
 *  准备移动
 */
- (void)startMoving;
/**
 *  地鼠出洞
 */
- (void)outOfHole;
@end







