public abstract with sharing class AbstractFacadeService {
    public class HttpRequestDef {
        public HttpRequestDef() {
            this.headers = new Map<String, String>();
            this.encodedParams = new Map<String, String>();
            this.timeOut = 60000;
            this.baseEndpointIncluded = false;
            this.suppressApexObjectNulls = false;
        }

        public String httpMethod { get; private set; }
        public String relativeEndpoint { get; private set; }
        public Boolean baseEndpointIncluded { get; private set; }
        public Object body { get; private set; }
        public Type returnType { get; private set; }
        public Map<String, String> headers { get; private set; }
        public Map<String, String> encodedParams { get; private set; }
        public Integer timeOut { get; private set; }
        public Boolean suppressApexObjectNulls { get; private set; }

        public HttpRequestDef setHttpMethod(String httpMethod) {
            this.httpMethod = httpMethod;
            return this;
        }

        public HttpRequestDef setRelativeEndpoint(String relativeEndpoint) {
            this.relativeEndpoint = relativeEndpoint;
            return this;
        }

        public HttpRequestDef setBaseEndpointIncluded(Boolean baseEndpointIncluded) {
            this.baseEndpointIncluded = baseEndpointIncluded;
            return this;
        }

        public HttpRequestDef setBody(Object body) {
            this.body = body;
            return this;
        }

        public HttpRequestDef setsuppressApexObjectNulls(Boolean suppressApexObjectNulls) {
            this.suppressApexObjectNulls = suppressApexObjectNulls;
            return this;
        }

        public Boolean hasBody() {
            return this.body != null;
        }

        public String getBodyAsJsonString() {
            return 
                JsonUtils.getJsonWithNonReservedWordsReplaced(
                    JSON.serialize(this.body, this.suppressApexObjectNulls)
                );
        }

        public HttpRequestDef setReturnType(Type returnType) {
            this.returnType = returnType;
            return this;
        }

        public Boolean hasReturnType() {
            return this.returnType != null;
        }

        public HttpRequestDef setHeader(String key, String value) {
            this.headers.put(key, value);
            return this;
        }
        public HttpRequestDef setEncodedParams(String key, String value) {
            this.encodedParams.put(key, value);
            return this;
        }

        public HttpRequestDef setTimeOut(Integer timeout){
            this.timeOut = timeout;
            return this;
        }

    }

    public Boolean inAuthContext = false;

    protected Object makeHttpRequest(HttpRequestDef requestDef) {
        HttpRequest httpRequest = this.createHttpRequest(requestDef);
        HttpResponse httpResponse = this.makeHttpRequest(httpRequest);


        if (requestDef.hasReturnType()) 
            return this.deserializeHttpResponse(httpResponse, requestDef.returnType);

        return null;
    }

    protected HttpResponse makeHttpRequest(HttpRequest httpRequest) {
        Http http = new Http();
        HttpResponse httpResponse;

        try {

            RetryableHttp retryableHttp = new RetryableHttp();

            httpResponse = retryableHttp                
                .setRetryCount(3)
                .setRetryStatusRange(
                    new List<RetryableHttp.RetryStatusRange> {
                        new RetryableHttp.RetryStatusRange(400, 499),
                        new RetryableHttp.RetryStatusRange(500, 599)
                    }
                )
                .setRequest(httpRequest)
                .setSender(http)
                .send();
            
        } catch (Exception ex) {
            throw new FacadeServiceException(
                String.format('Unexpected error on call service "{0}".', new List<String>{ this.getServiceName() }),
                ex
            );
        }

        if (this.isSuccessStatusCode(httpResponse.getStatusCode())) {
            return httpResponse;
        }

        throw new FacadeServiceException(
            String.format(
                'Error "{0} - {1}" on call service "{2}": {3}',
                new List<String>{
                    String.valueOf(httpResponse.getStatusCode()),
                    httpResponse.getStatus(),
                    this.getServiceName(),
                    httpResponse.getBody() //<---
                }
            ),
            httpResponse.getBody()
        );
    }

    protected HttpRequest createHttpRequest(HttpRequestDef requestDef) {
        HttpRequest httpRequest = new HttpRequest();

        httpRequest.setMethod(requestDef.httpMethod);
        httpRequest.setEndpoint(this.getAbsoluteEndpoint(requestDef.relativeEndpoint, requestDef.baseEndpointIncluded));

        if (requestDef.hasBody()) {
            httpRequest.setBody(requestDef.getBodyAsJsonString());
        }

        Map<String, String> headers = new Map<String, String>(requestDef.headers);

        if(!requestDef.hasBody() && requestDef.headers?.get('Content-Type') == 'application/x-www-form-urlencoded'){
            httpRequest.setBody(getEncodedParams(requestDef.encodedParams));
        }

        this.setDefaultHeaders(headers, httpRequest);

        if (!this.inAuthContext) {
            try {
                this.inAuthContext = true;

                this.setAuthHeaders(headers);
            } finally {
                this.inAuthContext = false;
            }
        }

        for (String key : headers.keySet()) {
            httpRequest.setHeader(key, headers.get(key));
        }

        if(requestDef.timeOut != null)
            httpRequest.setTimeOut(requestDef.timeOut);

        return httpRequest;
    }

    protected Object deserializeHttpResponse(HttpResponse httpResponse, Type returnType) {
        String body = httpResponse.getBody();

        if(String.isBlank(body) && httpResponse.getStatusCode() == 202){
            return String.valueOf(httpResponse.getStatusCode());
        }

        if (String.isBlank(body)) {
            throw new FacadeServiceException(
                String.format(
                    'The service "{0}" returned with an empty body.',
                    new List<String>{ this.getServiceName() }
                )
            );
        }

        if(httpResponse.getHeader('content-type') == 'text/xml')	
            return(body);	
            
        return Json.deserialize(body, returnType);
    }

    protected abstract String getBaseEndpoint();

    protected abstract String getServiceName();

    protected virtual void setDefaultHeaders(Map<String, String> headers, HttpRequest httpRequest) {
        if (!headers.containsKey('Accept')) {
            headers.put('Accept', 'application/json');
        }

        if (!headers.containsKey('Content-Type')) {
            headers.put('Content-Type', 'application/json');
        }

        headers.put('Content-Length', String.valueOf(httpRequest.getBody().length()));
    }

    protected virtual void setAuthHeaders(Map<String, String> headers) {
    }

    protected virtual Boolean isSuccessStatusCode(Integer statusCode) {
        return statusCode >= 200 && statusCode <= 299;
    }

    protected virtual Boolean isUnauthorizedStatusCode(Integer statusCode) {
        return statusCode == 401 || statusCode == 403;
    }

    private String getAbsoluteEndpoint(String relativeEndpoint, Boolean baseIncluded) {

        String base = this.getBaseEndpoint();

        if (base == null) {
            base = '';
        }

        if (base.endsWith('/')) {
            base = base.removeEnd('/');
        }

        String relative = relativeEndpoint;

        if (relative.startsWith('/')) {
            relative = relative.removeStart('/');
        }

        String absolute = !baseIncluded ? String.format('{0}/{1}', new List<String>{ base, relative }) : relative;

        if(!Test.isRunningTest() && absolute.startsWith('/')) absolute = absolute.removeStart('/');

        return absolute;
    }

    public class FacadeServiceException extends Exception {
        private string responseBody = null;

        public FacadeServiceException(String message, String responseBody) {
            this(message);

            this.responseBody = responseBody;
        }

        public FacadeServiceException(String message, String responseBody, Exception ex) {
            this(message, ex);

            this.responseBody = responseBody;
        }

        public String getResponseBody() {
            return this.responseBody;
        }
    }

    public static String getEncodedParams(Map<String, String> vals) {
        String result = '';
        for(String thisKey : vals.keySet()) {
            if(String.isBlank(vals.get(thisKey))) continue;

            result += EncodingUtil.urlEncode(thisKey, 'UTF-8') + '=' + EncodingUtil.urlEncode(vals.get(thisKey), 'UTF-8') + '&';
        }
        return result.removeEnd('&');    
    }
}