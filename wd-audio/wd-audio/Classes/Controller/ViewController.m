//
//  ViewController.m
//  wd-audio
//
//  Created by WangDongya on 2017/12/13.
//  Copyright © 2017年 example. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "WDMusicTool.h"
#import "WDMusic.h"
#import "WDAudioTool.h"
#import "WDLrcView.h"
#import "WDLrcLabel.h"
#import "CALayer+WDExtension.h"
#import "NSString+WDExtension.h"


@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *albumView;
@property (weak, nonatomic) IBOutlet UILabel *songNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playPauseBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet WDLrcLabel *lrcLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet WDLrcView *lrcView;

#pragma mark - 歌词定时器
@property (nonatomic, strong) CADisplayLink *lrcTimer;

#pragma mark - 播放器
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;



#pragma mark - 进度条时间
@property (nonatomic, strong) NSTimer *progressTimer;

#pragma mark - 进度条事件
- (IBAction)begin:(id)sender;
- (IBAction)end:(id)sender;
- (IBAction)progressValueChanged:(id)sender;
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender;

#pragma mark - 按钮点击事件
- (IBAction)previousMusic:(id)sender;
- (IBAction)nextMusic:(id)sender;
- (IBAction)playPauseMusic:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 添加模糊效果
    [self setupBlur];
    // 2. 改变滑块图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    // 3.
    self.lrcView.lrcLabel = self.lrcLabel;
    
    // 4. 开始播放音乐
    [self startPlayingMusic];
    // 5. 设置歌词 view contentsize
    self.lrcView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    
    // 6.接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addIconViewAnimate) name:@"XMGIconViewNotification" object:nil];
}

#pragma mark -
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    // 添加圆角
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor colorWithRed:36.0/255.0 green:36.0/255.0 blue:36.0/255.0 alpha:1.0].CGColor;
    self.iconView.layer.borderWidth = 8;
}

// 顶部状态栏
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 按钮点击事件
- (IBAction)previousMusic:(id)sender {
    // 1. 获取上一首歌曲
    WDMusic *preMusic = [WDMusicTool preMusic];
    // 2. 播放该歌曲
    [self playMusicWithMusic:preMusic];
}

- (IBAction)nextMusic:(id)sender {
    // 1. 获取下一首歌曲
    WDMusic *nextMusic = [WDMusicTool nextMusic];
    // 2. 播放该歌曲
    [self playMusicWithMusic:nextMusic];
}

- (IBAction)playPauseMusic:(id)sender {
    self.playPauseBtn.selected = !self.playPauseBtn.selected;
    if (self.currentPlayer.playing) {
        // 1. 暂停播放器
        [self.currentPlayer pause];
        // 2. 移除定时器
        [self removeProgressTimer];
        // 3. 暂停选择动画
        [self.iconView.layer pauseAnimate];
    } else {
        // 1. 播放
        [self.currentPlayer play];
        // 2. 添加定时器
        [self addProgressTimer];
        // 3. 恢复动画
        [self.iconView.layer resumeAnimate];
    }
}
- (void)playMusicWithMusic:(WDMusic *)music
{
    // 1. 获取当前播放的歌曲并停止
    WDMusic *currentMusic = [WDMusicTool playingMusic];
    [WDAudioTool stopMusicWithFileName:currentMusic.filename];
    
    // 2. 设置传入歌曲为默认播放歌曲
    [WDMusicTool setupPlayingMusic:music];
    
    // 3. 播放音乐，并更新界面信息
    [self startPlayingMusic];
}


#pragma mark - 开始播放音乐
- (void)startPlayingMusic
{
    // 0. 清除之前的歌词
    self.lrcLabel.text = nil;
    
    // 1. 获取当前正在播放的音乐
    WDMusic *playingMusic = [WDMusicTool playingMusic];
    
    // 2. 设置界面信息
    self.albumView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songNamelabel.text = playingMusic.name;
    self.singerNameLabel.text = playingMusic.singer;
    
    // 3. 播放音乐
    AVAudioPlayer *currentPlayer = [WDAudioTool playMusicWithFileName:playingMusic.filename];
    self.currentTimeLabel.text = [NSString stringWithTime:currentPlayer.currentTime];
    self.totalTimeLabel.text = [NSString stringWithTime:currentPlayer.duration];
    self.currentPlayer = currentPlayer;
    
    // 3.1 设置播放按钮
    self.playPauseBtn.selected = self.currentPlayer.isPlaying;
    // 3.2 设置歌词
    self.lrcView.lrcName = playingMusic.lrcname;
    
    // 4. 开启定时器，先将之前的定时器移除
    [self removeProgressTimer];
    [self addProgressTimer];
    [self removeLrcTimer];
    [self addLrcTimer];
    
    // 5. 添加iconView的动画
    [self addIconViewAnimate];
}

#pragma mark - 添加iconView的动画
- (void)addIconViewAnimate
{
    CABasicAnimation *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimate.fromValue = @(0);
    rotateAnimate.toValue = @(M_PI * 2);
    rotateAnimate.repeatCount = NSIntegerMax;
    rotateAnimate.duration = 35;
    [self.iconView.layer addAnimation:rotateAnimate forKey:nil];
    
    // 更新动画是否进入后台
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iconViewAnimate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 添加进度条的时间出来
- (void)addProgressTimer
{
    // 1. 提前更新数据
    [self updateProgressInfo];
    // 2. 添加定时器
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}
#pragma mark - 移除定时器
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}
#pragma mark - 更新进度条
- (void)updateProgressInfo
{
    // 1. 更新播放时间
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    // 2. 更新滑动条
    self.progressSlider.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
}

#pragma mark - 歌词定时器的处理
- (void)addLrcTimer
{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcInfo)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}
- (void)updateLrcInfo
{
    self.lrcView.currentTime = self.currentPlayer.currentTime;
}

#pragma mark - 添加模糊效果
- (void)setupBlur
{
    // 1. 初始化toolBar
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [self.albumView addSubview:toolBar];
    toolBar.barStyle = UIBarStyleBlack;
    
    // 2. 添加约束
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.albumView);
    }];
}
#pragma mark UIScrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.获取滑动的偏移量
    CGPoint point =  scrollView.contentOffset;
    
    // 2.获取滑动比例
    CGFloat alpha = 1 - point.x / scrollView.bounds.size.width;
    
    // 3.设置alpha
    self.iconView.alpha = alpha;
    self.lrcLabel.alpha = alpha;
}

#pragma mark - Slide事件
- (IBAction)begin:(id)sender {
    // 移除定时器
    [self removeProgressTimer];
}

- (IBAction)end:(id)sender {
    // 更新播放时间
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;
    // 添加定时器
    [self addProgressTimer];
}

- (IBAction)progressValueChanged:(id)sender {
    self.currentTimeLabel.text = [NSString stringWithTime:self.progressSlider.value * self.currentPlayer.duration];
}
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender
{
    // 1.获取点击到的点
    CGPoint point = [sender locationInView:sender.view];
    
    // 2.获取点击的比例
    CGFloat ratio = point.x / self.progressSlider.bounds.size.width;
    
    // 3.更新播放的时间
    self.currentPlayer.currentTime = self.currentPlayer.duration * ratio;
    
    // 4.更新时间和滑块的位置
    [self updateProgressInfo];
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
    /*
     UIEventSubtypeRemoteControlPlay                 = 100,
     UIEventSubtypeRemoteControlPause                = 101,
     UIEventSubtypeRemoteControlStop                 = 102,
     UIEventSubtypeRemoteControlTogglePlayPause      = 103,
     UIEventSubtypeRemoteControlNextTrack            = 104,
     UIEventSubtypeRemoteControlPreviousTrack        = 105,
     UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
     UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
     UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
     UIEventSubtypeRemoteControlEndSeekingForward    = 109,
     */
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playPauseMusic:nil];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextMusic:nil];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousMusic:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - 移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
