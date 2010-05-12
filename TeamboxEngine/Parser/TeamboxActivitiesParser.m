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

- (void)addUser:(NSNumber *)userID WithUsername:(NSString *)username ForProject:(NSNumber *)projectID projectName:(NSString *)projectName permalink:(NSString *)permalink;
- (void)addUser:(int)userID WithUsername:(NSString *)username AndFirstName:(NSString *)firstname AndLastName:(NSString *)lastname;

@end

@implementation TeamboxActivitiesParser

- (void)parse {
		// Obtain root element
	TBXMLElement *root = parser.rootXMLElement;	
		//NSString* sOlder=[[NSUserDefaults standardUserDefaults] integerForKey:@"lastActivityParsed"];
	int olderActivity =  [[NSUserDefaults standardUserDefaults] integerForKey:@"lastActivityParsed"];
	if (olderActivity==0) {
		olderActivity = INT_MAX;
	}
		//if root element is valid
	NSError *error;
	if (root) {
		int countActivities = 0;
		TBXMLElement *activitx = [TBXML childElementNamed:@"activity" parentElement:root];
		if (([typeParse isEqualToString:@"ActivitiesAllNew"] || [typeParse isEqualToString:@"ActivitiesAll"]) && activitx != nil) {
			#if defined(LOCAL)
				[[NSUserDefaults standardUserDefaults] setInteger:[[TBXML valueOfAttributeNamed:@"id" forElement:activitx] intValue] forKey:@"LOCALlastActivityParsed"];
			#else
				[[NSUserDefaults standardUserDefaults] setInteger:[[TBXML valueOfAttributeNamed:@"id" forElement:activitx] intValue] forKey:@"lastActivityParsed"];
			#endif
			
		}
		while (activitx != nil) {
			countActivities++;
			activitx = [TBXML nextSiblingNamed:@"activity" searchFromElement:activitx];
		}
		countActivities--;
		
		TBXMLElement *activity = [TBXML childElementNamed:@"activity" parentElement:root];
		int x = 1;
		while (x <= countActivities) {
			activity = [TBXML nextSiblingNamed:@"activity" searchFromElement:activity];
			x++;
		}
		
		if ([typeParse isEqualToString:@"ActivitiesAllMore"] || [typeParse isEqualToString:@"ActivitiesAll"]) {
			#if defined(LOCAL)
				[[NSUserDefaults standardUserDefaults] setInteger:[[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue] forKey:@"LOCALlastMoreActivityParsed"];
			#else
				[[NSUserDefaults standardUserDefaults] setInteger:[[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue] forKey:@"lastMoreActivityParsed"];
			#endif
		}
		[[NSUserDefaults standardUserDefaults] synchronize];
			// if an author element was found
		while (activity != nil) {
			
				//if ([items count] == 0 && ![typeParse isNotEqualTo:@"ActivitiesAllMore"]) {
			NSLog(@"Parseando actividad");
			ActivityModel *aActivity;
			aActivity = (ActivityModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
			aActivity.activity_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue]];
			/*aActivity = (ActivityModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
			 aActivity.activity_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue]];*/
			
			TBXMLElement *desc = [TBXML childElementNamed:@"action" parentElement:activity];
			if (desc != nil)
				aActivity.action = [TBXML textForElement:desc];
			
			
			[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT: 0]];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				// find the description child 
			
			desc = [TBXML childElementNamed:@"created-at" parentElement:activity];
			if (desc != nil) {
				aActivity.created_at = [dateFormatter dateFromString:[TBXML textForElement:desc]];
				aActivity.created_at_string = [TBXML textForElement:desc];
			}
				//desc = [TBXML childElementNamed:@"updated-at" parentElement:activity];
				//if (desc != nil)
				//aActivity.updated_at = [dateFormatter dateFromString:[TBXML textForElement:desc]];
			
				//Get the USER in the activity
			
				//User
			TBXMLElement *user = [TBXML childElementNamed:@"user" parentElement:activity];
			NSFetchRequest *fetchUser = [[NSFetchRequest alloc] init];
			[fetchUser setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext]];
			[fetchUser setPredicate:[NSPredicate predicateWithFormat:@"user_id=%i",[[TBXML valueOfAttributeNamed:@"id" forElement:user] intValue]]];
			NSArray *item = [managedObjectContext  executeFetchRequest:fetchUser error:&error];
			if ([item count] == 0) {
				[self addUser:[[TBXML valueOfAttributeNamed:@"id" forElement:user] intValue] 
				 WithUsername:[TBXML textForElement:[TBXML childElementNamed:@"username" parentElement:user]] 
				 AndFirstName:[TBXML textForElement:[TBXML childElementNamed:@"first-name" parentElement:user]] 
				  AndLastName:[TBXML textForElement:[TBXML childElementNamed:@"last-name" parentElement:user]]];
				item = [managedObjectContext  executeFetchRequest:fetchUser error:&error];
			}
			UserModel *aUser = [item objectAtIndex:0];
			
			aUser.first_name = [self stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"first-name" parentElement:user]]];
			aUser.last_name = [self stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"last-name" parentElement:user]]];
			aUser.full_name = [NSString stringWithFormat:@"%@ %@", aUser.first_name, aUser.last_name];
			aUser.avatar_url = [self stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"avatar-url" parentElement:user]] ];
			
				//Target
			TBXMLElement *target = [TBXML childElementNamed:@"target" parentElement:activity];
			aActivity.target_type = [TBXML textForElement:[TBXML childElementNamed:@"type" parentElement:target]];
			
				//Create
			if ([aActivity.action isEqualToString:@"create"]) {
				if ([aActivity.target_type isEqualToString:@"Comment"]) {
					CommentModel *aComment;
					TBXMLElement *comment = [TBXML childElementNamed:@"comment" parentElement:target];
					aActivity.comment_type = [TBXML textForElement:[TBXML childElementNamed:@"target-type" parentElement:comment]];
					aComment = (CommentModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:managedObjectContext];
					aComment.body = [self stringByDecodingXMLEntities:[[[TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"body" parentElement:comment]]] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@" "] ];
					
					aComment.body_html = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"body-html" parentElement:comment]]];
					aComment.target_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"target-id" forElement:comment] intValue]];
					aComment.target_type = [TBXML textForElement:[TBXML childElementNamed:@"target-type" parentElement:comment]];
						//aComment.created_at 
					aActivity.user_id = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"user-id" parentElement:comment]] intValue]];
					aActivity.project_id = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"project-id" parentElement:comment]] intValue]];
					if ([aComment.target_type isEqualToString:@"Project"]) {
						
					} else if ([aComment.target_type isEqualToString:@"Task"]) {
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
					}
					
					aActivity.Comment = aComment;
				} else if ([aActivity.target_type isEqualToString:@"Task"]) {
					TBXMLElement *task = [TBXML childElementNamed:@"task" parentElement:target];
					
				} else if ([aActivity.target_type isEqualToString:@"TaskList"]) {
					
				} else if ([aActivity.target_type isEqualToString:@"Person"]) {
					TBXMLElement *project = [TBXML childElementNamed:@"project" parentElement:activity];
					TBXMLElement *person = [TBXML childElementNamed:@"person" parentElement:target];
					[self addUser:[NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:person] intValue]] 
					 WithUsername:[TBXML textForElement:[TBXML childElementNamed:@"username" parentElement:person]]
					   ForProject:[NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:project] intValue]] 
					  projectName:[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:project]] 
						permalink:[TBXML textForElement:[TBXML childElementNamed:@"permalink" parentElement:project]]];
				} else if ([aActivity.target_type isEqualToString:@"Page"]) {
					
				} else if ([aActivity.target_type isEqualToString:@"Conversation"]) {
					
				}
					//Delete
			} else if ([aActivity.action isEqualToString:@"delete"]) {
				
			}
			TBXMLElement *project = [TBXML childElementNamed:@"project" parentElement:activity];
			
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
			[fetchRequest setEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext]];
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"project_id=%i",[[TBXML valueOfAttributeNamed:@"id" forElement:project] intValue]]];
			ProjectModel *aProject = [[managedObjectContext  executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
			[fetchRequest release];
			aActivity.Project = aProject;
			[aUser addActivityObject:aActivity];
				//SAVE the object
			if (![managedObjectContext save:&error]) {
					// Handle the error.
			}
			
				// find the next sibling element named "project"
			activity = [TBXML previousSiblingNamed:@"activity" searchFromElement:activity];
		}
	}
		//guardamos la últimaactividad parseada
		//NSString* sO=[NSString stringWithFormat:@"%d", olderActivity];
	[delegate parserFinishedType:typeParse];
}

- (void)addUser:(NSNumber *)userID WithUsername:(NSString *)username ForProject:(NSNumber *)projectID projectName:(NSString *)projectName permalink:(NSString *)permalink {
		//Check project
	
		//first we search the project for update if exists
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project_id=%i",[projectID intValue]];
	[fetchRequest setPredicate:predicate];
	
	NSError *error;
	NSArray *items = [managedObjectContext  executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	
	ProjectModel *aProject;
	if ([items count]==0) {
		aProject = (ProjectModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
		aProject.project_id = projectID;
		aProject.name = projectName;
		aProject.permalink = permalink;
			//first we search the person for update if exists
	} else 
		aProject =[items objectAtIndex:0];
	
	fetchRequest = [[NSFetchRequest alloc] init];
	
	entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	predicate = [NSPredicate predicateWithFormat:@"user_id=%i",[userID intValue]];
	[fetchRequest setPredicate:predicate];
	[items release];
	items = [managedObjectContext  executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	if ([items count]==0) {
		UserModel *aUser;
		Project_UserModel* aProject_User = (Project_UserModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Project_User" inManagedObjectContext:managedObjectContext];
			//then create the user
		aUser = (UserModel *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
		aUser.user_id = userID;
		aUser.username = username;
			//add the ProjectUser to the project and to the user
		[aProject addProject_UserObject:aProject_User];
		[aUser addProject_UserObject:aProject_User];
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