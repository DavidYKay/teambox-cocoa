//
//  TeamboxEngineDelegate.h
//  Teambox
//
//  Created by Alejandro Julián López on 26/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//
#import "TeamboxEngineHeaders.h"

@protocol TeamboxEngineDelegate

@optional

- (void)activitiesReceivedAll;
- (void)activitiesReceivedAllNew;
- (void)activitiesReceivedAllMore;
- (void)activitiesReceivedAllProject;

- (void)activitiesReceivedProjectAllWhithName:(NSString *)name  andType:(NSString *)type;
- (void)activitiesReceivedProjectNewWhithName:(NSString *)name andType:(NSString *)type;
- (void)activitiesReceivedProjectMoreWhithName:(NSString *)name andType:(NSString *)type;

- (void)activitiesReceivedNothing:(NSString *)type;

- (void)projectsReceived;

- (void)commentEnvoy;
- (void)taskListReceivedProject;

@required
	//Authenticate
- (void)correctAuthentication;
- (void)notHaveUser;
- (void)notCorrectUserOrPassword:(NSString *)username;

	//Server
- (void)errorCommunicateWithTeambox:(NSError *)error;

@end
