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

@implementation TeamboxActivitiesParser

- (void)parse {
		// Obtain root element
	TBXMLElement *root = parser.rootXMLElement;	
	
		// if root element is valid
	if (root) {
		TBXMLElement *activity = [TBXML childElementNamed:@"activity" parentElement:root];
			// if an author element was found
		while (activity != nil) {
			ActivityModel *aActivity;
				//first we search the project for update if exists
			aActivity = (ActivityModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
			aActivity.activity_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:activity] intValue]];
			
			TBXMLElement *desc = [TBXML childElementNamed:@"action" parentElement:activity];
			if (desc != nil)
				aActivity.action = [TBXML textForElement:desc];
			/*
			desc = [TBXML childElementNamed:@"created-at" parentElement:activity];
			if (desc != nil)
				aActivity.created_at = [TBXML textForElement:desc];
			
			desc = [TBXML childElementNamed:@"updated-at" parentElement:activity];
			if (desc != nil)
				aActivity.updated_at = [TBXML textForElement:desc];
			*/
			
				//Get the USER in the activity
			NSError *error;
				//User
			TBXMLElement *user = [TBXML childElementNamed:@"user" parentElement:activity];
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
			[fetchRequest setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext]];
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user_id=%i",[[TBXML valueOfAttributeNamed:@"id" forElement:user] intValue]]];
			NSArray *item = [managedObjectContext  executeFetchRequest:fetchRequest error:&error];
			UserModel *aUser = [item objectAtIndex:0];
			
			aUser.first_name = [TBXML textForElement:[TBXML childElementNamed:@"first-name" parentElement:user]];
			aUser.last_name = [TBXML textForElement:[TBXML childElementNamed:@"last-name" parentElement:user]];
			aUser.full_name = [NSString stringWithFormat:@"%@ %@", aUser.first_name, aUser.last_name];
			
				//Target
			TBXMLElement *target = [TBXML childElementNamed:@"target" parentElement:activity];
			aActivity.target_type = [TBXML textForElement:[TBXML childElementNamed:@"type" parentElement:target]];
			CommentModel *aComment;
			aComment = (CommentModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:managedObjectContext];
			
				//Create
			if ([aActivity.action isEqualToString:@"create"]) {
				if ([aActivity.target_type isEqualToString:@"Comment"]) {
					TBXMLElement *comment = [TBXML childElementNamed:@"comment" parentElement:target];
					aComment.body = [TBXML textForElement:[TBXML childElementNamed:@"body" parentElement:comment]];
				}
				//Delete
			} else if ([aActivity.action isEqualToString:@"delete"]) {
				
			}
			[aComment addActivityObject:aActivity];
			[aUser addActivityObject:aActivity];
				//SAVE the object
			if (![managedObjectContext save:&error]) {
					// Handle the error.
			}
			
				// find the next sibling element named "project"
			activity = [TBXML nextSiblingNamed:@"activity" searchFromElement:activity];
		}
	}
	
	[delegate parserFinishedType:typeParse];
}

- (void) dealloc {
	[super dealloc];
}
@end
