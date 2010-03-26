//
//  TeamboxEngineConnectionDelegate.h
//  Teambox-Engine
//
//  Created by Alejandro JL on 26/03/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxEngineHeaders.h"

@protocol TeamboxEngineConnectionDelegate

- (void)finishedGetData:(NSData *)data withType:(NSString *)type;

@end
