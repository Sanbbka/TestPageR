//
//  AppDelegate.h
//  PageRank
//
//  Created by Alexander Drovnyashin on 07.03.17.
//  Copyright © 2017 Alexander Drovnyashin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

