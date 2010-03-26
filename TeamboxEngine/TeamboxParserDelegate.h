//
//  TeamboxParseDelegate.h
//  Teambox
//
//  Created by Alejandro Julián López on 26/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxEngineHeaders.h"

@protocol TeamboxParserDelegate

- (void)parserFinished:(NSArray *)parsedElements typeParse:(NSString *)type;
- (void)parserFailedWithError:(NSError *)errorMsg;

@end
