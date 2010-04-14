

#if TARGET_OS_IPHONE
	#import <Foundation/Foundation.h>
	#import <UIKit/UIKit.h>
#else
	#import <Cocoa/Cocoa.h>
#endif


@interface TeamboxEngineKeychain : NSObject {

}

+ (BOOL)storePasswordForUsername:(NSString *)username Password:(NSString *)password error:(NSError **)error;
+ (NSString *)getPasswordForUsername:(NSString *)username error:(NSError **)error;
+ (void)deleteKeyForUsername:(NSString *)username error:(NSError **)error;

@end
