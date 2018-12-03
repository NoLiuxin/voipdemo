//
//  VoicePlayingManager.h
//  dodopay
//
//  Created by 刘新 on 2018/11/16.
//  Copyright © 2018 点点付. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PlayVoiceBlock)(void);

typedef void(^PlayVoiceFinishBlock)(NSString *finishStr);
@interface VoicePlayingManager : NSObject
// AVAudioPlayer 播放完毕之后的回调block
@property (nonatomic, copy)PlayVoiceBlock audioPlayerfinshBlock;

- (void)getNotificationServiceUserInfo:(NSDictionary *)userInfo finshBlock:(PlayVoiceFinishBlock )playVoiceFinishBlockBlock;

+ (instancetype)sharedVoicePlayingManager;
@end

NS_ASSUME_NONNULL_END
