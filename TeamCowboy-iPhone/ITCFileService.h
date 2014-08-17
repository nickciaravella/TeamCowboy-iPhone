//
//  ITCFileService.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@protocol ITCFileService <NSObject>

/**
 @brief Returns the cache directory.
 */
- (NSURL *)cacheDirectory;

/**
 @brief Returns the application support directory.
 */
- (NSURL *)applicationSupportDirectory;

/**
 @brief Writes a dictionary to a file. If the file or directory does not exist. It will create it.
 @param dictionary The dictionary to be written.
 @param fileURL    The file location.
 @return Any error that occurs during the write.
 */
- (NSError *)writeDictionary:(NSDictionary *)dictionary
                      toFile:(NSURL *)fileURL;

/**
 @brief Reads a dictionary from a file.
 @param fileURL The file location.
 @param error   Contains an error that may occur during the read.
 @return The dictionary contents that were read.
 */
- (NSDictionary *)dictionaryFromFile:(NSURL *)fileURL
                               error:(NSError **)error;

/**
 @brief Deletes a file from the filesystem.
 @param fileURL The file location.
 */
- (void)deleteFile:(NSURL *)fileURL;

@end
