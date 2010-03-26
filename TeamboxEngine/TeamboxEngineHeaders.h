//
//  TeamboxEngineHeaders.h
//  Teambox
//
//  Created by Alejandro Julián López on 26/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#if TARGET_OS_IPHONE
	#import <Foundation/Foundation.h>
	#import <UIKit/UIKit.h>
#else
	#import <Cocoa/Cocoa.h>
#endif

#pragma mark -
#pragma mark Settings
#pragma mark -

#define kLaunchDateSettingsKey @"lastLaunch"
#define kUserNameSettingsKey @"username"
#define kPaswordSettingsKey @"password"

#pragma mark -
#pragma mark URLs
#pragma mark -
#pragma mark # Activity

#if defined(LOCAL)
#define KActivitiesAllXML @"http://%@:%@@0.0.0.0:3000/activities.xml"
#define KActivitiesAllNewXML @"http://%@:%@@0.0.0.0:3000/activities/%@/show_new.xml"
#define KActivitiesAllMoreXML @"http://%@:%@@0.0.0.0:3000/activities/%@/show_more.xml"
#define KActivitiesProjectAllXML @"http://%@:%@@0.0.0.0:3000/projects/%@/activities.xml"
#define KActivitiesProjectNewXML @"http://%@:%@@0.0.0.0:3000/projects/%@/activities/%@/show_new.xml"
#define KActivitiesProjectMoreXML @"http://%@:%@@0.0.0.0:3000/projects/%@/activities/%@/show_more.xml"
#define KProjectsXML @"http://%@:%@@0.0.0.0:3000/projects.xml"
#define KTeamboxURL @"http://0.0.0.0:3000/"
#define kUserXML @"http://0.0.0.0:3000/users/%@.xml"
#define KPostComment @"http://%@:%@@0.0.0.0:3000/projects/%@/comments"
#else
#define KActivitiesAllXML @"http://%@:%@@app.teambox.com/activities.xml"
#define KActivitiesAllNewXML @"http://%@:%@@app.teambox.com/activities/%@/show_new.xml"
#define KActivitiesAllMoreXML @"http://%@:%@@app.teambox.com/activities/%@/show_more.xml"
#define KActivitiesProjectAllXML @"http://%@:%@@app.teambox.com/projects/%@/activities.xml"
#define KActivitiesProjectNewXML @"http://%@:%@@app.teambox.com/projects/%@/activities/%@/show_new.xml"
#define KActivitiesProjectMoreXML @"http://%@:%@@app.teambox.com/projects/%@/activities/%@/show_more.xml"
#define KProjectsXML @"http://%@:%@@app.teambox.com/projects.xml"
#define KTeamboxURL @"http://app.teambox.com/"
#define kUserXML @"http://app.teambox.com/users/%@.xml"
#define KPostComment @"http://%@:%@@app.teambox.com/projects/%@/comments"
#endif


#define kVIEW_SCROLL 50.0

#define kResourceLoadingStatusKeyPath @"loadingStatus"
#define kResourceSavingStatusKeyPath @"savingStatus"
#define kUserLoginKeyPath @"login"
#define kUserGravatarKeyPath @"gravatar"

	//Views
	//Table Views
#define kCellCharacterLine 33
#define kCellHigth 55
	//Activitie
#define kActivitieTOPY 1
#define kActivitieTOPH 21
#define kUserNameX 46
#define kUserNameW 100
#define kArrowRightX 153
#define kArrowRightW 14
#define kProjectNameX 167
#define kProjectNameW 89
#define kDateX 268
#define kDateW 51
#define kCommentPositionX 46
#define kCommentPositionY 22
#define kCommentPositionW 273


#define ACTTYPE_PERSON @"Person"
#define ACTTYPE_TASK @"Task"
#define ACTTYPE_TASKLIST @"TaskList"
#define ACTTYPE_COMMENT @"Comment"
#define ACTTYPE_CONVERSATION @"Conversation"
#define ACTTYPE_PROJECT @"Project"
#define ACTTYPE_PAGE @"Page"

#define TASKSTATE_NEW @"New"
#define TASKSTATE_HOLD @"Hold"
#define TASKSTATE_ASIGNED @"Asigned"
#define TASKSTATE_RESOLVED @"Resolved"
#define TASKSTATE_REJECTED @"Rejected"

	//Fonts and Text Sizes
#define CELL_BM_LEFT 32  //body left margin
#define CELL_BM_RIGHT 10 //body margin right
#define USERTEXT_SIZE 14
#define TARGETTEXT_SIZE 12
#define ACTIONTEXT_SIZE 12
#define NAMETEXT_SIZE 14
#define BODYTEXT_SIZE 12
#define DATETEXT_SIZE 12