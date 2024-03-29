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
	NSMutableArray *activitiesData;
	BOOL secureConnection;
	NSTimer *refreshTimer;
}
#pragma mark Accessors
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
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
- (void)getActivitiesAllNew;
- (void)getActivitiesAllMore;
- (void)getActivitiesAllMorewithID:(NSString *)idActivity;

	//Recover the Activities of a Project
- (void)getActivitiesAllWithProject:(NSString *)name;
- (void)getActivitiesNewWithProject:(NSString *)name andSinceActivityID:(NSString *)firstID;
- (void)getActivitiesMoreWithProject:(NSString *)name andSinceActivityID:(NSString *)lastID;

	//Recover the Task List of a Project
- (void)getTaskList;
- (void)getTaskListWithProject:(NSString *)projectName;

	//Recover a User
- (void)getUser:(NSString *)username;
- (void)getUsers;

	//Recover the Projects
- (void)getProjects;

	//Recover Conversations
- (void)getConversationsWithProject:(NSString *)projectName;

	//Recover Pages
- (void)getPagesWithProject:(NSString *)projectName;

	//Recover the Files of a Project
- (void)getFiles:(NSString *)projectID;

	//Recover a File

	//Sending a Comment
- (void)postCommentWithProject:(NSString *)comment projectName:(NSString *)name;

- (void)authenticate;

@end
