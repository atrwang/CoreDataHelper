//
//  PAppDelegate.m
//  CoreDataModeToCodeFile
//
//  Created by Kevin.Wang on 6/24/14.
//  Copyright (c) 2014 plaso. All rights reserved.
//

#import "PAppDelegate.h"

#define kDestinationDir @"/Users/kevin/Desktop/GenModelFiles"

@implementation PAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    //Fix Path .You can copy your Entities to this model to generate ModelObjectClass
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"];
    NSManagedObjectModel* mode = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL URLWithString:modelPath]];

    //搜索每个Entity
    for (NSEntityDescription* entityDesc in [mode entities]) {

        //获取每个Entity的所有属性
        NSMutableDictionary *propertiesNameAndTypeDic = [[NSMutableDictionary alloc] init];
        for (id property in [entityDesc properties]) {
            
            if ([property isKindOfClass:[NSAttributeDescription class]]) {
                NSAttributeDescription* attribute = (NSAttributeDescription*)property;
                [propertiesNameAndTypeDic setValue:[NSNumber numberWithUnsignedInteger:[property attributeType]] forKey:[attribute name]];
            }
        }
        
        
        [self generateModelFileClassWithEntityDic:propertiesNameAndTypeDic forModel:[entityDesc name]];
    }
    
}


- (void)generateModelFileClassWithEntityDic:(NSDictionary*)propertiesNameAndTypeDic forModel:(NSString*)modelName{

    NSLog(@"model: %@ info: %@",modelName,propertiesNameAndTypeDic);
    
    NSString* headerFilePath = [kDestinationDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",modelName]];
    NSString* sourceCodeFilePath = [kDestinationDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",modelName]];
    
    
    NSMutableString * headerContent = [[NSMutableString alloc] init];
    NSMutableString * sourceCodeContent = [[NSMutableString alloc] init];

#pragma mark - .h Start
    //Interface start
    [headerContent appendString:@"#import <Foundation/Foundation.h>\n\n"];
    [headerContent appendFormat:@"@interface %@ : NSObject<NDPersistable>\n\n",modelName];
    
#pragma mark - ....  .h ...... 
    //Source start
    [sourceCodeContent appendFormat:@"#import \"%@.h\"\n\n",modelName];
    [sourceCodeContent appendFormat:@"NSString * const k%@_EntityName = @\"%@\";\n",modelName,modelName];
    
    //all the property finished
#pragma mark - All the property
    for (NSString* propertyName in [propertiesNameAndTypeDic allKeys]) {
        NSAttributeType attributeType = [[propertiesNameAndTypeDic valueForKey:propertyName] unsignedIntegerValue];
/*
 NSUndefinedAttributeType = 0,
 NSInteger16AttributeType = 100,
 NSInteger32AttributeType = 200,
 NSInteger64AttributeType = 300,
 NSDecimalAttributeType = 400,
 NSDoubleAttributeType = 500,
 NSFloatAttributeType = 600,
 NSStringAttributeType = 700,
 NSBooleanAttributeType = 800,
 NSDateAttributeType = 900,
 NSBinaryDataAttributeType = 1000
 #if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5
 // If your attribute is of NSTransformableAttributeType, the attributeValueClassName
 // must be set or attribute value class must implement NSCopying.
 , NSTransformableAttributeType = 1800
 #endif
 #if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6
 , NSObjectIDAttributeType = 2000

 */
        switch (attributeType) {
            case NSUndefinedAttributeType:
            {
            
            }
                break;
            case NSInteger16AttributeType:
            {
                [headerContent appendFormat:@"@property (nonatomic)         int         %@;\n",propertyName];
            }
                break;
            case NSInteger32AttributeType:
            {
                [headerContent appendFormat:@"@property (nonatomic)         int         %@;\n",propertyName];
            }
                break;
            case NSInteger64AttributeType:
            {
                [headerContent appendFormat:@"@property (nonatomic)         long long         %@;\n",propertyName];
            }
                break;
            case NSDecimalAttributeType:
            {
                
            }
                break;
            case NSDoubleAttributeType:
            {
                [headerContent appendFormat:@"@property (nonatomic)         double         %@;\n",propertyName];
            }
                break;
            case NSFloatAttributeType:
            {
                [headerContent appendFormat:@"@property (nonatomic)         float         %@;\n",propertyName];
            }
                break;
            case NSStringAttributeType:
            {
                [headerContent appendFormat:@"@property (nonatomic,copy)    NSString*   %@;\n",propertyName];
            }
                break;
            case NSBooleanAttributeType:
            {
                [headerContent appendFormat:@"@property (nonatomic)         BOOL         %@;\n",propertyName];
            }
                break;
            case NSDateAttributeType:
            {
                [headerContent appendFormat:@"@property (nonatomic,strong)  NSDate*   %@;\n",propertyName];
            }
                break;
            case NSBinaryDataAttributeType:
            {
                
            }
                break;
            case NSTransformableAttributeType:
            {
                
            }
                break;
            case NSObjectIDAttributeType:
            {
                
            }
                break;
                
            default:
                break;
        }
        
        
        //Property key
        [sourceCodeContent appendFormat:@"NSString * const k%@_%@ = @\"%@\";\n",modelName,propertyName,propertyName];
        
    }
    
#pragma mark - All the property finished -- managedObjectID
    //all the property finished
    [headerContent appendFormat:@"@property (nonatomic,strong)  NSManagedObjectID*  managedObjectID;\n"];
    
    //functions
    [headerContent appendString:@"\n\n\n //Functions \n"];

#pragma mark - Function Placeholder
    //Function Placeholder
    [headerContent appendString:@"/*\n"];
    [headerContent appendFormat:@"+ (NSArray*) filtered%@WithKeyWords:(NSString*)keywords ownerId:(int)ownerId;\n",modelName];
    [headerContent appendString:@"*/\n"];
    
#pragma mark - .h End
    //Interface End
    [headerContent appendString:@"\n\n\n@end"];
    [headerContent writeToFile:headerFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
#pragma mark - .... .M ......
#pragma mark - .m Start
    //Implementation
#pragma mark - Implementation
    [sourceCodeContent appendFormat:@"\n\n@implementation %@\n\n",modelName];
    
#pragma mark - Init
    //init
    [sourceCodeContent appendString:@"#pragma mark - Init\n"];
    [sourceCodeContent appendString:@"- (id)init\n{\n   self = [super init];\n      if (self) {\n"];
  
    for (NSString* propertyName in [propertiesNameAndTypeDic allKeys]) {
        
       [sourceCodeContent appendFormat:@"        self.%@  = NeedToSet;\n",propertyName];
    }
    
    [sourceCodeContent appendString:@"      }\n    return self;\n}\n\n"];
    
    
#pragma mark - InitWithEntity
    //- (id)initWithEntity:(NSManagedObject *)entity includeRelationships:(BOOL)includeRelationships {
    
    [sourceCodeContent appendString:@"- (id)initWithEntity:(NSManagedObject *)entity includeRelationships:(BOOL)includeRelationships {\n"];
    
    [sourceCodeContent appendString:@"    self = [super init];\n\n"];
    [sourceCodeContent appendFormat:@"    if (self != nil && [[[entity entity] name] isEqualToString:k%@_EntityName]) {\n\n",modelName];
    
    [sourceCodeContent appendString:@"        self.managedObjectID = [entity objectID];\n\n"];
    for (NSString* propertyName in [propertiesNameAndTypeDic allKeys]) {
        
        NSAttributeType attributeType = [[propertiesNameAndTypeDic valueForKey:propertyName] unsignedIntegerValue];

        switch (attributeType) {
            case NSUndefinedAttributeType:
            {
                
            }
                break;
            case NSInteger16AttributeType:
            {
                [sourceCodeContent appendFormat:@"        self.%@ = [[entity valueForKey:k%@_%@] intValue];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSInteger32AttributeType:
            {
                [sourceCodeContent appendFormat:@"        self.%@ = [[entity valueForKey:k%@_%@] intValue];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSInteger64AttributeType:
            {
                [sourceCodeContent appendFormat:@"        self.%@ = [[entity valueForKey:k%@_%@] longLongValue];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSDecimalAttributeType:
            {
                
            }
                break;
            case NSDoubleAttributeType:
            {
                [sourceCodeContent appendFormat:@"        self.%@ = [[entity valueForKey:k%@_%@] doubleValue];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSFloatAttributeType:
            {
                [sourceCodeContent appendFormat:@"        self.%@ = [[entity valueForKey:k%@_%@] floatValue];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSStringAttributeType:
            {
                [sourceCodeContent appendFormat:@"        self.%@ = [entity valueForKey:k%@_%@];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSBooleanAttributeType:
            {
                [sourceCodeContent appendFormat:@"        self.%@ = [[entity valueForKey:k%@_%@] boolValue];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSDateAttributeType:
            {
                [sourceCodeContent appendFormat:@"        self.%@ = [entity valueForKey:k%@_%@];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSBinaryDataAttributeType:
            {
                
            }
                break;
            case NSTransformableAttributeType:
            {
                
            }
                break;
            case NSObjectIDAttributeType:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
    
    
        [sourceCodeContent appendString:@"        if (includeRelationships) {\n"];
        [sourceCodeContent appendString:@"            //include relation\n"];
        [sourceCodeContent appendString:@"        }\n"];
        [sourceCodeContent appendString:@"    }else {\n"];
        [sourceCodeContent appendString:@"        return nil;   \n    }\n\n    return self;\n}\n\n\n"];


    //Persist
    
#pragma mark - Persist
    //-(void)persist{
    
    [sourceCodeContent appendString:@"-(void)persist{\n"];
    
    [sourceCodeContent appendFormat:@"    NSManagedObject * obj = [NDCoreDataHelper findEntity:k%@_EntityName\n",modelName];
    [sourceCodeContent appendFormat:@"                                                    byPK:k%@_NeedReplace\n",modelName];
    [sourceCodeContent appendString:@"                                              andPKValue:NeedReplace\n"];
    [sourceCodeContent appendString:@"                                               inContext:[NSManagedObjectContext sharedObjectContext]];\n"];
    
    [sourceCodeContent appendString:@"    if (obj == nil) {\n"];
    [sourceCodeContent appendFormat:@"        obj = [NDCoreDataHelper createEntity:k%@_EntityName inContext:[NSManagedObjectContext sharedObjectContext]];\n\n",modelName];
    
    for (NSString* propertyName in [propertiesNameAndTypeDic allKeys]) {
        
        NSAttributeType attributeType = [[propertiesNameAndTypeDic valueForKey:propertyName] unsignedIntegerValue];
        
        switch (attributeType) {
            case NSUndefinedAttributeType:
            {
                
            }
                break;
            case NSInteger16AttributeType:
            {
                [sourceCodeContent appendFormat:@"        [obj setValue:[NSNumber numberWithInt:self.%@] forKey:k%@_%@];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSInteger32AttributeType:
            {
                [sourceCodeContent appendFormat:@"        [obj setValue:[NSNumber numberWithInt:self.%@] forKey:k%@_%@];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSInteger64AttributeType:
            {
                [sourceCodeContent appendFormat:@"        [obj setValue:[NSNumber numberWithLongLong:self.%@] forKey:k%@_%@];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSDecimalAttributeType:
            {
                
            }
                break;
            case NSDoubleAttributeType:
            {
                [sourceCodeContent appendFormat:@"        [obj setValue:[NSNumber numberWithDouble:self.%@] forKey:k%@_%@];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSFloatAttributeType:
            {
                [sourceCodeContent appendFormat:@"        [obj setValue:[NSNumber numberWithFloat:self.%@] forKey:k%@_%@];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSStringAttributeType:
            {
                [sourceCodeContent appendFormat:@"        [obj setValue:self.%@ forKey:k%@_%@];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSBooleanAttributeType:
            {
                [sourceCodeContent appendFormat:@"        [obj setValue:[NSNumber numberWithBool:self.%@] forKey:k%@_%@];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSDateAttributeType:
            {
                [sourceCodeContent appendFormat:@"        [obj setValue:self.%@ forKey:k%@_%@];\n\n",propertyName,modelName,propertyName];
            }
                break;
            case NSBinaryDataAttributeType:
            {
                
            }
                break;
            case NSTransformableAttributeType:
            {
                
            }
                break;
            case NSObjectIDAttributeType:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
    
    
    [sourceCodeContent appendString:@"\n\n    }else {//update\n\n       //Do somethine\n\n      }\n\n"];
    [sourceCodeContent appendString:@"    NSError* error = nil;\n"];
    [sourceCodeContent appendString:@"    if (![[NSManagedObjectContext sharedObjectContext] save:&error]) {\n"];
    [sourceCodeContent appendString:@"        NSLog(@\"%@\",error);\n    }\n\n"];
    [sourceCodeContent appendString:@"        self.managedObjectID = [obj objectID];\n"];
    [sourceCodeContent appendString:@"\n}\n\n\n"];
    
    
#pragma mark - Remove
    //Remove
    [sourceCodeContent appendString:@"\n-(void)remove{\n\n"];
    [sourceCodeContent appendFormat:@"    NSString* format = [NSString stringWithFormat:@\"%%@=%%@\", k%@_NeedReplace, @\"%%d\"];\n",modelName];
    [sourceCodeContent appendString:@"    NSPredicate* pre = [NSPredicate predicateWithFormat:format, NeedReplace];\n\n"];
    
    [sourceCodeContent appendFormat:@"    [NDCoreDataHelper deleteEntity:k%@_EntityName predicate:pre inContext:[NSManagedObjectContext sharedObjectContext]];\n\n",modelName];
    
    [sourceCodeContent appendString:@"    NSError* error = nil;\n"];
    [sourceCodeContent appendString:@"    if (![[NSManagedObjectContext sharedObjectContext] save:&error]) {\n"];
    [sourceCodeContent appendString:@"        NSLog(@\"%@\",error);\n"];
    [sourceCodeContent appendString:@"    }\n}\n\n\n"];
    
#pragma mark - Find All
     //Find All
    [sourceCodeContent appendString:@"/*\n+ (NSArray *)findAll{\n\n"];
    [sourceCodeContent appendString:@"    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:NeedReplace ascending:YES];\n"];
    [sourceCodeContent appendString:@"    NSArray* sortDescs = [NSArray arrayWithObject:sort];\n\n"];
    
    [sourceCodeContent appendFormat:@"    NSArray* results = [NDCoreDataHelper findEntities:k%@_EntityName\n\n",modelName];
    [sourceCodeContent appendString:@"                                            predicate:nil\n"];
    [sourceCodeContent appendString:@"                                             sortDesc:sortDescs\n"];
    [sourceCodeContent appendString:@"                                            inContext:[NSManagedObjectContext sharedObjectContext]];\n\n"];
    
    [sourceCodeContent appendString:@"    NSMutableArray* gourps = nil;\n\n"];
    [sourceCodeContent appendString:@"    if ([results count] > 0) {\n\n"];
    [sourceCodeContent appendString:@"        groups = [NSMutableArray arrayWithCapacity:[results count]];\n\n"];
    [sourceCodeContent appendString:@"        @autoreleasepool {\n"];
    [sourceCodeContent appendFormat:@"            %@* item = nil;\n\n",modelName];
    [sourceCodeContent appendString:@"            for (NSManagedObject* mo in results) {\n"];
    [sourceCodeContent appendFormat:@"                group = [[%@ alloc] initWithEntity:mo includeRelationships:NO];\n",modelName];
    [sourceCodeContent appendString:@"                [gourps addObject:group];\n"];
    [sourceCodeContent appendString:@"            }\n       }\n\n"];
    [sourceCodeContent appendString:@"    }\n\n"];
    [sourceCodeContent appendString:@"    return groups;\n}\n*/\n\n"];
    
    
#pragma mark - Find With Condition
    //Find With Condition
    [sourceCodeContent appendString:@"/*\n+ (NSArray*) filteredFavoriteGroupWithKeyWords:(NSString*)keywords ownerId:(int)ownerId{\n\n"];
    [sourceCodeContent appendString:@"    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:NeedReplace ascending:YES];\n"];
    [sourceCodeContent appendString:@"    NSArray* sortDescs = [NSArray arrayWithObject:sort];\n\n"];
    
    [sourceCodeContent appendString:@"    NSString* ownerIdformat = [NSString stringWithFormat:@\"%%@=%%@\", NeedReplace, @\"%%d\"];\n"];
    [sourceCodeContent appendString:@"    NSPredicate *ownerIdPredicate = [NSPredicate predicateWithFormat:ownerIdformat,NeedReplace];\n"];
    [sourceCodeContent appendString:@"    NSPredicate *matchPredicate = nil;\n"];
    [sourceCodeContent appendString:@"    NSPredicate *finalPredicate = nil;\n"];
    
    [sourceCodeContent appendString:@"    if ([keywords length]>0) {\n"];
    [sourceCodeContent appendString:@"        NSString* nameformat = [NSString stringWithFormat:@\"%%@ contains[cd] %%@\",NeedReplace, @\"%%@\"];\n"];
    [sourceCodeContent appendString:@"         NSPredicate * namepre = [NSPredicate predicateWithFormat:nameformat,NeedReplace];\n"];
    
    [sourceCodeContent appendString:@"        NSString* keywordsFormat = [NSString stringWithFormat:@\"%%@ contains[cd] %%@\",NeedReplace, @\"%%@\"];\n"];
    [sourceCodeContent appendString:@"         NSPredicate * keywordPre = [NSPredicate predicateWithFormat:keywordsFormat,NeedReplace];\n"];
    [sourceCodeContent appendString:@"        matchPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[namepre,keywordPre]];\n"];
    [sourceCodeContent appendString:@"      }\n\n"];
    
    
    [sourceCodeContent appendString:@"    if (ownerIdPredicate != nil && matchPredicate != nil) { //两个条件都有效\n"];
    [sourceCodeContent appendString:@"        finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ownerIdPredicate,matchPredicate]];\n"];
    [sourceCodeContent appendString:@"      }\n\n"];
    
    
    [sourceCodeContent appendFormat:@"    NSArray* results = [NDCoreDataHelper findEntities:k%@_EntityName\n\n",modelName];
    [sourceCodeContent appendString:@"                                            predicate:nil\n"];
    [sourceCodeContent appendString:@"                                             sortDesc:sortDescs\n"];
    [sourceCodeContent appendString:@"                                            inContext:[NSManagedObjectContext sharedObjectContext]];\n\n"];
    
    [sourceCodeContent appendString:@"    NSMutableArray* gourps = nil;\n\n"];
    [sourceCodeContent appendString:@"    if ([results count] > 0) {\n\n"];
    [sourceCodeContent appendString:@"        groups = [NSMutableArray arrayWithCapacity:[results count]];\n\n"];
    [sourceCodeContent appendString:@"        @autoreleasepool {\n"];
    [sourceCodeContent appendFormat:@"            %@* item = nil;\n\n",modelName];
    [sourceCodeContent appendString:@"            for (NSManagedObject* mo in results) {\n"];
    [sourceCodeContent appendFormat:@"                group = [[%@ alloc] initWithEntity:mo includeRelationships:NO];\n",modelName];
    [sourceCodeContent appendString:@"                [gourps addObject:group];\n"];
    [sourceCodeContent appendString:@"            }\n       }\n\n"];
    [sourceCodeContent appendString:@"    }\n\n"];
    [sourceCodeContent appendString:@"    return groups;\n}\n*/\n\n"];
    

#pragma mark - .m End
    [sourceCodeContent appendString:@"\n@end"];

    
    [sourceCodeContent writeToFile:sourceCodeFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    /**
     *   finished
     */
    
}

@end
