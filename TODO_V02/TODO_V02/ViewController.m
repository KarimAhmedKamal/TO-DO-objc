//
//  ViewController.m
//  TODO_V02
//
//  Created by Mac on 05/01/2025.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.todoList = [[NSMutableArray alloc] init];
    [self loadTodoList];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"TodoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ToDoItem *item = self.todoList[indexPath.row];
    cell.textLabel.text = item.item;
//    NSLog(@"item:%@", item.item);
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todoList.count;
}

// Allow Deletion
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.todoList removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveTodoList]; // save nsuserdefault
    }
    
}

// Add item to the list
- (IBAction)addTodoItem:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Item"
        message:@"Enter Item Description"
        preferredStyle:UIAlertControllerStyleAlert];
    // add text field to the alert dialogue
    [alert addTextFieldWithConfigurationHandler:nil];
    
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
        NSString *item = alert.textFields.firstObject.text;
        if (item.length > 0) {
            ToDoItem *newItem = [[ToDoItem alloc] init];
            newItem.item = item;
            
            [self.todoList addObject:newItem];
            [self.tableView reloadData];
            [self saveTodoList]; // save nsuserdefault
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:addAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// edit Item
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoItem *item = self.todoList[indexPath.row];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Edit Task"
                                                                   message:@"Update task title"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = item.item;
    }];

    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
        NSString *updatedTitle = alert.textFields.firstObject.text;
        if (updatedTitle.length > 0) {
            item.item = updatedTitle;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self saveTodoList]; // save nsuserdefault
        }
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    [alert addAction:saveAction];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)saveTodoList {
    NSMutableArray *serializedList = [[NSMutableArray alloc] init];

    for (ToDoItem *item in self.todoList) {
        [serializedList addObject:[item toDictionary]];
    }

    [[NSUserDefaults standardUserDefaults] setObject:serializedList forKey:@"TodoList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadTodoList {
    NSArray *savedList = [[NSUserDefaults standardUserDefaults] objectForKey:@"TodoList"];

    if (savedList) {
        self.todoList = [[NSMutableArray alloc] init];

        for (NSDictionary *dict in savedList) {
            ToDoItem *item = [ToDoItem fromDictionary:dict];
            [self.todoList addObject:item];
        }
    } else {
        self.todoList = [[NSMutableArray alloc] init];
    }
}

@end
