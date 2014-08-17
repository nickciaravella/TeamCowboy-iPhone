//
//  ITCFileServiceImp.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCFileServiceImp.h"

@implementation ITCFileServiceImp

#pragma mark - ITCFileService

//
//
- (NSError *)writeDictionary:(NSDictionary *)dictionary
                      toFile:(NSURL *)fileURL
{
    NSString *directory = [[fileURL URLByDeletingLastPathComponent] path];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:directory] )
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:directory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if ( error )
        {
            return error;
        }
    }
    
    BOOL isSuccessful = [dictionary writeToURL:fileURL atomically:YES];
    NSString *message = [NSString stringWithFormat:@"Failed to write dictionary to file. File: %@, Dictionary: %@", [fileURL absoluteString], dictionary];;
    return ( isSuccessful ) ? nil : [NSError errorWithCode:ITCErrorWritingToFile message:message];
}

//
//
- (NSDictionary *)dictionaryFromFile:(NSURL *)fileURL
                               error:(NSError **)error
{
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]] )
    {
        if ( error)
        {
            *error = [NSError errorWithCode:ITCErrorFileDoesNotExist message:[NSString stringWithFormat:@"File does not exist at path: %@", [fileURL absoluteString]]];
            return nil;
        }
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:fileURL];
    if ( !dictionary && error )
    {
        *error = [NSError errorWithCode:ITCErrorReadingFromFile message:[NSString stringWithFormat:@"Failed to read dictionary at path: %@", [fileURL absoluteString]]];
    }
    
    return dictionary;
}

//
//
- (void)deleteFile:(NSURL *)fileURL
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    if ( error )
    {
        ITCLogError(error, @"Failed to delete file at path: %@", fileURL);
    }
}

//
//
- (NSURL *)applicationSupportDirectory
{
    NSArray *appSupportPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    return [NSURL fileURLWithPath:[appSupportPaths firstObject]];
}

//
//
- (NSURL *)cacheDirectory
{
    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [NSURL fileURLWithPath:[cachesPaths firstObject]];
}

@end
