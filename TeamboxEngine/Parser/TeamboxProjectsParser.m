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

@implementation TeamboxProjectsParser

- (void)parse {
		// Obtain root element
	TBXMLElement * root = parser.rootXMLElement;	
	
		// if root element is valid
	if (root) {
		
		TBXMLElement * project = [TBXML childElementNamed:@"project" parentElement:root];
			// if an author element was found
		while (project != nil) {
			NSNumber* nId =[NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:project]intValue]];
			
				//first we search the project for update if exists
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
			
			NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext];
			[fetchRequest setEntity:entity];
			
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project_id=%i",[nId intValue]];
			[fetchRequest setPredicate:predicate];
			
			NSError *error;
			NSArray *items = [managedObjectContext  executeFetchRequest:fetchRequest error:&error];
			[fetchRequest release];
			
			ProjectModel *aProject;
			if ([items count]==0) {
				aProject = (ProjectModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
				aProject.project_id = nId;
				
			}else{
				
				aProject =[items objectAtIndex:0];
			}
			
			TBXMLElement* desc = [TBXML childElementNamed:@"name" parentElement:project];
			if (desc != nil) {
					// obtain the text from the description element
				aProject.name = [TBXML textForElement:desc];
			}
			
			desc = [TBXML childElementNamed:@"permalink" parentElement:project];
			if (desc != nil) {
					// obtain the text from the description element
				aProject.permalink = [TBXML textForElement:desc];
			}
			
			desc = [TBXML childElementNamed:@"archived" parentElement:project];
			if (desc != nil) {
					// obtain the text from the description element
				NSString* sArchived = [TBXML textForElement:desc];
				if ([sArchived isEqualToString:@"false"]) {
					aProject.archived = [NSNumber numberWithInt:NO];
				}else {
					aProject.archived = [NSNumber numberWithInt:YES];
				}
				
			}
			desc = [TBXML childElementNamed:@"owner-user-id" parentElement:project];
			if (desc != nil) {
					// obtain the text from the description element
				NSNumber* nOwner =[NSNumber numberWithInt:[[TBXML textForElement:desc] intValue]];
				aProject.owner_user_id = nOwner;
			}
			
			//Get the PEOPLE in the project
			
			TBXMLElement* people = [TBXML childElementNamed:@"people" parentElement:project];
			TBXMLElement* person = [TBXML childElementNamed:@"person" parentElement:people];
			while (person != nil) {
				
				NSNumber* nId =[NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:person]intValue]];
				
				//first we search the person for update if exists
				NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
				
				NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];
				[fetchRequest setEntity:entity];
				
				NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id=%i",[nId intValue]];
				[fetchRequest setPredicate:predicate];
				
				NSError *error;
				NSArray *items = [managedObjectContext  executeFetchRequest:fetchRequest error:&error];
				[fetchRequest release];
				
				UserModel *aUser;
				
				//Verify relationship with Projet
				if ([items count]==0) {
					//The user don't's exists 
					
					//first create de object Project_user
					Project_UserModel* aProject_User = (Project_UserModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Project_User" inManagedObjectContext:managedObjectContext];
					//then create the user
					aUser = (UserModel *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
					aUser.user_id=[NSNumber numberWithInt:[nId intValue]];
					//add the ProjectUser to the project and to the user
					[aProject addProject_UserObject:aProject_User];
					[aUser addProject_UserObject:aProject_User];
				} else {
					aUser =[items objectAtIndex:0];
					//if the user exists, we have to check if the project_user for that project and that user exists.

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
						[aProject addProject_UserObject:aProject_User];
						[aUser addProject_UserObject:aProject_User];
					}
	
				}
				
				TBXMLElement * desc = [TBXML childElementNamed:@"username" parentElement:person];
				// if we found a description
				if (desc != nil) {
					// obtain the text from the description element
					aUser.username =[TBXML stringByDecodingXMLEntities:[TBXML textForElement:desc]];
				}
				person = [TBXML nextSiblingNamed:@"person" searchFromElement:person];
				
			}
			
			
				//SAVE the object
			if (![managedObjectContext save:&error]) {
					// Handle the error.
			}
			
				// find the next sibling element named "project"
			project = [TBXML nextSiblingNamed:@"project" searchFromElement:project];
		}
		
		
	}
	
	[delegate parserFinishedType:typeParse];
	
}

@end
