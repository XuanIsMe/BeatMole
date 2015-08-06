//
//  GameViewController.m
//  BeatMole
//
//  Created by LZXuan on 15-5-8.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "GameViewController.h"
#import "Mole.h"
#import <AVFoundation/AVFoundation.h>

//定义一个全局变量 默认 是0
//全局变量 整个应用程序所有的文件所有类所有函数 都可以使用 数据共享
NSInteger score;


@interface GameViewController ()
{
    NSMutableArray *_backImages;
    NSMutableArray *_molesArr;//地鼠数组
    NSTimer *_timer;//定时器
    //背景音乐
    AVAudioPlayer *_player;
}
@end

@implementation GameViewController
- (void)dealloc {
    [_molesArr release];
    [_player release];
    [_backImages release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self creatBackImageView];
    
    [self gameInit];
}
#pragma mark - 初始化
- (void)gameInit {
    //创建地鼠
    [self creatMoles];
    [self creatBackMusic];
}
- (void)creatBackMusic {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gophermusic" ofType:@"mp3"];
    _player  = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [_player prepareToPlay];
    _player.numberOfLoops = -1;
    [_player play];
}


#pragma mark - 创建地鼠
- (void)creatMoles {
    NSLog(@"%s %d",__func__,__LINE__);
    NSLog(@"%@",NSStringFromSelector(_cmd));
    //先创建数组对象
    _molesArr = [[NSMutableArray  alloc] init];
    //九宫格
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = _backImages[i+1];
        for (NSInteger j = 0; j < 3; j++) {
            Mole *mole = [[Mole alloc] initWithRow:i col:j];
            //放在指定的背景下面
            [self.view insertSubview:mole belowSubview:imageView];
            [_molesArr addObject:mole];
            [mole release];
        }
    }
}

- (void)chooseMole {
    //NSLog(@"%s %d",__func__,__LINE__);
    //随机选中地鼠 出洞
    //降低选中 频率
    static NSUInteger i = 0;
    if (i % 5 == 0) {
        //每调用5次 chooseMole 选一个地鼠
        //随机从 数组中选中一只
        Mole *mole = _molesArr[arc4random()%9];
        [mole startMoving];//准备出洞
    }
    i++;
    
    //让地鼠出洞
    for (Mole *mole in _molesArr) {
        [mole outOfHole];
    }
//    NSLog(@"%s %d",__func__,__LINE__);
}
#pragma mark - 定时器
//界面将要显示
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeClick) userInfo:nil repeats:YES];
}
//界面离开屏幕自动调用
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([_timer isValid]) {
        //终止
        [_timer invalidate];
        _timer  = nil;
    }
}
#pragma mark - 定时器触发的方法
- (void)timeClick {
    //选中地鼠 出洞
    [self chooseMole];
    //NSLog(@"score:%ld",(long)score);
}

#pragma mark - 背景
- (void)creatBackImageView {
    //获取沙盒包内资源路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BackImage" ofType:@"plist"];
    //解析plist 文件
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    
    _backImages = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        //把字符串转化为 CGRect
        CGRect frame = CGRectFromString(dict[@"rect"]);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:dict[@"name"]];
        
        //设置tag值  201  202 203  204
        imageView.tag = 200+ [dict[@"order"] integerValue];
        [self.view addSubview:imageView];
        
        [_backImages addObject:imageView];
        [imageView release];
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
