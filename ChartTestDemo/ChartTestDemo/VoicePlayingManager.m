//
//  VoicePlayingManager.m
//  dodopay
//
//  Created by 刘新 on 2018/11/16.
//  Copyright © 2018 点点付. All rights reserved.
//
#define kFileManager [NSFileManager defaultManager]
#define MONEYVOICR_DIC @{@"1":@"tts_1",@"2":@"tts_2",@"3":@"tts_3",@"4":@"tts_4",@"5":@"tts_5",@"6":@"tts_6",@"7":@"tts_7",@"8":@"tts_8",@"9":@"tts_9",@"10":@"tts_ten",@"100":@"tts_hundred",@"1000":@"tts_thousand",@"10000":@"tts_ten_thousand",@"0":@"tts_0",@".":@"tts_dot",@"yuan":@"tts_yuan",@"dingdan":@"middle",@"shishou":@"pre",@"vipcard":@"vipcard",@"wx":@"wx",@"zfb":@"zfb"}

#import "VoicePlayingManager.h"
#import <AudioToolbox/AudioToolbox.h>

static VoicePlayingManager *selfClass =nil;
@interface VoicePlayingManager()<AVSpeechSynthesizerDelegate,AVAudioPlayerDelegate>
{
    AVSpeechSynthesizer *synthesizer;
}
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSMutableArray *firlArray;
@property (nonatomic, strong) NSString *filePath;
@end

@implementation VoicePlayingManager
+ (instancetype)sharedVoicePlayingManager {
    static VoicePlayingManager *voicePlayingManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        voicePlayingManager = [[VoicePlayingManager alloc] init];
        //设置锁屏仍能继续播放
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        
    });
    return voicePlayingManager;
}
- (void)getNotificationServiceUserInfo:(NSDictionary *)userInfo finshBlock:(PlayVoiceFinishBlock )playVoiceFinishBlockBlock{
    selfClass = self;
    if ([[userInfo objectForKey:@"type"] intValue]==2||[[userInfo objectForKey:@"type"] intValue]==3) {
        NSDictionary *dictData =[userInfo objectForKey:@"data"];
        int payType = [[dictData objectForKey:@"pay_type"] intValue];
        if (payType == 1 || payType ==3) {
            _firlArray = [[NSMutableArray alloc] init];
            [_firlArray addObject:MONEYVOICR_DIC[@"wx"]];
            BOOL isPlay = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"sound"]].length > 0;
            if (isPlay) {
                [self hechengVoiceWithFinshBlock:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"sum_amount"]] finshBlock:^{
                    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
                    playVoiceFinishBlockBlock(@"播放完成");
                }];
            }
        }else if (payType == 2 || payType ==4){
            _firlArray = [[NSMutableArray alloc] init];
            [_firlArray addObject:MONEYVOICR_DIC[@"zfb"]];
            BOOL isPlay = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"sound"]].length > 0;
            if (isPlay) {
                [self hechengVoiceWithFinshBlock:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"sum_amount"]] finshBlock:^{
                    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
                    playVoiceFinishBlockBlock(@"播放完成");
                }];
            }
        }else if (payType == 5){
            _firlArray = [[NSMutableArray alloc] init];
            [_firlArray addObject:MONEYVOICR_DIC[@"vipcard"]];
            BOOL isPlay = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"sound"]].length > 0;
            if (isPlay) {
                [self hechengVoiceWithFinshBlock:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"sum_amount"]] finshBlock:^{
                    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
                    playVoiceFinishBlockBlock(@"播放完成");
                }];
            }
        }
    }
}

- (NSString *)filePath {
    if (!_filePath) {
        _filePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString *folderName = [_filePath stringByAppendingPathComponent:@"MergeAudio"];
        BOOL isCreateSuccess = [kFileManager createDirectoryAtPath:folderName withIntermediateDirectories:YES attributes:nil error:nil];
        if (isCreateSuccess) _filePath = [folderName stringByAppendingPathComponent:@"compoundvoice2.m4a"];
    }
    return _filePath;
}
#pragma mark- 合成音频使用AudioServicesCreateSystemSoundID播放
- (void)hechengVoiceWithFinshBlock:(NSString *)shuStr finshBlock:(PlayVoiceBlock )block{
    /************************合成音频并播放*****************************/
    NSArray *array = [shuStr componentsSeparatedByString:@"."];
    if (array.count>1) {
        [self formattingFileName:array];
        [_firlArray addObject:MONEYVOICR_DIC[@"."]];
        NSString *xiaoStr = array[1];
        NSString *temp =nil;
        for (int i = 0; i<xiaoStr.length; i++) {
            temp = [xiaoStr substringWithRange:NSMakeRange(i,1)];
            [_firlArray addObject:MONEYVOICR_DIC[temp]];
        }
        [_firlArray addObject:MONEYVOICR_DIC[@"yuan"]];
    }else{
        [self formattingFileName:array];
    }
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    CMTime allTime = kCMTimeZero;
    // 音频轨道
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    for (NSInteger i = 0; i < _firlArray.count; i++) {
        NSString *auidoPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",_firlArray[i]] ofType:@"mp3"];
        AVURLAsset *audioAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:auidoPath]];
        CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
        //CMTimeMake(int64_t value, int32_t timescale)
        
        // 音频素材轨道
        AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        
        // 音频合并 - 插入音轨文件
        //      参数说明:
        //      insertTimeRange:源录音文件的的区间
        //      ofTrack:插入音频的内容
        //      atTime:源音频插入到目标文件开始时间
        //      error: 插入失败记录错误
        //      返回:YES表示插入成功,`NO`表示插入失败
        BOOL success = [audioTrack insertTimeRange:audio_timeRange ofTrack:audioAssetTrack atTime:allTime error:nil];
        
        if (!success) {
            NSLog(@"插入音频失败");
            return;
        }
        // 更新当前的位置
        allTime = CMTimeAdd(allTime, audioAsset.duration);
        
    }
    
    // 合并后的文件导出 - `presetName`要和之后的`session.outputFileType`相对应。
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    NSString *outPutFilePath = [[self.filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"compoundvoice2.m4a"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outPutFilePath error:nil];
    }
    
    // 查看当前session支持的fileType类型
    session.outputURL = [NSURL fileURLWithPath:outPutFilePath];
    session.outputFileType = AVFileTypeAppleM4A; //与上述的`present`相对应
    session.shouldOptimizeForNetworkUse = YES;   //优化网络
    
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"88888888%@",session.error);
            if (session.status == AVAssetExportSessionStatusCompleted) {
                NSLog(@"合并成功----%@", outPutFilePath);
                NSURL *url = [NSURL fileURLWithPath:outPutFilePath];
                
                SystemSoundID soundID;
                //Creates a system sound object.
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
                //Registers a callback function that is invoked when a specified system sound finishes playing.
                AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, &playCallback, (__bridge void * _Nullable)(self));
                //    AudioServicesPlayAlertSound(soundID);
                AudioServicesPlaySystemSound(soundID);
                self.audioPlayerfinshBlock = block;
            } else {
                if (block) {
                    self.audioPlayerfinshBlock = block;
                }
            }
        });
    }];
    /************************合成音频并播放*****************************/
}
void playCallback(SystemSoundID ssID, void* __nullable clientData) {
    AudioServicesDisposeSystemSoundID(ssID);
    selfClass.audioPlayerfinshBlock();
    NSLog(@"播放完成...");
}
// 当播放完成时执行的代理
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.audioPlayerfinshBlock();
}
// 当播放发生错误时调用
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"________播放失败%@",error);
    self.audioPlayerfinshBlock();
}

- (void)formattingFileName:(NSArray *)array{
    NSString *bigStr = array[0];
    NSString *bigTemp =nil;
    for (int i = 0; i<bigStr.length; i++) {
        bigTemp = [bigStr substringWithRange:NSMakeRange(i,1)];
        switch (bigStr.length) {
            case 5:
            {
                if (i==0) {
                    [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                    [_firlArray addObject:MONEYVOICR_DIC[@"10000"]];
                }else if (i==1){
                    if ([bigTemp intValue]>0) {
                        [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                        [_firlArray addObject:MONEYVOICR_DIC[@"1000"]];
                    }
                    
                }else if (i==2){
                    if ([bigTemp intValue]>0){
                        [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                        [_firlArray addObject:MONEYVOICR_DIC[@"100"]];
                    }
                }else if (i==3){
                    if ([bigTemp intValue]>0){
                        [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                        [_firlArray addObject:MONEYVOICR_DIC[@"10"]];
                    }
                }else if (i==4){
                    if ([bigTemp intValue]>0){
                        [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                    }
                }
            }
                break;
            case 4:
            {
                if (i==0){
                    [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                    [_firlArray addObject:MONEYVOICR_DIC[@"1000"]];
                    
                }else if (i==1){
                    if ([bigTemp intValue]>0){
                        [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                        [_firlArray addObject:MONEYVOICR_DIC[@"100"]];
                    }
                }else if (i==2){
                    if ([bigTemp intValue]>0){
                        [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                        [_firlArray addObject:MONEYVOICR_DIC[@"10"]];
                    }
                }else if (i==3){
                    if ([bigTemp intValue]>0){
                        [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                    }
                }
            }
                break;
            case 3:
            {
                if (i==0){
                    [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                    [_firlArray addObject:MONEYVOICR_DIC[@"100"]];
                }else if (i==1){
                    if ([bigTemp intValue]>0){
                        [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                        [_firlArray addObject:MONEYVOICR_DIC[@"10"]];
                    }
                }else if (i==2){
                    if ([bigTemp intValue]>0){
                        [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                    }
                }
            }
                break;
            case 2:
            {
                if (i==0){
                    [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                    [_firlArray addObject:MONEYVOICR_DIC[@"10"]];
                }else if (i==1){
                    if ([bigTemp intValue]>0){
                        [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
                    }
                }
            }
                break;
            case 1:
            {
                [_firlArray addObject:MONEYVOICR_DIC[bigTemp]];
            }
                break;
                
            default:
                break;
        }
    }
    
    if(array.count<=1){
        [_firlArray addObject:MONEYVOICR_DIC[@"yuan"]];
    }
}
@end
