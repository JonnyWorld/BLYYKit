//
//  LogHelper.h
//  ZJLog
//
//  Created by zhangdaoqiang on 2020/5/11.
//  Copyright © 2020 ZJBL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    log_LevelAll     = 0,
    log_LevelVerbose = 0,
    log_LevelDebug,    // Detailed information on the flow through the system.
    log_LevelInfo,     // Interesting runtime events (startup/shutdown), should be conservative and keep to a minimum.
    log_LevelWarn,     // Other runtime situations that are undesirable or unexpected, but not necessarily "wrong".
    log_LevelError,    // Other runtime errors or unexpected conditions.
    log_LevelFatal,    // Severe errors that cause premature termination.
    log_LevelNone,     // Special level used to disable all log messages.
} ZJLogLevel;

typedef enum {
    log_AppednerAsync,
    log_AppednerSync,
} ZJAppenderMode;

#define LogInternal(level, module, file, line, func, prefix, format, ...) \
    do { \
        if ([LogHelper shouldLog:level]) { \
            NSString *aMessage = [NSString stringWithFormat:@"%@%@", prefix, [NSString stringWithFormat:format, ## __VA_ARGS__, nil]]; \
            const char *moduleName = [module UTF8String]; \
            [LogHelper logWithLevel:level moduleName:moduleName fileName:file lineNumber:line funcName:func message:aMessage]; \
        } \
    } while (0)

NS_ASSUME_NONNULL_BEGIN

@interface LogHelper : NSObject

+ (void)logLock;

+ (void)logUnlock;

+ (void)destroyLock;

+ (void)logWithLevel:(ZJLogLevel)logLevel
          moduleName:(const char *)moduleName
            fileName:(const char *)fileName
          lineNumber:(int)lineNumber
            funcName:(const char *)funcName
             message:(NSString *)message;

+ (void)logWithLevel:(ZJLogLevel)logLevel
          moduleName:(const char *)moduleName
            fileName:(const char *)fileName
          lineNumber:(int)lineNumber
            funcName:(const char *)funcName
              format:(NSString *)format, ...;

+ (BOOL)shouldLog:(ZJLogLevel)level;

+ (void)openLogInDir:(NSString *)logPath filePrefix:(NSString *)prefix appendMode:(ZJAppenderMode)mode encryptPubKey:(NSString *)pubKey;

+ (void)closeLog;

+ (void)setLogLevel:(ZJLogLevel)logLevel;

+ (void)setAppenderMode:(ZJAppenderMode)mode;

+ (void)setConsoleLogOpen:(BOOL)open;

/*
* By default, all logs will write to one file everyday. You can split logs to multi-file by changing max_file_size.
*
* @param _max_byte_size    Max byte size of single log file, default is 0, meaning do not split.
*/
+ (void)setMaxFileSize:(uint64_t)maxSize;

/*
* By default, all logs lives 10 days at most.
*
* @param _max_time    Max alive duration of a single log file in seconds, default is 10 days
*/
+ (void)setMaxAliveTime:(long)maxTime;

+ (void)setCustomLogFileHeaderInfo:(NSString *)logFileHeaderInfo;

+ (void)flushLog:(BOOL)sync;

/**
 * Get all log files for a day
 *
 * @param day   0--All log files for today, 1--All log files from yesterday,  2--All log files of the day before yesterday, .....etc
 */
+ (NSArray<NSString *> *)getAllLogFileWithPrefix:(NSString *)prefix dayOffset:(int)day;


/**
 * Get all log files today
 */
+ (NSArray<NSString *> *)getAllLogFileToday:(NSString *)prefix;

/**
 * Get all log files until yesterday
 */
+ (NSArray<NSString *> *)getAllLogFileUntilYesterday:(NSString *)prefix;

/**
 * Get all log files
 */
+ (NSArray<NSString *> *)getAllLogFileUntilToday:(NSString *)prefix;

@end

NS_ASSUME_NONNULL_END
