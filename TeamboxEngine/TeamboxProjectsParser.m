//
//  TeamboxProjectsParser.m
//  Teambox
//
//  Created by Alejandro Julián López on 27/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxProjectsParser.h"
#import "Project.h"

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
			
			NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project"	  inManagedObjectContext:managedObjectContext];
			[fetchRequest setEntity:entity];
			
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project_id=%i",[nId intValue]];
			[fetchRequest setPredicate:predicate];
			
			NSError *error;
			NSArray *items = [managedObjectContext  executeFetchRequest:fetchRequest error:&error];
			[fetchRequest release];
			
			Project *aProject;
			if ([items count]==0) {
				aProject = (Project *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
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
			
			
			
			
				//SAVE the object
			if (![managedObjectContext save:&error]) {
					// Handle the error.
			}
			
			[parsedElements	insertObject:aProject atIndex:0];
			
				// find the next sibling element named "project"
			project = [TBXML nextSiblingNamed:@"project" searchFromElement:project];
		}
		
		
	}
	
	[delegate parserFinished:parsedElements typeParse:typeParse];
	
}

@end
