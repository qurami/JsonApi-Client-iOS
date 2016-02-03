#import "QJAClient.h"
#import "QJADocument.h"
#import "QJAJsonEncoder.h"


NSString *const JSONAPIClientErrorDomain = @"JSONAPIClientErrorDomain";
NSString *const JSONAPIMediaType = @"application/vnd.api+json";

@interface QJAClient (){
    
    void (^_completionHandler)(NSData *retrievedData, NSInteger statusCode, NSError *error);
    
    NSString *_HTTPMethod;
    NSMutableDictionary *_additionalHTTPHeaders;
    NSString *_apiPath;
    NSURL *_requestUrl;
    NSString *_requestBody;
    NSArray *_contentExt;
    NSArray *_acceptExt;
    NSString *_contentType;
    NSString *_accept;
    NSString *_queryParameters;
    
    NSMutableData *_requestReceivedData;
    
    NSURLSession *_urlSession;

}

@end

@implementation QJAClient

#pragma mark - HTTPMethods


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupClientParameters];
    }
    return self;
}

- (void) setupClientParameters{

    _HTTPMethod = nil;
    _apiPath = nil;
    _requestUrl = nil;
    _requestBody = nil;
    _contentExt = nil;
    _acceptExt = nil;
    _contentType = JSONAPIMediaType;
    _accept = JSONAPIMediaType;
    _queryParameters = nil;
    

}

- (void) appendQueryParameters: (NSDictionary <NSString *, NSString *> *) queryParameters{

    NSMutableArray *queryItems = [NSMutableArray new];
    
    for (NSString *key in [queryParameters allKeys]){
        NSString *value = queryParameters[key];
        [queryItems addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    
    NSString *queryString = [queryItems componentsJoinedByString:@"&"];
    
    if(!_queryParameters){
        _queryParameters = [NSString stringWithFormat:@"?%@", queryString];
    }
    else{
        _queryParameters = [_queryParameters stringByAppendingString:[NSString stringWithFormat:@"&%@", queryString]];
    }
    
}

- (void) appendRequestBody: (NSString *) body{
    
    if(!_requestBody)
        _requestBody = body;
    else
        _requestBody = [_requestBody stringByAppendingString: body];

}

- (void) setContentTypeExtension: (NSArray <NSString *> *) contentTypeExtensions acceptExtensions: (NSArray <NSString *> *) acceptExtensions{
    
    if(contentTypeExtensions && [contentTypeExtensions count] > 0){
        _contentExt = contentTypeExtensions;
        _contentType = [_contentType stringByAppendingString:[NSString stringWithFormat:@"; ext=\"%@\"", [contentTypeExtensions componentsJoinedByString:@","]]];
    }
    
    if(acceptExtensions && [acceptExtensions count] > 0){
        _acceptExt = acceptExtensions;
        _accept = [_accept stringByAppendingString:[NSString stringWithFormat:@"; ext=\"%@\"", [acceptExtensions componentsJoinedByString:@","]]];
    }
    
}

- (void) genericRequestWithHTTPMethod: (NSString *) httpMethod resourcePath: (NSString *) path completionHandler: (void(^)(NSData *retrievedData, NSInteger statusCode, NSError *error)) completionHandler{
    
    _HTTPMethod = httpMethod;
    _apiPath = path;
    _completionHandler = completionHandler;
    
    [self startApiCall];
    
}

#pragma mark - JSONAPI Protocl Methods


- (void) appendIncludedResourcesToQueryParameters: (NSArray *) includedResources{

    if(includedResources && [includedResources count] > 0){
        
        NSString *resourcesString = [includedResources componentsJoinedByString:@","];
        [self appendQueryParameters:@{@"include" : resourcesString}];
    }
}

- (void) getJSONAPIDocumentWithPath: (NSString *) path completionHandler:(void (^)(QJADocument *jsonApi, NSInteger statusCode, NSError *error))completionHandler{

    [self getJSONAPIDocumentWithPath: path includedResourceTypes: nil completionHandler: completionHandler];
    
}

- (void) getJSONAPIDocumentWithPath: (NSString *) path includedResourceTypes: (NSArray *) includedResourceTypes completionHandler:(void (^)(QJADocument *jsonApi, NSInteger statusCode, NSError *error))completionHandler{

    [self appendIncludedResourcesToQueryParameters: includedResourceTypes];
    [self genericRequestWithHTTPMethod: @"GET" resourcePath: path completionHandler:^(NSData *retrievedData, NSInteger statusCode, NSError *error) {
        [self jsonApiCallCompletedWithData: retrievedData statusCode: statusCode error: error callbackHandler: completionHandler];
    }];
    
}

- (void) postJSONAPIDocument: (QJADocument *) documentToPost withPath: (NSString *) path completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler{


    [self postJSONAPIDocument: documentToPost withPath: path includedResources: nil completionHandler: completionHandler];
    
}

- (void) postJSONAPIDocument: (QJADocument *) documentToPost withPath: (NSString *) path includedResources: (NSArray *) includedResourceTypes completionHandler: (void(^)(QJADocument *jsonApiDocument, NSInteger statusCode, NSError *error)) completionHandler{
    
    [self appendIncludedResourcesToQueryParameters: includedResourceTypes];
    [self appendRequestBody:[QJAJsonEncoder jsonEncodedStringForJSONAPIDocument: documentToPost]];
    [self genericRequestWithHTTPMethod:@"POST" resourcePath:path completionHandler:^(NSData *retrievedData, NSInteger statusCode, NSError *error) {
        [self jsonApiCallCompletedWithData: retrievedData statusCode: statusCode error: error callbackHandler: completionHandler];
    }];

}


- (void) deleteJSONAPIResourceWithPath: (NSString *) path completionHandler: (void(^)(QJADocument *jsonApiDocument ,NSInteger statusCode, NSError *error)) completionHandler{
    
    [self genericRequestWithHTTPMethod:@"DELETE" resourcePath:path completionHandler:^(NSData *retrievedData, NSInteger statusCode, NSError *error) {
        [self jsonApiCallCompletedWithData: retrievedData statusCode: statusCode error: error callbackHandler: completionHandler];
    }];

}


#pragma mark - API Call

- (void) startApiCall{

    [self buildHeaders];
    [self buildURL];
    [self configureSession];
    [self startSession];

}

- (void) buildHeaders{

    NSDictionary *jsonAPIHTTPHeaders = @{
                                         @"Content-Type" : _contentType,
                                         @"Accept" : _accept
                                             };
    
    [self appendAdditionalHTTPHeaders: jsonAPIHTTPHeaders];

}

- (void) appendAdditionalHTTPHeaders: (NSDictionary *) additionalHeaders{
    
    if(!_additionalHTTPHeaders)
        _additionalHTTPHeaders = [NSMutableDictionary new];
    
    [_additionalHTTPHeaders addEntriesFromDictionary: additionalHeaders];
    
}


- (void) buildURL{
    
    NSString *urlString = [_endpoint stringByAppendingPathComponent: _apiPath];
    
    if(_queryParameters)
        urlString = [urlString stringByAppendingString: _queryParameters];
    
    _requestUrl = [NSURL URLWithString: urlString];
}

- (void) configureSession{
    
    if(!_sessionConfiguration){
        _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    [_sessionConfiguration setHTTPAdditionalHeaders: _additionalHTTPHeaders];
    
    _urlSession = [NSURLSession sessionWithConfiguration: _sessionConfiguration delegate: self delegateQueue:[NSOperationQueue mainQueue]];
}

- (void) startSession{

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: _requestUrl];
    
    //workaround to fix a bug on iOS 8.3 where content type was overridden.
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.3" options:NSNumericSearch] == NSOrderedSame){
        
        
        [req setValue:_contentType  forHTTPHeaderField:@"Content-Type"];
        
        if(_additionalHTTPHeaders){
            for (id headerKey in [_additionalHTTPHeaders allKeys]) {
                [req setValue: _additionalHTTPHeaders[headerKey] forHTTPHeaderField: headerKey];
            }
        }
    }
    
    [req setHTTPMethod: _HTTPMethod];
    [req setHTTPBody: [_requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    _requestReceivedData = nil;
    
    
    NSLog(@"%@ : session starting with http headers \n %@", NSStringFromClass([self class]), _urlSession.configuration.HTTPAdditionalHeaders);

    if(_requestBody)
        NSLog(@"%@ : body of the request: %@",  NSStringFromClass([self class]), _requestBody);
    
    NSLog(@"%@ : for apirequest with url %@", NSStringFromClass([self class]), [_requestUrl absoluteString]);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    [[_urlSession dataTaskWithRequest: req] resume];

}

#pragma mark - NSURLSessionDelegate & NSURLSessionTaskDelegate

- (void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    if(!_requestReceivedData)
        _requestReceivedData = [NSMutableData new];
    
    [_requestReceivedData appendData: data];
    
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    NSInteger receivedStatusCode = [(NSHTTPURLResponse *)task.response statusCode];


    if(_completionHandler){
        
        if(error){
            _completionHandler(nil, receivedStatusCode, error);
        }
        else{
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSDictionary *headers = [response allHeaderFields];
            NSString *mimeType = headers[@"Content-Type"];
            
            if(receivedStatusCode != 204 && ![self responseMimeTypeIsValid: mimeType]){
                _completionHandler(nil,receivedStatusCode, [self mimetypeError]);
            }
            else{
                _completionHandler(_requestReceivedData, receivedStatusCode, nil);
            }
        }
        
    
    
    }
    
    [self setupClientParameters];
    [session invalidateAndCancel];
}

- (BOOL) responseMimeTypeIsValid: (NSString *) responseMimeType{
    
    BOOL returnValue = [responseMimeType rangeOfString: JSONAPIMediaType].location != NSNotFound;
    
    if(_acceptExt && [_acceptExt count] > 0){
        
        NSString *expectedExtension = [NSString stringWithFormat:@"ext=\"%@\"", [_acceptExt componentsJoinedByString:@","]];
        
        returnValue = [responseMimeType rangeOfString: expectedExtension].location != NSNotFound;
    }
    
    return returnValue;

}

- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    
    NSInteger authChallangeCount = challenge.previousFailureCount;
    
    if(authChallangeCount == 0){
        completionHandler(NSURLSessionAuthChallengeUseCredential, _sessionCredential);
    }
    else
        completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
    
    
}

#pragma mark - Callbacks

- (void) jsonApiCallCompletedWithData: (NSData *) data statusCode: (NSInteger) statusCode error: (NSError *) error callbackHandler: (void(^)(QJADocument *document, NSInteger statusCode, NSError *error)) callbackHandler{
    
    if(callbackHandler){
        if(statusCode == 204){
            callbackHandler(nil, statusCode, nil);
        }
        else{
            NSString *jsonDataString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            QJADocument *jsonApiDocument = [QJADocument jsonAPIDocumentWithString: jsonDataString];
            
            if(!jsonApiDocument){
                callbackHandler(nil, statusCode, [self malformedDataError]);
            }
            else{
                callbackHandler(jsonApiDocument, statusCode, nil);
            }
        }
    }
}

- (NSError *) malformedDataError{
    
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: @"bad response",
                               NSLocalizedFailureReasonErrorKey: @"Unable to parse json data into JSONAPIDocument",
                               NSLocalizedRecoverySuggestionErrorKey: @"for further information: http://jsonapi.org"
                               };
    
    NSError *malformedDataError = [NSError errorWithDomain:JSONAPIClientErrorDomain code:kMalformedContentError userInfo:userInfo];

    return malformedDataError;
    
}

- (NSError *) mimetypeError{
    
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: @"bad response",
                               NSLocalizedFailureReasonErrorKey: @"MIME Type was not application/vnd.api+json",
                               NSLocalizedRecoverySuggestionErrorKey: @"for further information: http://jsonapi.org"
                               };
    
    NSError *mimeTypeError = [NSError errorWithDomain:JSONAPIClientErrorDomain code:kMimetypeError userInfo:userInfo];
    
    return mimeTypeError;

    
}


@end
