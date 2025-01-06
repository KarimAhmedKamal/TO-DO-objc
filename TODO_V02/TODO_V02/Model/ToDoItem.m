//
//  ToDoItem.m
//  TODO_V02
//
//  Created by Mac on 05/01/2025.
//

#import "ToDoItem.h"

@implementation ToDoItem

- (NSDictionary *)toDictionary {
    return @{@"title": self.item};
}

+ (ToDoItem *)fromDictionary:(NSDictionary *)dict {
    ToDoItem *item = [[ToDoItem alloc] init];
    item.item = dict[@"title"];
    return item;
}

@end
