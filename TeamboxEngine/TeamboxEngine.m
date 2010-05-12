//
//  TeamboxEngine.m
//  Teambox
//
//  Created by 
//			Alejandro Julián López
//			Eduardo hernández Cano 
//	Created:26/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxEngine.h"
#import "TeamboxActivitiesParser.h"
#import "TeamboxProjectsParser.h"
#import "TeamboxTaskListsParser.h"
#import "TeamboxConnection.h"
#import "TeamboxEngineKeychain.h"
#import "ActivityModel.h"
#import "ProjectModel.h"

@interface TeamboxEngine (PrivateMethods)

@end

@implementation TeamboxEngine

@synthesize typeUser;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

+ (TeamboxEngine *)teamboxEngineWithDelegate:(NSObject *)delegate {
	return [[[TeamboxEngine alloc] initWithDelegate:delegate] autorelease];
}

- (TeamboxEngine *)initWithDelegate:(NSObject *)delegate {
	if (self = [super init]) {
		username = [NSString alloc];
		password = [NSString alloc];
		engineDelegate = delegate;
		if (![[NSUserDefaults standardUserDefaults] objectForKey:kLaunchDateSettingsKey]) {
			#if defined(LOCAL)
				[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"LOCALlastActivityParsed"];
				[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"LOCALlastMoreActivityParsed"];
			#else
				[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"lastActivityParsed"];
				[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"lastMoreActivityParsed"];
			#endif
		}
		[[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:kLaunchDateSettingsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
		managedObjectContext = self.managedObjectContext;
    }
    return self;
}

	//Configuration
- (void)setUsername:(NSString *)userName Password:(NSString *)Password {
	NSError *nError;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:userName forKey:kUserNameSettingsKey];
	[defaults synchronize];
	
	[TeamboxEngineKeychain storePasswordForUsername:userName Password:Password error:&nError];
	[self authenticate];
}

- (void)getActivitiesAll {
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllXML, username, password]] type:@"ActivitiesAll" delegate:self];
		//[TeamboxActivitiesParser parserWithURL:url delegate:self typeParse:@"ActivitiesAll"];
	NSLog(@"getActivitiesAll");
}

- (void)getActivitiesAllNew {
	#if defined(LOCAL)
		NSLog(@"%@",[NSString stringWithFormat:@"getActivitiesAllNew activity:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"LOCALlastActivityParsed"]]);
		[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllNewXML, username, password, [[NSUserDefaults standardUserDefaults] valueForKey:@"LOCALlastActivityParsed"]]] type:@"ActivitiesAllNew" delegate:self];
	#else
		NSLog(@"%@",[NSString stringWithFormat:@"getActivitiesAllNew activity:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lastActivityParsed"]]);
		[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllNewXML, username, password, [[NSUserDefaults standardUserDefaults] valueForKey:@"lastActivityParsed"]]] type:@"ActivitiesAllNew" delegate:self];
	#endif
}

- (void)getActivitiesAllNew:(NSString *)activityID {
		//NSString *path = [NSString stringWithFormat:KActivitiesAllNewXML, username, password, activityID];
}

- (void)getActivitiesAllMore {
	#if defined(LOCAL)
		NSLog(@"%@",[NSString stringWithFormat:@"getActivitiesAllMore activity:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"LOCALlastMoreActivityParsed"]]);
		[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllMoreXML, username, password, [[NSUserDefaults standardUserDefaults] valueForKey:@"LOCALlastMoreActivityParsed"]]] type:@"ActivitiesAllMore" delegate:self];
	#else
		NSLog(@"%@",[NSString stringWithFormat:@"getActivitiesAllMore activity:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lastMoreActivityParsed"]]);
		[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllMoreXML, username, password, [[NSUserDefaults standardUserDefaults] valueForKey:@"lastMoreActivityParsed"]]] type:@"ActivitiesAllMore" delegate:self];
	#endif
}

- (void)getActivities:(NSString *)projectID {
	
}

- (void)getActivitiesNew:(NSString *)projectID sinceActivityID:(NSString *)firstID {
	
}

- (void)getActivitiesMore:(NSString *)projectID sinceActivityID:(NSString *)lastID {
	
}

- (void)getTaskList {
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KTaskListXML, username, password]] type:@"TaskListProject" delegate:self];
}

- (void)getTaskListWithProject:(NSString *)projectName {
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KTaskListWithProjectXML, username, password, projectName]] type:@"TaskListProject" delegate:self];
	NSLog(@"%@",[NSString stringWithFormat:@"getTaskListWithProject project:%@", projectName]);
}

- (void)getUser:(NSString *)username {
	
}

- (void)getProjects {
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KProjectsXML, username, password]] type:@"Projects" delegate:self];
	NSLog(@"getProjects");
}

- (void)finishedGetData:(NSData *)data withType:(NSString *)type {
	if ([type isEqualToString:@"Projects"])
		[TeamboxProjectsParser parserWithData:data typeParse:type managedObjectContext:managedObjectContext delegate:self];
	else if ([type isEqualToString:@"ActivitiesAll"] || [type isEqualToString:@"ActivitiesAllNew"] || [type isEqualToString:@"ActivitiesAllMore"]) {
			//temporary solution, must give back 0 (! = nil) 
		if ([data length] > 67)
			[TeamboxActivitiesParser parserWithData:data typeParse:type managedObjectContext:managedObjectContext delegate:self];
		else
			[engineDelegate activitiesReceivedNothing:type];
	} else if ([type isEqualToString:@"TaskListProject"])
		[TeamboxTaskListsParser parserWithData:data typeParse:type managedObjectContext:managedObjectContext delegate:self];
	else if ([type isEqualToString:@"Comment"]) {
		[engineDelegate commentEnvoy];
		[self getActivitiesAllNew];
	}
}

- (void)setUseSecureConnection:(BOOL)useSecure {
	
}

- (void)getFiles:(NSString *)projectID {
	
}

- (void)postCommentWithProject:(NSString *)comment projectName:(NSString *)name {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"ANY name == %@", name]];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext]];
	NSError *error;
	 ProjectModel *aProject = [[managedObjectContext  executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
	[fetchRequest release];
	
	[TeamboxConnection postCommentWithUrl:[NSURL URLWithString:[NSString stringWithFormat:KPostComment, 
																username, 
																password,
																aProject.permalink]] 
								  comment:comment delegate:self];
	NSLog(@"Exit postCommentWithProject");
}

- (void)parserFailedWithError:(NSError *)errorMsg {
	NSLog(@"error %@",errorMsg);
}

- (void)parserFinishedType:(NSString *)type {
	if ([type isEqualToString:@"Projects"])
		[engineDelegate projectsReceived];
	else if ([type isEqualToString:@"ActivitiesAll"])
		[engineDelegate activitiesReceivedAll];
	else if ([type isEqualToString:@"ActivitiesAllNew"])
		[engineDelegate activitiesReceivedAllNew];
	else if ([type isEqualToString:@"ActivitiesAllMore"])
		[engineDelegate activitiesReceivedAllMore];
	else if ([type isEqualToString:@"TaskListProject"])
		[engineDelegate taskListReceivedProject];
	
		/*if ([type isEqualToString:@"ActivitiesAll"])
			[engineDelegate activitiesReceivedAll:parsedElements];
		else if ([type isEqualToString:@"ActivitiesAllNew"])
			[engineDelegate activitiesReceivedAllNew:parsedElements];
		else if ([type isEqualToString:@"ActivitiesAllMore"])
			[engineDelegate activitiesReceivedAllMore:parsedElements];
		else if ([type isEqualToString:@"Projects"])
			[engineDelegate projectsReceived:parsedElements];
		//[engineDelegate activitiesReceivedNothing:type]; */
	NSLog(@"Exit parserFinishedType %@ ", type);
}

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSURL *storeUrl;
	
	#if TARGET_OS_MAC
		[[NSFileManager defaultManager] createDirectoryAtPath:[[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject] 
														stringByAppendingPathComponent: @"Teambox"] withIntermediateDirectories:TRUE  attributes:nil error:nil];
	#endif
	#if defined(LOCAL)
		#if TARGET_OS_IPHONE
			storeUrl = [NSURL fileURLWithPath: [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"TeamboxLOCAL.sqlite"]];
		#else
			storeUrl = [NSURL fileURLWithPath: [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"/Teambox/TeamboxLOCAL.sqlite"]];
		#endif
	#else
		#if TARGET_OS_IPHONE
			storeUrl = [NSURL fileURLWithPath: [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"Teambox.sqlite"]];
		#else
			storeUrl = [NSURL fileURLWithPath: [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"/Teambox/Teambox.sqlite"]];
		#endif
	#endif
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}

- (void)authenticate {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	username = [defaults valueForKey:kUserNameSettingsKey];
	if (username == nil) {
		[engineDelegate notHaveUser];
	} else {
			NSError *nError;
			password = [TeamboxEngineKeychain getPasswordForUsername:username error:&nError];
		if ([password isEqualToString:@""])
			[engineDelegate notCorrectUserOrPassword:username];
		else
			[TeamboxConnection authenticateWithUsername:username andPassword:password url:[NSURL URLWithString:[NSString stringWithFormat:KTeamboxURL]] type:@"Login" delegate:self];
	}
}

- (void)finishedConnectionLogin {
	refreshTimer = [NSTimer scheduledTimerWithTimeInterval:180 //180
													target:self selector:@selector(getActivitiesAllNew) userInfo:nil 
												   repeats:YES];
	[engineDelegate correctAuthentication];
}

- (void)errorAuthentication {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	username = [defaults valueForKey:kUserNameSettingsKey];
	[engineDelegate notCorrectUserOrPassword:username];
}

- (void)errorConnectionLogin:(NSError *)error {
	[engineDelegate errorCommunicateWithTeambox:error];
}

- (void)setFirstActivityID {
	
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */

- (void)dealloc {
	[username release];
	[password release];
	[super dealloc];
}

@end
