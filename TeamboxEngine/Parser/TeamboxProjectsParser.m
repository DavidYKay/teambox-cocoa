	//
	//  TeamboxProjectsParser.m
	//  Teambox
	//
	//  Created by Alejandro Julián López on 27/02/10.
	//  Copyright 2010 Teambox. All rights reserved.
	//

#import "TeamboxProjectsParser.h"
#import "ProjectModel.h"
#import "UserModel.h"
#import "Project_UserModel.h"
#import "User_TBUSerModel.h"

@implementation TeamboxProjectsParser

- (void)parserAndAddCoreData {
		// Obtain root element
	TBXMLElement * root = parser.rootXMLElement;	
	
		// if root element is valid
	if (root) {
		TBXMLElement * project = [TBXML childElementNamed:@"project" parentElement:root];
			// if an author element was found
		while (project != nil) {
			NSNumber* nId =[NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:project]intValue]];
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
			[fetchRequest setEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext]];
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"project_id=%i",[nId intValue]]];
			
			NSError *error;

			ProjectModel *aProject;
			
			@try {
				aProject = [[managedObjectContext  executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
			} @catch (NSException *e) {
				aProject = (ProjectModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
				aProject.project_id = nId;
				TBXMLElement* desc = [TBXML childElementNamed:@"name" parentElement:project];
				aProject.name = [TBXML textForElement:desc];
				desc = [TBXML childElementNamed:@"permalink" parentElement:project];
				aProject.permalink = [TBXML textForElement:desc];
				desc = [TBXML childElementNamed:@"archived" parentElement:project];
				
				if ([[TBXML textForElement:desc] isEqualToString:@"false"])
					aProject.archived = [NSNumber numberWithInt:NO];
				else
					aProject.archived = [NSNumber numberWithInt:YES];
				
				desc = [TBXML childElementNamed:@"owner-user-id" parentElement:project];
				aProject.owner_user_id = [NSNumber numberWithInt:[[TBXML textForElement:desc] intValue]];
				save = YES;
			} @finally {
				[fetchRequest release];
				save = NO;
			}
			
				//Get the PEOPLE in the project
			
			TBXMLElement* people = [TBXML childElementNamed:@"people" parentElement:project];
			TBXMLElement* person = [TBXML childElementNamed:@"person" parentElement:people];
			while (person != nil) {
			
				//first we search the person for update if exists
				NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
				
				NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];
				[fetchRequest setEntity:entity];
				
				NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id=%@",[TBXML textForElement:[TBXML childElementNamed:@"user-id" parentElement:person]]];
				[fetchRequest setPredicate:predicate];
				
				NSError *error;
				UserModel *aUser;
				
				@try {
					aUser = [[managedObjectContext  executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
				} @catch (NSException *e) {
					Project_UserModel* aProject_User = (Project_UserModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Project_User" inManagedObjectContext:managedObjectContext];
						//then create the user
					aUser = (UserModel *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
					aUser.user_id= [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"user-id" parentElement:person]] intValue]];
					aUser.username = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"username" parentElement:person]]];
						//add the ProjectUser to the project and to the user
					[aProject addProject_UserObject:aProject_User];
					[aUser addProject_UserObject:aProject_User];
					newUsers++;
					save = YES;
				} @finally {
					[fetchRequest release];
					NSArray* projects_usersArray = [[NSArray alloc] initWithArray:[aUser.Project_User allObjects]];
					Project_UserModel* pum;
					Boolean enc=NO;
					for (int i=0;i<[projects_usersArray count];i++){
						pum = [projects_usersArray objectAtIndex:i];
						/*int pumId = [pum.project_id intValue];
						 int projId = [aProject.project_id intValue];*/
						if ([pum.Project.project_id intValue]==[aProject.project_id intValue]) {
							enc=YES;
						}
					}
						//if doen't exists the relationship with this user we have to create it CAMBIO
					if (!enc) {
						Project_UserModel* aProject_User = (Project_UserModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Project_User" inManagedObjectContext:managedObjectContext];
						aProject_User.role = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"role" parentElement:person]] intValue]];
						[aProject addProject_UserObject:aProject_User];
						[aUser addProject_UserObject:aProject_User];
						save = YES;
					}
				}
				fetchRequest = [[NSFetchRequest alloc] init];
				[fetchRequest setEntity:[NSEntityDescription entityForName:@"User_TBUSer" inManagedObjectContext:managedObjectContext]];
				[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tb_id= %i", [[TBXML valueOfAttributeNamed:@"id" forElement:person]intValue]]];
				
				User_TBUSerModel *mUserTB;
				@try {
					mUserTB = [[managedObjectContext  executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
				} @catch (NSException *e) {
					mUserTB = (User_TBUSerModel *)[NSEntityDescription insertNewObjectForEntityForName:@"User_TBUSer" inManagedObjectContext:managedObjectContext];
					mUserTB.user_id = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"user-id" parentElement:person]] intValue]];
					mUserTB.tb_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:person]intValue]];
				} @finally {
					[fetchRequest release];
				}
				person = [TBXML nextSiblingNamed:@"person" searchFromElement:person];
			}
			
			
				//SAVE the object
			if (save) {
				if (![managedObjectContext save:&error]) {
						// Handle the error.
				}
			}
			
			
				// find the next sibling element named "project"
			project = [TBXML nextSiblingNamed:@"project" searchFromElement:project];
		}
		
		
	}
	if (newUsers)
		[delegate getUsers];
	else
		[delegate parserFinishedType:typeParse];
}

@end