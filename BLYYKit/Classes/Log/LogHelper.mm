//
//  LogHelper.m
//  ZJLog
//
//  Created by zhangdaoqiang on 2020/5/11.
//  Copyright © 2020 ZJBL. All rights reserved.
//

#import "LogHelper.h"

#include <pthread.h>

#import <mars/xlog/appender.h>
#import <mars/xlog/xloggerbase.h>
#import <mars/xlog/xlogger.h>

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

static NSUInteger g_processID = 0;

static const long kMaxLogAliveTime = 10 * 24 * 60 * 60;    // 10 days in second
static const long kMinLogAliveTime = 24 * 60 * 60;    // 1 days in second
static long sg_max_alive_time = kMaxLogAliveTime;

@implementation LogHelper

+ (void)logLock
{
    pthread_mutex_lock(&mutex);
}

+ (void)logUnlock
{
    pthread_mutex_unlock(&mutex);
}

+ (void)destroyLock
{
    pthread_mutex_destroy(&mutex);
}

+ (void)logWithLevel:(ZJLogLevel)logLevel
          moduleName:(const char *)moduleName
            fileName:(const char *)fileName
          lineNumber:(int)lineNumber
            funcName:(const char *)funcName
             message:(NSString *)message
{
    [self logLock];

    XLoggerInfo info;
    info.level = (TLogLevel)logLevel;
    info.tag = moduleName;
    info.filename = fileName;
    info.func_name = funcName;
    info.line = lineNumber;
    gettimeofday(&info.timeval, NULL);
    info.tid = (uintptr_t)[NSThread currentThread];
    info.maintid = (uintptr_t)[NSThread mainThread];
    info.pid = g_processID;
    xlogger_Write(&info, message.UTF8String);

    [self logUnlock];
}

+ (void)logWithLevel:(ZJLogLevel)logLevel
          moduleName:(const char *)moduleName
            fileName:(const char *)fileName
          lineNumber:(int)lineNumber
            funcName:(const char *)funcName
              format:(NSString *)format, ...
{
    if ([self shouldLog:logLevel]) {
        va_list argList;
        va_start(argList, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
        [self logWithLevel:logLevel moduleName:moduleName fileName:fileName lineNumber:lineNumber funcName:funcName message:message];
        va_end(argList);
    }
}

+ (BOOL)shouldLog:(ZJLogLevel)level
{
    if (level >= (ZJLogLevel)xlogger_Level()) {
        return YES;
    }

    return NO;
}

+ (void)openLogInDir:(NSString *)logPath filePrefix:(NSString *)prefix appendMode:(ZJAppenderMode)mode encryptPubKey:(NSString *)pubKey
{
    appender_open((TAppenderMode)mode, [logPath UTF8String], [prefix UTF8String], [pubKey UTF8String]);
}

+ (void)closeLog
{
    appender_close();
}

+ (void)setLogLevel:(ZJLogLevel)logLevel
{
    xlogger_SetLevel((TLogLevel)logLevel);
}

+ (void)setAppenderMode:(ZJAppenderMode)mode
{
    appender_setmode((TAppenderMode)mode);
}

+ (void)setConsoleLogOpen:(BOOL)open
{
    appender_set_console_log(open);
}

/*
* By default, all logs will write to one file everyday. You can split logs to multi-file by changing max_file_size.
*
* @param _max_byte_size    Max byte size of single log file, default is 0, meaning do not split.
*/
+ (void)setMaxFileSize:(uint64_t)maxSize
{
    appender_set_max_file_size(maxSize);
}

/*
* By default, all logs lives 10 days at most.
*
* @param _max_time    Max alive duration of a single log file in seconds, default is 10 days
*/
+ (void)setMaxAliveTime:(long)maxTime
{
    appender_set_max_alive_duration(maxTime);
    if (maxTime >= kMinLogAliveTime) {
        sg_max_alive_time = maxTime;
    }
}

+ (void)setCustomLogFileHeaderInfo:(NSString *)logFileHeaderInfo
{
    appender_set_log_file_header_info([logFileHeaderInfo UTF8String]);
}

+ (void)flushLog:(BOOL)sync
{
    if (sync) {
        appender_flush_sync();
    } else {
        appender_flush();
    }
}

/**
 * Get all log files for a day
 *
 * @param day   0--All log files for today, 1--All log files from yesterday,  2--All log files of the day before yesterday, .....etc
 */
+ (NSArray<NSString *> *)getAllLogFileWithPrefix:(NSString *)prefix dayOffset:(int)day
{
    std::vector<std::string> filepathVec;
    appender_getfilepath_from_timespan(day, [prefix UTF8String], filepathVec);

    if (filepathVec.empty()) {
        return nil;
    }

    NSMutableArray *array = [NSMutableArray array];
    NSString *path;
    for (auto item : filepathVec) {
        path = [NSString stringWithUTF8String:item.c_str()];
        [array addObject:path];
    }

    return array;
}

/**
 * Get all log files today
 */
+ (NSArray<NSString *> *)getAllLogFileToday:(NSString *)prefix
{
    return [[self class] getAllLogFileWithPrefix:prefix dayOffset:0];
}

+ (NSArray<NSString *> *)getHistoryLog:(NSString *)prefix dayOffset:(int)dayOffset
{
    NSMutableArray *allArray = [NSMutableArray array];

    NSArray *dayArray;

    int dayCount = ceil(sg_max_alive_time * 1.0 / kMinLogAliveTime);

    for (int i = dayOffset; i < dayCount; ++i) {
        dayArray = [self getAllLogFileWithPrefix:prefix dayOffset:i];
        if (dayArray.count != 0) {
            [allArray addObjectsFromArray:dayArray];
        }
    }

    return allArray;
}

/**
 * Get all log files until yesterday
 */
+ (NSArray<NSString *> *)getAllLogFileUntilYesterday:(NSString *)prefix
{
    return [[self class] getHistoryLog:prefix dayOffset:1];
}

/**
 * Get all log files
 */
+ (NSArray<NSString *> *)getAllLogFileUntilToday:(NSString *)prefix
{
    return [[self class] getHistoryLog:prefix dayOffset:0];
}

@end
