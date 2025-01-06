//
//  ToDoItem.h
//  TODO_V02
//
//  Created by Mac on 05/01/2025.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property (nonatomic, copy) NSString *item;

- (NSDictionary *)toDictionary;
+ (ToDoItem *)fromDictionary:(NSDictionary *)dict;

@end

