//
//  TeamboxTaskListsParser.m
//  Teambox
//
//  Created by Alejandro JL on 13/04/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxTaskListsParser.h"
#import "TaskListModel.h"
#import "TaskModel.h"

@interface  TeamboxTaskListsParser (Private)

@end

@implementation TeamboxTaskListsParser

- (void)parserAndAddCoreData {
		// Obtain root element
	TBXMLElement *root = parser.rootXMLElement;
	
	NSError *error;
	if (root) {
		TBXMLElement *taskList = [TBXML childElementNamed:@"task_list" parentElement:root];
			// if an author element was found
		while (taskList != nil) {
			TaskListModel *aTaskList;
			NSNumber *nId = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:taskList] intValue]];
				//first we search the project for update if exists
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
			[fetchRequest setEntity:[NSEntityDescription entityForName:@"TaskList" inManagedObjectContext:managedObjectContext]];
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tasklist_id=%i",[nId intValue]]];
			NSArray *items = [managedObjectContext  executeFetchRequest:fetchRequest error:&error];
			[fetchRequest release];
			if ([items count]==0) {
				aTaskList = (TaskListModel *)[NSEntityDescription insertNewObjectForEntityForName:@"TaskList" inManagedObjectContext:managedObjectContext];
				aTaskList.tasklist_id = nId;
				aTaskList.project_id = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"project-id" parentElement:taskList]] intValue]];
				aTaskList.user_id = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"user-id" parentElement:taskList]] intValue]];
				aTaskList.position = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"position" parentElement:taskList]] intValue]];
				aTaskList.name = [self stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:taskList]]];
					//aTaskList.archived = [[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:taskList]] boolValue];
			} else
				aTaskList = [items objectAtIndex:0];
				
			TBXMLElement *tasks = [TBXML childElementNamed:@"task-list" parentElement:taskList];
			if (tasks != nil) {
				TBXMLElement *task = [TBXML childElementNamed:@"task" parentElement:tasks];
				while (task != nil) {
					TaskModel *aTask;
					nId = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:task] intValue]];
					fetchRequest = [[NSFetchRequest alloc] init];
					[fetchRequest setEntity:[NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext]];
					[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"task_id=%i",[nId intValue]]];
					items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
					[fetchRequest release];
					if ([items count]==0) {
						aTask = (TaskModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:managedObjectContext];
						aTask.task_id = nId;
						aTask.task_list_id = aTaskList.tasklist_id;
						aTask.name = [self stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:task]]];
						aTask.status = [NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"status" parentElement:task]] intValue]];
						[aTaskList addTaskObject:aTask];
					}
					task = [TBXML nextSiblingNamed:@"task" searchFromElement:task];
				}				
			}
							//SAVE the object
			
			
				// find the next sibling element named "project"
			taskList = [TBXML nextSiblingNamed:@"task_list" searchFromElement:taskList];
		}
	}
	if (![managedObjectContext save:&error]) {
			// Handle the error.
	}
	[delegate parserFinishedType:typeParse];
}

@end
