//
//  TeamboxEngineConnectionDelegate.h
//  Teambox-Engine
//
//  Created by Alejandro JL on 26/03/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxEngineHeaders.h"

@protocol TeamboxConnectionDelegate

- (void)finishedGetData:(NSData *)data withType:(NSString *)type;
- (void)finishedGetData:(NSData *)data withType:(NSString *)type andProjectName:(NSString *)projectName;
- (void)finishedConnectionLogin;
- (void)errorAuthentication;
- (void)errorConnectionLogin:(NSError *)error;

@end
