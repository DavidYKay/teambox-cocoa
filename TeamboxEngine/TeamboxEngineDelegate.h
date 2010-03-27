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

- (void)activitiesReceivedAll:(NSArray *)activities;
- (void)activitiesReceivedAllNew:(NSArray *)activities;
- (void)activitiesReceivedAllMore:(NSArray *)activities;
- (void)projectsReceived:(NSManagedObjectContext *)managedObjectContext;
- (void)activitiesReceivedNothing:(NSString *)type;



@required
	//Authenticate
- (void)correctAuthentication;
- (void)notHaveUser;
- (void)notCorrectUserOrPassword:(NSString *)username;

	//Server
- (void)errorCommunicateWithTeambox:(NSError *)error;

@end
