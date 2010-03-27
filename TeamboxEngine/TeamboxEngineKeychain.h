//
//  TeamboxEngineKeychain.h
//  Teambox-Engine
//
//  Created by Alejandro JL on 27/03/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxEngineHeaders.h"

@interface TeamboxEngineKeychain : NSObject {

}

+ (BOOL)storePasswordForUsername:(NSString *)username Password:(NSString *)password error:(NSError **)error;
+ (NSString *)getPasswordForUsername:(NSString *)username error:(NSError **)error;
+ (void)deleteKeyForUsername:(NSString *)username error:(NSError **)error;

@end
