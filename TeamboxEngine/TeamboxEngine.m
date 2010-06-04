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
#import "TeamboxUsersParser.h"
#import "TeamboxConversationsParser.h"
#import "TeamboxPagesParser.h"
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
@synthesize username;
@synthesize password;

+ (TeamboxEngine *)teamboxEngineWithDelegate:(NSObject *)delegate {
	return [[[TeamboxEngine alloc] initWithDelegate:delegate] autorelease];
}

- (TeamboxEngine *)initWithDelegate:(NSObject *)delegate {
	if (self = [super init]) {
		username = [[NSString alloc] initWithString:@""];
		password = [[NSString alloc] initWithString:@""];
		engineDelegate = delegate;
		if (![[NSUserDefaults standardUserDefaults] objectForKey:kLaunchDateSettingsKey]) {
			#if defined(LOCAL)
				[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"LOCALlastActivityParsed"];
				[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"LOCALlastMoreActivityParsed"];
			#else
				[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"lastActivityParsed"];
				[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"lastMoreActivityParsed"];
			#endif
			[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"sidebarActivity"];
			#if TARGET_OS_MAC
				[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"growlNotifications"];
				[[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"PREStartLogin"];
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
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllXML, username, [password retain]]] type:@"ActivitiesAll" delegate:self];
		//[TeamboxActivitiesParser parserWithURL:url delegate:self typeParse:@"ActivitiesAll"];
	#if defined(DEBUG)
		NSLog(@"getActivitiesAll");
	#endif
}

- (void)getActivitiesAllNew {
	activitiesData = [[NSMutableArray alloc] initWithCapacity:0];
	#if defined(LOCAL)
		NSLog(@"getActivitiesAllNew activity:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"LOCALlastActivityParsed"]);
		[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllNewXML, username, [password retain], [[NSUserDefaults standardUserDefaults] valueForKey:@"LOCALlastActivityParsed"]]] type:@"ActivitiesAllNew" delegate:self];
	#else
		#if defined(DEBUG)
			NSLog(@"getActivitiesAllNew activity:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lastActivityParsed"]);
		#endif
		[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllNewXML, username, [password retain], [[NSUserDefaults standardUserDefaults] valueForKey:@"lastActivityParsed"]]] type:@"ActivitiesAllNew" delegate:self];
	#endif
}

- (void)getActivitiesAllMore {
	#if defined(LOCAL)
		NSLog(@"%@",[NSString stringWithFormat:@"getActivitiesAllMore activity:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"LOCALlastMoreActivityParsed"]]);
		[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllMoreXML, username, [password retain], [[NSUserDefaults standardUserDefaults] valueForKey:@"LOCALlastMoreActivityParsed"]]] type:@"ActivitiesAllMore" delegate:self];
	#else
		#if defined(DEBUG)
			NSLog(@"%@",[NSString stringWithFormat:@"getActivitiesAllMore activity:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lastMoreActivityParsed"]]);
		#endif
		[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllMoreXML, username, [password retain], [[NSUserDefaults standardUserDefaults] valueForKey:@"lastMoreActivityParsed"]]] type:@"ActivitiesAllMore" delegate:self];
	#endif
}

- (void)getActivitiesAllMorewithID:(NSString *)idActivity {
	#if defined(DEBUG)
		NSLog(@"ENTER getActivitiesAllMorewithID %@",idActivity);
	#endif
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllMoreXML, username, [password retain], idActivity]] type:@"ActivitiesAllMoreNew" delegate:self];
	#if defined(DEBUG)
		NSLog(@"EXIT getActivitiesAllMorewithID %@",idActivity);
	#endif
}

- (void)getActivitiesAllWithProject:(NSString *)name {
	#if defined(DEBUG)
		NSLog(@"ENTER getActivitiesAllWithProject %@", name);
	#endif
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesProjectAllXML, username, [password retain], name]] type:@"ActivitiesProjectAll" projectName:name delegate:self];
	#if defined(DEBUG)
		NSLog(@"EXIT getActivitiesAllWithProject %@", name);
	#endif
}

- (void)getActivitiesNewWithProject:(NSString *)name andSinceActivityID:(NSString *)firstID {
	#if defined(DEBUG)
		NSLog(@"ENTER getActivitiesNewWithProject %@", name);
	#endif
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesProjectNewXML, username, [password retain], name, firstID]] type:@"ActivitiesProjectNew" projectName:name delegate:self];
	#if defined(DEBUG)
		NSLog(@"EXIT getActivitiesNewWithProject %@", name);
	#endif
}

- (void)getActivitiesMoreWithProject:(NSString *)name andSinceActivityID:(NSString *)lastID {
	#if defined(DEBUG)
		NSLog(@"ENTER getActivitiesMoreWithProject %@", name);
	#endif
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KActivitiesProjectMoreXML, username, [password retain], name, lastID]] type:@"ActivitiesProjectMore" projectName:name delegate:self];
	#if defined(DEBUG)
		NSLog(@"EXIT getActivitiesMoreWithProject %@", name);
	#endif
}

- (void)getTaskList {
#if defined(DEBUG)
	NSLog(@"------ ENTER getTaskList \n");
#endif
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KTaskListXML, username, [password retain]]] type:@"TaskListProject" delegate:self];
}

- (void)getTaskListWithProject:(NSString *)projectName {
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KTaskListWithProjectXML, username, [password retain], projectName]] type:@"TaskListProject" delegate:self];
	#if defined(DEBUG)
		NSLog(@"%@",[NSString stringWithFormat:@"getTaskListWithProject project:%@", projectName]);
	#endif
}

- (void)getConversationsWithProject:(NSString *)projectName {
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KConversationsWithProjectXML, username, [password retain], projectName]] type:@"Conversations" delegate:self];
}

- (void)getPagesWithProject:(NSString *)projectName {
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KPagesWithProjectXML, username, [password retain], projectName]] type:@"Pages" delegate:self];
}

- (void)getUser:(NSString *)username {
	
}

- (void)getUsers {
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:kUsersXML, username, [password retain]]] type:@"Users" delegate:self];
	#if defined(DEBUG)
		NSLog(@"getUsers");
	#endif
}

- (void)getProjects {
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KProjectsXML, username, [password retain]]] type:@"Projects" delegate:self];
	#if defined(DEBUG)
		NSLog(@"getProjects");
	#endif
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
																[password retain],
																aProject.permalink]] 
								  comment:comment delegate:self];
	#if defined(DEBUG)
		NSLog(@"Exit postCommentWithProject");
	#endif
}

- (void)parserFailedWithError:(NSError *)errorMsg {
	#if defined(DEBUG)
		NSLog(@"error %@",errorMsg);
	#endif
}

- (void)finishedGetData:(NSData *)data withType:(NSString *)type {
#if defined(DEBUG)
	NSLog(@"------ ENTER FinishedGetData WithType: %@ \n", type);
#endif
	
	if ([type isEqualToString:@"Projects"])
		[TeamboxProjectsParser parserWithData:data typeParse:type managedObjectContext:managedObjectContext delegate:self];
	else if ([type isEqualToString:@"TaskListProject"])
		[TeamboxTaskListsParser parserWithData:data typeParse:type managedObjectContext:managedObjectContext delegate:self];
	else if ([type isEqualToString:@"Conversations"])
		[TeamboxConversationsParser parserWithData:data typeParse:type managedObjectContext:managedObjectContext delegate:self];
	else if ([type isEqualToString:@"Pages"])
		[TeamboxPagesParser parserWithData:data typeParse:type managedObjectContext:managedObjectContext delegate:self];
	else if ([type isEqualToString:@"ActivitiesAll"] || [type isEqualToString:@"ActivitiesAllNew"] || 
			 [type isEqualToString:@"ActivitiesAllMore"] || [type isEqualToString:@"ActivitiesAllMoreNew"] ||
			 [type isEqualToString:@"ActivitiesProjectAll"]) {
			//temporary solution, must give back 0 (! = nil) 
		if ([data length] > 67) {
			if ([type isEqualToString:@"ActivitiesAllNew"] || [type isEqualToString:@"ActivitiesAllMoreNew"])
				[activitiesData addObject:data];
			[TeamboxActivitiesParser parserWithData:data typeParse:type managedObjectContext:managedObjectContext delegate:self];
		}
		else
			[engineDelegate activitiesReceivedNothing:type];
	} else if ([type isEqualToString:@"Users"]) {
		[TeamboxUsersParser parserWithData:data typeParse:type managedObjectContext:managedObjectContext delegate:self];
	}
#if defined(DEBUG)
	NSLog(@"------ EXIT FinishedGetData WithType %@ \n", type);
#endif
}
	
- (void)finishedGetData:(NSData *)data withType:(NSString *)type andProjectName:(NSString *)projectName {
	if ([type isEqualToString:@"ActivitiesProjectAll"] || [type isEqualToString:@"ActivitiesProjectMore"]) {
			//temporary solution, must give back 0 (! = nil) 
		if ([data length] > 67)
			[TeamboxActivitiesParser parserWithData:data typeParse:type projectName:projectName managedObjectContext:managedObjectContext delegate:self];
		else
			[engineDelegate activitiesReceivedNothing:type withProject:projectName];
	} else if ([type isEqualToString:@"Comment"]) {
		[engineDelegate commentEnvoy];
		[self getActivitiesAllNew];
	}
}

- (void)parserFinishedType:(NSString *)type {
#if defined(DEBUG)
	NSLog(@"------ ENTER ParserFinishedType: %@ \n", type);
#endif
	if ([type isEqualToString:@"Projects"])
		[engineDelegate projectsReceived];
	else if ([type isEqualToString:@"ActivitiesAll"])
		[engineDelegate activitiesReceivedAll];
	else if ([type isEqualToString:@"ActivitiesAllNew"]) {
		[activitiesData release];
		[engineDelegate activitiesReceivedAllNew];
	} else if ([type isEqualToString:@"ActivitiesAllMoreNew"])
		[TeamboxActivitiesParser parserWithActivities:activitiesData managedObjectContext:managedObjectContext delegate:self];
	else if ([type isEqualToString:@"ActivitiesAllMore"])
		[engineDelegate activitiesReceivedAllMore];
	else if ([type isEqualToString:@"TaskListProject"])
		[engineDelegate taskListReceivedProject];
	else if ([type isEqualToString:@"Conversations"])
		[engineDelegate conversationsReceived];
	else if ([type isEqualToString:@"Pages"])
		[engineDelegate pagesReceived];
#if defined(DEBUG)
	NSLog(@"------ EXIT ParserFinishedType %@ \n", type);
#endif
}

- (void)parserFinishedType:(NSString *)type projectName:(NSString *)name {
	#if defined(DEBUG)
		NSLog(@"Exit parserFinishedType:%@ Project:%@", type, name);
	#endif
	if ([type isEqualToString:@"ActivitiesProjectAll"])
		[engineDelegate activitiesReceivedProjectAllWhithName:name andType:type];
	else if ([type isEqualToString:@"ActivitiesProjectNew"])
		[engineDelegate activitiesReceivedProjectNewWhithName:name andType:type];
	else if ([type isEqualToString:@"ActivitiesProjectMore"])
		[engineDelegate activitiesReceivedProjectMoreWhithName:name andType:type];
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
	username = [[NSUserDefaults standardUserDefaults] valueForKey:kUserNameSettingsKey];
	if (username == nil) {
		[engineDelegate notHaveUser];
	} else {
			NSError *nError;
			password = [TeamboxEngineKeychain getPasswordForUsername:username error:&nError];
		if ([[password retain] isEqualToString:@""])
			[engineDelegate notCorrectUserOrPassword:username];
		else
			[TeamboxConnection authenticateWithUsername:username
											andPassword:[password retain] 
													url:[NSURL URLWithString:[NSString stringWithFormat:KTeamboxURL]] 
												   type:@"Login" 
											   delegate:self];
	}
}

- (void)finishedConnectionLogin {
	refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60 //180
													target:self selector:@selector(getActivitiesAllNew) userInfo:nil 
												   repeats:YES];
	username = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[NSUserDefaults standardUserDefaults] valueForKey:kUserNameSettingsKey], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	[engineDelegate correctAuthentication];
}

- (void)errorAuthentication {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	username = [defaults valueForKey:kUserNameSettingsKey];
	[engineDelegate notCorrectUserOrPassword:username];
}

- (void)errorConnectionLogin:(NSError *)error {
#if defined(DEBUG)
	NSLog(@"------ ErrorConnectionLogin \n");
#endif
	[engineDelegate notCorrectUserOrPassword:username];
		//[engineDelegate errorCommunicateWithTeambox:error];
#if defined(DEBUG)
	NSLog(@"------ END ErrorConnection \n");
#endif
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
