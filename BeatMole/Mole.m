//
//  Mole.m
//  BeatMole
//
//  Created by LZXuan on 15-5-8.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "Mole.h"
#import <AVFoundation/AVFoundation.h>

#define kMoleSpeed 5
//extern 表示 引用 外面 定义的全局变量
//下面只是在引用外面的变量 没有定义
extern NSInteger score;

@implementation Mole
{
    BOOL _isStartMoving;//是否准备移动
    NSInteger _totalLength;//记录移动的长度
    AVAudioPlayer *_player;
}
- (void)dealloc {
    [_player release];
    [super dealloc];
}
//初始化地鼠 第几行第几列的地鼠
- (instancetype)initWithRow:(NSInteger)row
                        col:(NSInteger) col {
    //根据行和列计算出 坐标
    CGRect frame;
    frame.size.height = 79;
    frame.size.width = 56;
    frame.origin.x = 35+100*col;
    frame.origin.y = 195 + 87*row;
    
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundImage:[UIImage imageNamed:@"Mole01"] forState:UIControlStateNormal];
        //禁用状态的图片
        [self setBackgroundImage:[UIImage imageNamed:@"Mole04"] forState:UIControlStateDisabled];
        //初始的时候我们应该禁用地鼠 在洞里禁用地鼠
        self.enabled = NO;
        _totalLength = 0;
        _isStartMoving = NO;
        //增加点击事件  按下
        [self addTarget:self action:@selector(beat) forControlEvents:UIControlEventTouchDown];
        
        [self creatMusic];
    }
    return self;
}
#pragma mark - 音乐
- (void)creatMusic {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Sound15" ofType:@"wav"];
    _player  = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [_player prepareToPlay];
    _player.numberOfLoops = 0;//播放一次
}



#pragma mark - 被点击
- (void)beat{
    //被打+1
    score++;
    
    [_player play];
    
    //被点击 之后 先禁用 不能连续点击
    self.enabled = NO;
    /*
     地鼠向下走被点击 继续向下走
     地鼠向上走被点击 立即向下走
     */
    //地鼠从洞中 向上移动60  向下移动60 总共移动120
    
    if (_totalLength < 60) {//<60肯定是向上走
        //>60就是向下走
        _totalLength = 120-_totalLength;//改变移动长度
    }
}

/**
 *  准备移动
 */
- (void)startMoving {
    _isStartMoving = YES;
    if (_totalLength == 0) {//表示在洞里
        //在洞里的时候 才能被选中打开禁用
        self.enabled = YES;
    }
}
/**
 *  地鼠出洞
 */
//定时器 每隔一段时间就会调用
- (void)outOfHole {
    if (!_isStartMoving) {
        return;
    }
    //_isStartMoving == YES 才能移动
    CGPoint center = self.center;
    //要保证 速度是能被60整除
    if (_totalLength < 60) {//向上移动
        center.y -= kMoleSpeed;
    }else {
        center.y += kMoleSpeed;
    }
    self.center = center;
    
    //记录移动的路长
    _totalLength += kMoleSpeed;
    if (_totalLength == 120) {//表示走完了
        //回到洞里了
        _totalLength = 0;
        self.enabled = NO;
        _isStartMoving = NO;
    }
}

@end






