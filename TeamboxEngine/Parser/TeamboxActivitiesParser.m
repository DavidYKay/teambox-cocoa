	//
	//  TeamboxActivitiesParser.m
	//  Teambox
	//
	//  Created by Alejandro Julián López on 26/02/10.
	//  Copyright 2010 Teambox. All rights reserved.
	//

#import "TeamboxActivitiesParser.h"
#import "ActivityModel.h"
#import "CommentModel.h"
#import "ProjectModel.h"
#import "UserModel.h"
#import "Project_UserModel.h"
#import "TaskModel.h"
#import "TaskListModel.h"
#import "PageModel.h"
#import "ConversationModel.h"
#import "UploadModel.h"

@interface  TeamboxActivitiesParser (Private) 

- (void)addUser:(NSNumber *)userID WithUsername:(NSString *)username ForProject:(NSNumber *)projectID projectName:(NSString *)andProjectName permalink:(NSString *)permalink;
- (void)addUser:(int)userID WithUsername:(NSString *)username AndFirstName:(NSString *)firstname AndLastName:(NSString *)lastname;
- (void)addActivitiesWithAllOrNew:(TBXMLElement *)activity;
- (void)addActivitiesWithMore:(TBXMLElement *)activity;

@end

@implementation TeamboxActivitiesParser

- (void)parserAndAddCoreData {
	TBXMLElement *root = parser.rootXMLElement;
	if (root) {
		TBXMLElement *activity = [TBXML childElementNamed:@"activity" parentElement:root];
		if ([typeParse isEqualToString:@"ActivitiesAll"] || [typeParse isEqualToString:@"ActivitiesAllNew"] || 
			[typeParse isEqualToString:@"ActivitiesProjectAll"] || [typeParse isEqualToString:@"ActivitiesAllMore"]) {
			int countActivities = 0;
			int64_t lasActivity = 0;
			int64_t lasSaveActivity = 0;
			if ([typeParse isEqualToString:@"ActivitiesAllNew"]) {
				#if defined(LOCAL)
					lasSaveActivity = [[[NSUserDefaults standardUserDefaults] valueForKey:@"LOCALlastActivityParsed"] intValue];
				#else
					lasSaveActivity = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lastActivityParsed"] intValue];
				#endif
			}
			if ([typeParse isEqualToString:@"ActivitiesAllNew"] || [typeParse isEqualToString:@"ActivitiesAll"] && activity != nil) {
				#if defined(LOCAL)
					[[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"LOCALlastActivityParsed"]intValue] forKey:@"sidebarActivity"];
					[[NSUserDefaults standardUserDefaults] setInteger:[[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue] forKey:@"LOCALlastActivityParsed"];
				#else
					[[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] valueForKey:@"lastActivityParsed"]intValue] forKey:@"sidebarActivity"];
					[[NSUserDefaults standardUserDefaults] setInteger:[[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue] forKey:@"lastActivityParsed"];
				#endif
			}
			while (activity != nil) {
				countActivities++;
					//NSLog(@"%@", [TBXML valueOfAttributeNamed:@"id" forElement:activity]);
				activity = [TBXML nextSiblingNamed:@"activity" searchFromElement:activity];
			}
			countActivities--;
			
			activity = [TBXML childElementNamed:@"activity" parentElement:root];
			int x = 1;
			while (x <= countActivities) {
				activity = [TBXML nextSiblingNamed:@"activity" searchFromElement:activity];
				x++;
			}
			
			if ([typeParse isEqualToString:@"ActivitiesAllNew"]) 
				lasActivity = [[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue];
			
			if ([typeParse isEqualToString:@"ActivitiesAll"] || [typeParse isEqualToString:@"ActivitiesAllMore"]) {
				#if defined(LOCAL)
					[[NSUserDefaults standardUserDefaults] setInteger:[[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue] forKey:@"LOCALlastMoreActivityParsed"];
				#else
					[[NSUserDefaults standardUserDefaults] setInteger:[[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue] forKey:@"lastMoreActivityParsed"];
				#endif
			}
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			if ([typeParse isEqualToString:@"ActivitiesAll"] || [typeParse isEqualToString:@"ActivitiesProjectAll"])
				[self addActivitiesWithAllOrNew:activity];
			if ([typeParse isEqualToString:@"ActivitiesAllNew"]) {
				if (countActivities == 24) {
					if (lasActivity-- == lasSaveActivity) {
						[self addActivitiesWithAllOrNew:activity];
						[delegate parserFinishedType:@"ActivitiesAll"];
					} else {
						[[NSUserDefaults standardUserDefaults] setInteger:lasSaveActivity forKey:@"LasSaveActivity"];
						[[NSUserDefaults standardUserDefaults] synchronize];
						[delegate getActivitiesAllMorewithID:[NSString stringWithFormat:@"%d", ++lasActivity]];
					}
				} else {
					[self addActivitiesWithAllOrNew:activity];
					[delegate parserFinishedType:typeParse];
				}
				
			} else if ([typeParse isEqualToString:@"ActivitiesProjectAll"])
				[delegate parserFinishedType:typeParse projectName:projectName];
			else if ([typeParse isEqualToString:@"ActivitiesAllMore"]) {
				activity = [TBXML childElementNamed:@"activity" parentElement:root];
				[self addActivitiesWithAllOrNew:activity];
				[delegate parserFinishedType:typeParse];
			} else
				[delegate parserFinishedType:typeParse];
		} else if ([typeParse isEqualToString:@"ActivitiesAllMoreNew"]) {
			int countActivities = 0;
			int64_t lasActivity = 0;
			NSString *saveActivity = [[[NSUserDefaults standardUserDefaults] valueForKey:@"LasSaveActivity"] stringValue];
			while (activity != nil) {
				if (![[TBXML valueOfAttributeNamed:@"id" forElement:activity] isEqualToString:saveActivity]) {
						//NSLog(@"%@ es igual a %@", [TBXML valueOfAttributeNamed:@"id" forElement:activity], saveActivity);
					countActivities++;
					activity = [TBXML nextSiblingNamed:@"activity" searchFromElement:activity];
				} else
					break;
			} 
			if (countActivities) {
				countActivities--;
				activity = [TBXML childElementNamed:@"activity" parentElement:root];
				int x = 1;
				while (x <= countActivities) {
					activity = [TBXML nextSiblingNamed:@"activity" searchFromElement:activity];
					x++;
				}
				lasActivity = [[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue];
				if (countActivities == 24) {
					
					if (lasActivity-- == [[[NSUserDefaults standardUserDefaults] valueForKey:@"LasSaveActivity"] intValue])
						[delegate parserFinishedType:@"ActivitiesAllMoreNew"];
					else {
						[delegate getActivitiesAllMorewithID:[NSString stringWithFormat:@"%d", lasActivity++]];
					}
				} else
					[delegate parserFinishedType:@"ActivitiesAllMoreNew"];
			} else
				[delegate parserFinishedType:@"ActivitiesAllMoreNew"];
		} else if ([typeParse isEqualToString:@"ActivitiesAllNewWithData"]) {
			int countActivities = 0;
			NSString *saveActivity = [[[NSUserDefaults standardUserDefaults] valueForKey:@"LasSaveActivity"] stringValue];
			while (activity != nil) {
				if (![[TBXML valueOfAttributeNamed:@"id" forElement:activity] isEqualToString:saveActivity]) {
						//NSLog(@"%@ es igual a %@", [TBXML valueOfAttributeNamed:@"id" forElement:activity], saveActivity);
					countActivities++;
					activity = [TBXML nextSiblingNamed:@"activity" searchFromElement:activity];
				} else
					break;
			}
			countActivities--;
			activity = [TBXML childElementNamed:@"activity" parentElement:root];
			int x = 1;
			while (x <= countActivities) {
				activity = [TBXML nextSiblingNamed:@"activity" searchFromElement:activity];
				x++;
			}
			[self addActivitiesWithAllOrNew:activity];
		} else {
			[self addActivitiesWithAllOrNew:activity];
			[delegate parserFinishedType:typeParse projectName:projectName];
		}
	}
}

- (void)addActivitiesWithAllOrNew:(TBXMLElement *)activity {
#if defined(DEBUG)
	NSLog(@"------ Parseando actividades \n");
#endif
	[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT: 0]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSError *error;
	while (activity != nil) {
		ActivityModel *aActivity;
		TBXMLElement *target = [TBXML childElementNamed:@"target" parentElement:activity];
		TBXMLElement *project = [TBXML childElementNamed:@"project" parentElement:activity];
		
		fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext]];
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"project_id=%i",[[TBXML valueOfAttributeNamed:@"id" forElement:project] intValue]]];
		ProjectModel *aProject = [[managedObjectContext  executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
		[fetchRequest release];

		TBXMLElement *user = [TBXML childElementNamed:@"user" parentElement:activity];
		fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext]];
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user_id == %i", [[TBXML valueOfAttributeNamed:@"id" forElement:user] intValue]]];
		UserModel *mUser;
		@try {
			mUser = [[managedObjectContext  executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
		} @catch (NSException *e) {
			mUser = (UserModel *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
			mUser.user_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:user] intValue]];
			mUser.username = [TBXML textForElement:[TBXML childElementNamed:@"username" parentElement:user]];
			mUser.first_name = [TBXML textForElement:[TBXML childElementNamed:@"first-name" parentElement:user]];
			mUser.last_name = [TBXML textForElement:[TBXML childElementNamed:@"last-name" parentElement:user]];
			mUser.avatar_url = [TBXML textForElement:[TBXML childElementNamed:@"avatar-url" parentElement:user]];
			mUser.full_name = [NSString stringWithFormat:@"%@ %@", mUser.first_name, mUser.last_name];
			mUser.abbreviation_name = [NSString stringWithFormat:@"%c. %@", [mUser.first_name characterAtIndex:0], mUser.last_name];
		} @finally {
			[fetchRequest release];
		}

		aActivity = (ActivityModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		aActivity.activity_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue]];
		aActivity.action = [TBXML textForElement:[TBXML childElementNamed:@"action" parentElement:activity]];
		aActivity.created_at = [dateFormatter dateFromString:[TBXML textForElement:[TBXML childElementNamed:@"created-at" parentElement:activity]]];
		aActivity.created_at_string = [TBXML textForElement:[TBXML childElementNamed:@"created-at" parentElement:activity]];
		aActivity.target_type = [TBXML textForElement:[TBXML childElementNamed:@"type" parentElement:target]];
		aActivity.user_id = mUser.user_id;
		aActivity.Project = aProject;
		aActivity.project_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:project] intValue]];
		
		if (![aActivity.target_type isEqualToString:@"Person"])
			[mUser addActivityObject:aActivity];
			//Create
		if ([aActivity.action isEqualToString:@"create"]) {
			if ([aActivity.target_type isEqualToString:@"Comment"]) {
				#if defined(PARSER)
					NSLog(@"Enter %@", aActivity.target_type);
				#endif
				CommentModel *aComment;
				TBXMLElement *comment = [TBXML childElementNamed:@"comment" parentElement:target];
				aActivity.comment_type = [TBXML textForElement:[TBXML childElementNamed:@"target-type" parentElement:comment]];
				aComment = (CommentModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:managedObjectContext];
				aComment.body = [TBXML stringByDecodingXMLEntities:[[[TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"body" parentElement:comment]]] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@" "] ];
				
				aComment.body_html = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"body-html" parentElement:comment]]];
				aComment.target_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"target-id" forElement:comment] intValue]];
				aComment.target_type = [TBXML textForElement:[TBXML childElementNamed:@"target-type" parentElement:comment]];
				if ([aComment.target_type isEqualToString:@"Project"]) {
				} else if ([aComment.target_type isEqualToString:@"Task"]) {
					#if defined(PARSER)
						NSLog(@" Enter %@", aComment.target_type);
					#endif
					if ([TBXML childElementNamed:@"status" parentElement:comment] != nil)
						aComment.status = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"status" parentElement:comment]] intValue]];
					if ([TBXML childElementNamed:@"previous-status" parentElement:comment] != nil)
						aComment.previous_status = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"previous-status" parentElement:comment]] intValue]];
					if ([TBXML childElementNamed:@"assigned-id" parentElement:comment] != nil)
						aComment.assigned_id = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"assigned-id" parentElement:comment]] intValue]];
					if ([TBXML childElementNamed:@"previous-assigned-id" parentElement:comment] != nil)
						aComment.previous_assigned_id = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"previous-assigned-id" parentElement:comment]] intValue]];
					NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
					[fetchRequest setEntity:[NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext]];
					[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"task_id = %@", [TBXML textForElement:[TBXML childElementNamed:@"target-id" parentElement:comment]]]];
					TaskModel *mTask = [[managedObjectContext  executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
					[fetchRequest release];
					aActivity.Task = mTask;
					#if defined(PARSER)
						NSLog(@" Exit %@", aComment.target_type);
					#endif
				} else if ([aComment.target_type isEqualToString:@"Conversation"]) {
					#if defined(PARSER)
						NSLog(@" Enter %@", aComment.target_type);
					#endif
					NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
					[fetchRequest setEntity:[NSEntityDescription entityForName:@"Conversation" inManagedObjectContext:managedObjectContext]];
					[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"conversation_id = %@", [TBXML textForElement:[TBXML childElementNamed:@"target-id" parentElement:comment]]]];
					ConversationModel *mConversation = [[managedObjectContext  executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
					[fetchRequest release];
					aActivity.Conversation = mConversation;
					#if defined(PARSER)
						NSLog(@" Exit %@", aComment.target_type);
					#endif
				}
				
				aActivity.Comment = aComment;
				#if defined(PARSER)
					NSLog(@"Exit %@", aActivity.target_type);
				#endif
			} else if ([aActivity.target_type isEqualToString:@"Task"]) {
				#if defined(PARSER)
					NSLog(@"Enter Task");
				#endif
				TBXMLElement *task = [TBXML childElementNamed:@"task" parentElement:target];
				NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
				[fetchRequest setEntity:[NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext]];
				[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"task_id = %@", [TBXML valueOfAttributeNamed:@"id" forElement:task]]];
				TaskModel *mTask;
				@try {
					mTask = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
				} @catch (NSException *e) {
					mTask = (TaskModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:managedObjectContext];
					mTask.task_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:task] intValue]];;
					mTask.name = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:task]]];
					mTask.status = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"status" parentElement:task]] intValue]];
					
					TBXMLElement *taskList = [TBXML childElementNamed:@"task_list" parentElement:task];
					NSFetchRequest *fetchRequestTask = [[NSFetchRequest alloc] init];
					[fetchRequestTask setEntity:[NSEntityDescription entityForName:@"TaskList" inManagedObjectContext:managedObjectContext]];
					[fetchRequestTask setPredicate:[NSPredicate predicateWithFormat:@"tasklist_id = %@", [TBXML valueOfAttributeNamed:@"id" forElement:taskList]]];
					TaskListModel *aTaskList = [[managedObjectContext  executeFetchRequest:fetchRequestTask error:&error] objectAtIndex:0];
					mTask.task_list_id = aTaskList.tasklist_id;
					[aTaskList addTaskObject:mTask];
					[fetchRequestTask release];
				} @finally {
					[fetchRequest release];
				}
				aActivity.Task = mTask;
				#if defined(PARSER)
					NSLog(@"Exit Task");
				#endif
			} else if ([aActivity.target_type isEqualToString:@"TaskList"]) {
				#if defined(PARSER)
					NSLog(@"Enter TaskList");
				#endif
				TBXMLElement *taskList = [TBXML childElementNamed:@"task_list" parentElement:target];
				NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
				[fetchRequest setEntity:[NSEntityDescription entityForName:@"TaskList" inManagedObjectContext:managedObjectContext]];
				[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tasklist_id = %@", [TBXML valueOfAttributeNamed:@"id" forElement:taskList]]];
				
				TaskListModel *mTaskList;
				@try {
					mTaskList = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
				} @catch (NSException *e) {
					mTaskList = (TaskListModel *)[NSEntityDescription insertNewObjectForEntityForName:@"TaskList" inManagedObjectContext:managedObjectContext];
					mTaskList.tasklist_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:taskList] intValue]];
					mTaskList.project_id = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"project-id" parentElement:taskList]] intValue]];
					mTaskList.user_id = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"user-id" parentElement:taskList]] intValue]];
					mTaskList.position = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"position" parentElement:taskList]] intValue]];
					mTaskList.name = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:taskList]]];
				} @finally {
					[fetchRequest release];
				}
				aActivity.TaskList = mTaskList;
				#if defined(PARSER)
					NSLog(@"Exit TaskList");
				#endif
			} else if ([aActivity.target_type isEqualToString:@"Person"]) {
				#if defined(PARSER)
					NSLog(@"Enter Person");
				#endif
				TBXMLElement *project = [TBXML childElementNamed:@"project" parentElement:activity];
				TBXMLElement *person = [TBXML childElementNamed:@"person" parentElement:target];
				[self addUser:[NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"user-id" parentElement:person]] intValue]] 
				 WithUsername:[TBXML textForElement:[TBXML childElementNamed:@"username" parentElement:person]]
				   ForProject:[NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:project] intValue]] 
				  projectName:[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:project]] 
					permalink:[TBXML textForElement:[TBXML childElementNamed:@"permalink" parentElement:project]]];
				NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
				[fetchRequest setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext]];
				[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user_id = %@", [TBXML textForElement:[TBXML childElementNamed:@"user-id" parentElement:person]]]];
				UserModel *mUser = [[managedObjectContext  executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
				[fetchRequest release];
				aActivity.User = mUser;
				#if defined(PARSER)
					NSLog(@"Exit Person");
				#endif
			} else if ([aActivity.target_type isEqualToString:@"Page"]) {
				#if defined(PARSER)
					NSLog(@"Enter %@", aActivity.target_type);
				#endif
				TBXMLElement *page = [TBXML childElementNamed:@"page" parentElement:target];
				NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
				[fetchRequest setEntity:[NSEntityDescription entityForName:@"Page" inManagedObjectContext:managedObjectContext]];
				[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"page_id = %@", [TBXML valueOfAttributeNamed:@"id" forElement:page]]];
				
				PageModel *mPage;
				@try {
					mPage = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
				} @catch (NSException *e) {
					mPage = (PageModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Page" inManagedObjectContext:managedObjectContext];
					mPage.page_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:page] intValue]];
					mPage.name = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:page]]];
				} @finally {
					[fetchRequest release];
				}
				aActivity.Page = mPage;
				#if defined(PARSER)
					NSLog(@"Exit %@", aActivity.target_type);
				#endif
			} else if ([aActivity.target_type isEqualToString:@"Conversation"]) {
				#if defined(PARSER)
					NSLog(@"Enter %@", aActivity.target_type);
				#endif
				TBXMLElement *conversation = [TBXML childElementNamed:@"conversation" parentElement:target];
				NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
				[fetchRequest setEntity:[NSEntityDescription entityForName:@"Conversation" inManagedObjectContext:managedObjectContext]];
				[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"conversation_id = %@", [TBXML valueOfAttributeNamed:@"id" forElement:conversation]]];
				
				ConversationModel *mConversation;
				@try {
					mConversation = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
				} @catch (NSException *e) {
					mConversation = (ConversationModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:managedObjectContext];
					mConversation.conversation_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:conversation] intValue]];
					mConversation.name = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:conversation]]];
				} @finally {
					[fetchRequest release];
				}
				aActivity.Conversation = mConversation;
				#if defined(PARSER)
					NSLog(@"Exit %@", aActivity.target_type);
				#endif
			}
				//Delete
		} else if ([aActivity.action isEqualToString:@"delete"]) {
			if ([aActivity.target_type isEqualToString:@"Person"]) {
				/*TBXMLElement *person = [TBXML childElementNamed:@"person" parentElement:target];
				NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
				[fetchRequest setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext]];
				[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user_id = %@", [TBXML textForElement:[TBXML childElementNamed:@"user-id" parentElement:person]]]];
				UserModel *mUser = [[managedObjectContext  executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
				[fetchRequest release];*/
				aActivity.User = mUser;
			}
		}
		if (![managedObjectContext save:&error]) {
				// Handle the error.
		}
		if ([typeParse isEqualToString:@"ActivitiesAll"] || [typeParse isEqualToString:@"ActivitiesAllNew"] || 
			[typeParse isEqualToString:@"ActivitiesProjectAll"])
			activity = [TBXML previousSiblingNamed:@"activity" searchFromElement:activity];
		else
			activity = [TBXML nextSiblingNamed:@"activity" searchFromElement:activity];
	}
	#if defined(DEBUG)
		NSLog(@"------ ENDParseando actividades \n");
	#endif
}

- (void)addUser:(NSNumber *)userID WithUsername:(NSString *)username ForProject:(NSNumber *)projectID projectName:(NSString *)andProjectName permalink:(NSString *)permalink {
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext]];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"project_id == %i",[projectID intValue]]];
	
	ProjectModel *mProject;
	@try {
		mProject = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
	} @catch (NSException *e) {
		mProject = (ProjectModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
		mProject.project_id = projectID;
		mProject.name = andProjectName;
		mProject.permalink = permalink;
	} @finally {
		[fetchRequest release];
	}
	fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext]];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user_id == %i",[userID intValue]]];
	
	UserModel *mUser;
	@try {
		mUser = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
	} @catch (NSException *e) {
		Project_UserModel *mProject_User = (Project_UserModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Project_User" inManagedObjectContext:managedObjectContext];
		mUser = (UserModel *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
		mUser.user_id = userID;
		mUser.username = username;
			//add the ProjectUser to the project and to the user
		[mProject addProject_UserObject:mProject_User];
		[mUser addProject_UserObject:mProject_User];
	} @finally {
		[fetchRequest release];
	}
	
	if (![managedObjectContext save:&error]) {
			// Handle the error.
	}
}

- (void)addUser:(int)userID WithUsername:(NSString *)username AndFirstName:(NSString *)firstname AndLastName:(NSString *)lastname {
	NSError *error;
	UserModel *aUser;
	aUser = (UserModel *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
	aUser.user_id = [NSNumber numberWithInt:userID];
	aUser.username = username;
	aUser.first_name = firstname;
	aUser.last_name = lastname;
	aUser.full_name = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
		//first we search the person for update if exists
	if (![managedObjectContext save:&error]) {
			// Handle the error.
	}
}

- (void) dealloc {
	[super dealloc];
}
@end