//
//  ITCDiagnosticsMacros.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#define ITCLog( message, ... ) NSLog(message, ##__VA_ARGS__);

#define ITCLogError( error, message, ... )   \
    ITCLog( @"******* ERROR *******" );      \
    ITCLog( message, ##__VA_ARGS__ );        \
    ITCLog( @"Error details: %@", error );    \
    ITCLog( @"*********************" )

#define ITCLogAndReturnOnError( error, message, ... ) \
    if ( error )                                      \
    {                                                 \
        ITCLogError( error, message, ##__VA_ARGS__ ); \
        return;                                       \
    }

#define ITCLogAndReturnValueOnError( error, value, message, ... ) \
    if ( error )                                      \
    {                                                 \
        ITCLogError( error, message, ##__VA_ARGS__ ); \
        return (value);                               \
    }

#define ITCAssert( condition, message, ... ) NSAssert( condition, message, ##__VA_ARGS__ )