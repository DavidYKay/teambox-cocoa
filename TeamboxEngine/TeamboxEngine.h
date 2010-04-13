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
#import "TeamboxConnectionDelegate.h"
#import "TeamboxParserDelegate.h"
#import "TeamboxEngineDelegate.h"

@interface TeamboxEngine : NSObject <TeamboxParserDelegate> {
	__weak NSObject <TeamboxEngineDelegate> *engineDelegate;
	NSString *username;
	NSString *password;
	NSString *typeUser;
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	BOOL secureConnection;
	NSTimer *refreshTimer;
}
#pragma mark Accessors
@property (nonatomic, retain) NSString *typeUser;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (TeamboxEngine *)teamboxEngineWithDelegate:(NSObject *)theDelegate;
- (TeamboxEngine *)initWithDelegate:(NSObject *)delegate;

#pragma mark Configuration
- (void)setUseSecureConnection:(BOOL)useSecure;

	//===============================
	// Teambox API methods
	//===============================

	//Configuration
- (void)setUsername:(NSString *)username Password:(NSString *)password;

	//Recover the Activities of All Projects
- (void)getActivitiesAll;
- (void)getActivitiesAllNew:(NSString *)activityID;
- (void)getActivitiesAllMore:(NSNumber *)activityID;

	//Recover the Activities of a Project
- (void)getActivities:(NSString *)projectID;
- (void)getActivitiesNew:(NSString *)projectID sinceActivityID:(NSString *)firstID;
- (void)getActivitiesMore:(NSString *)projectID sinceActivityID:(NSString *)lastID;

	//Recover the Task List of a Project
- (void)getTaskList;
- (void)getTaskListWithProject:(NSString *)projectName;

	//Recover a User
- (void)getUser:(NSString *)username;

	//Recover the Projects
- (void)getProjects;

	//Recover the Files of a Project
- (void)getFiles:(NSString *)projectID;

	//Recover a File

	//Sending a Comment
- (void)postCommentWithProject:(NSString *)comment projectName:(NSString *)name;

- (void)authenticate;

@end
