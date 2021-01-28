//
//  LogUtil.h
//  ZJLog
//
//  Created by zhangdaoqiang on 2020/5/11.
//  Copyright © 2020 ZJBL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LogHelper.h"

NS_ASSUME_NONNULL_BEGIN

//#define __FILENAME__ (strrchr(__FILE__,'/')+1)
#define __FILENAME__ [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]

#define LOG_ERROR(module, format, ...) LogInternal(log_LevelError, module, __FILENAME__, __LINE__, __FUNCTION__, @"Error:", format, ##__VA_ARGS__)
#define LOG_WARNING(module, format, ...) LogInternal(log_LevelWarn, module, __FILENAME__, __LINE__, __FUNCTION__, @"Warning:", format, ##__VA_ARGS__)
#define LOG_INFO(module, format, ...) LogInternal(log_LevelInfo, module, __FILENAME__, __LINE__, __FUNCTION__, @"Info:", format, ##__VA_ARGS__)
#define LOG_DEBUG(module, format, ...) LogInternal(log_LevelDebug, module, __FILENAME__, __LINE__, __FUNCTION__, @"Debug:", format, ##__VA_ARGS__)

@interface LogUtil : NSObject

@end

NS_ASSUME_NONNULL_END
