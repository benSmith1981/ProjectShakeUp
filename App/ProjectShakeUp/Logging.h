//
//  Logging.h
//  TheSun
//
//  Created by Martin Lloyd on 20/09/2012.
//
//

#ifndef TheSun_Logging_h
#define TheSun_Logging_h

// The general purpose logger. This ignores logging levels.
#define Warn(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#ifdef DEBUG
#define Debug(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define Assert(condition, desc, ...)                                                                    \
do                                                                                                      \
{                                                                                                       \
if (!(condition))                                                                                   \
{                                                                                                   \
LogCriticalError(kComponentAssert, @"*** Assertion failure: " desc, ##__VA_ARGS__);             \
assert(false);                                                                                  \
}                                                                                                   \
}                                                                                                       \
while(0)
#else
#define Debug(xx, ...)  ((void)0)
#define Assert(condition, desc, ...) ((void)0)
#endif // #ifdef DEBUG

#endif
