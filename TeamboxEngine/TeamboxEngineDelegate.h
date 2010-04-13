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

- (void)activitiesReceivedAll:(NSManagedObjectContext *)managedObjectContext;
- (void)activitiesReceivedAllNew:(NSManagedObjectContext *)managedObjectContext;
- (void)activitiesReceivedAllMore:(NSManagedObjectContext *)managedObjectContext;
- (void)projectsReceived:(NSManagedObjectContext *)managedObjectContext;
- (void)activitiesReceivedNothing:(NSString *)type;

- (void)taskListReceivedProject:(NSManagedObjectContext *)managedObjectContext;

@required
	//Authenticate
- (void)correctAuthentication;
- (void)notHaveUser;
- (void)notCorrectUserOrPassword:(NSString *)username;

	//Server
- (void)errorCommunicateWithTeambox:(NSError *)error;

@end
