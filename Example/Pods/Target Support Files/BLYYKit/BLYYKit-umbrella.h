#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LogHelper.h"
#import "LogUtil.h"
#import "ZJLog.h"

FOUNDATION_EXPORT double BLYYKitVersionNumber;
FOUNDATION_EXPORT const unsigned char BLYYKitVersionString[];

