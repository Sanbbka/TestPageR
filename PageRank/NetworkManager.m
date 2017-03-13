//
//  NetworkManager.m
//  PageRank
//
//  Created by Alexander Drovnyashin on 07.03.17.
//  Copyright © 2017 Alexander Drovnyashin. All rights reserved.
//

#import "NetworkManager.h"
#import <HTMLReader.h>
#import "Graph.h"

@implementation NetworkManager

+ (NSArray *)executeTask:(NSString *)urlPath {
    
    NSError *error = nil;
    NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlPath] encoding:NSUTF8StringEncoding error:&error];
    
    NSMutableArray *arrLinks = [NSMutableArray new];
    
    if (error == nil && str) {
        HTMLDocument *document = [HTMLDocument documentWithString:str];
        NSArray *arr = [document nodesMatchingSelector:@"a"];
        
        for (HTMLElement *elem in arr) {
            NSString *href = [[elem attributes] objectForKey:@"href"];
            if (href) {
                [arrLinks addObject:href];
            }
        }
    }
        
    return arrLinks;
}

@end
