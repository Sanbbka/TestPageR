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
#import "Constant.h"

@implementation NetworkManager

+ (NSArray *)executeTask:(NSString *)urlPath {
    NSArray *arr = nil;
    @autoreleasepool {
        
        NSError *error = nil;
        NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:[urlPath copy]] encoding:NSUTF8StringEncoding error:&error];
        
        NSMutableArray *arrLinks = [NSMutableArray new];
        
        if (error == nil && str) {
            {
                HTMLDocument *document = [HTMLDocument documentWithString:str];
                NSArray *arr = [document nodesMatchingSelector:@"a"];
                
                for (HTMLElement *elem in arr) {
                    NSString *href = [[elem attributes] objectForKey:@"href"];
                    if (href && [href containsString:baseURL]) {
                        [arrLinks addObject:[href copy]];
                    }
                }
            }
//            {
//                HTMLDocument *document = [HTMLDocument documentWithString:str];
//                NSArray *arr = [document nodesMatchingSelector:@"link"];
//                
//                for (HTMLElement *elem in arr) {
//                    NSString *href = [[elem attributes] objectForKey:@"href"];
//                    if (href && [href containsString:baseURL]) {
//                        [arrLinks addObject:[href copy]];
//                    }
//                }
//            }
        }
        arr = [arrLinks copy];
    }
    
    return arr;
}

@end
