//
//  TeamboxParseDelegate.h
//  Teambox
//
//  Created by Alejandro Julián López on 26/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxEngineHeaders.h"
#import "TBXML.h"
@protocol TeamboxParserDelegate

- (void)parserFinishedType:(NSString *)type;
- (void)parserFinishedType:(NSString *)type projectName:(NSString *)name;
- (void)getActivitiesAllMorewithID:(NSString *)idActivity;
- (void)parserFailedWithError:(NSError *)errorMsg;
- (void)getUsers;

@end
