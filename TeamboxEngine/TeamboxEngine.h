//
//  TeamboxEngine.h
//  Teambox
//
//  Created by 
//			Alejandro Julián López
//			Eduardo hernández Cano 
//	Created:26/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxEngineHeaders.h"
#import "TeamboxParserDelegate.h"
#import "TeamboxEngineDelegate.h"

@interface TeamboxEngine : NSObject <TeamboxParserDelegate> {
	__weak NSObject <TeamboxEngineDelegate> *engineDelegate;
	NSString *username;
	NSString *password;
	NSString *typeUser;
	BOOL secureConnection;
}
#pragma mark Accessors
@property (nonatomic, retain) NSString *typeUser;

+ (TeamboxEngine *)teamboxEngineWithDelegate:(NSObject *)theDelegate;
- (TeamboxEngine *)initWithDelegate:(NSObject *)delegate;

#pragma mark Configuration
- (void)setUseSecureConnection:(BOOL)useSecure;

	//===============================
	// Teambox API methods
	//===============================

	//Recover the Activities of All Projects
- (void)getActivitiesAll:(NSManagedObjectContext *)managedObjectContext;
- (void)getActivitiesAllNew:(NSString *)activityID;
- (void)getActivitiesAllMore:(NSString *)activityID;

	//Recover the Activities of a Project
- (void)getActivities:(NSString *)projectID;
- (void)getActivitiesNew:(NSString *)projectID sinceActivityID:(NSString *)firstID;
- (void)getActivitiesMore:(NSString *)projectID sinceActivityID:(NSString *)lastID;

	//Recover a User
- (void)getUser:(NSString *)username;

	//Recover the Projects
- (void)getProjects;

	//Recover the Files of a Project
- (void)getFiles:(NSString *)projectID;

	//Recover a File

	//Sending a Comment
- (void)postCommentWithProject:(NSString *)comment projectName:(NSString *)name;


@end
