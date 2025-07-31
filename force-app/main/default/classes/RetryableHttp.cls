public with sharing class RetryableHttp {

    private Integer retryCount;
    private List<RetryStatusRange> retryStatusRange;
    private List<Integer> ignoreRetryStatusCode;
    private HttpRequest httpRequestObj;
    private Http httpObj;
    private Integer sendCounter;

    public RetryableHttp() {
        this.retryCount = 0;
        this.sendCounter = 0;
        this.retryStatusRange = new List<RetryStatusRange>();
    }

    public class RetryStatusRange {
        public Integer fromStatus { get; set; }
        public Integer toStatus { get; set; }

        public RetryStatusRange(Integer fromStatus, Integer toStatus) {
            this.fromStatus = fromStatus;
            this.toStatus = toStatus;
        }
    }

    public Integer getSendCounter() {
        return this.sendCounter;
    }

    public RetryableHttp setRetryCount(Integer retryCount) {
        this.retryCount = retryCount;
        return this;
    }

    public RetryableHttp setRequest(HttpRequest httpRequest) {
        this.httpRequestObj = httpRequest;
        return this;
    }

    public RetryableHttp setSender(Http httpObj) {
        this.httpObj = httpObj;
        return this;
    }

    public RetryableHttp setRetryStatusRange(List<RetryStatusRange> listOfRetryStatusRange) {
        this.retryStatusRange.addAll(listOfRetryStatusRange);
        return this;
    }

    public void resetSendCounter() {
        this.sendCounter = 0;
    }

    public HttpResponse send() {

        HttpResponse response = null;

        this.resetSendCounter();

        if (this.httpObj == null)
            return null;

        if (this.httpRequestObj == null)
            return null;

        for (Integer retry = 0; retry < this.retryCount; retry++) {
        
            this.sendCounter++;

            response = this.httpObj.send(this.httpRequestObj);

            if (!shouldRetry(response.getStatusCode()))
                break;
        }

        return response;
    }

    private Boolean shouldRetry(Integer statusCode) {

        for (RetryStatusRange range : this.retryStatusRange)
            if (statusCode >= range.fromStatus && statusCode <= range.toStatus)
                return true;
        
        return false;
    }
}