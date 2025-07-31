//example to System Named System :p
public with sharing class SystemFacadeService extends AbstractSystemFacadeService{

    public override String getServiceName() {
        return 'System';
    }

    public GetUserRes getIntegrationUser() {
        GetUserRes response = (GetUserRes) this.makeHttpRequest(
            new HttpRequestDef()
                .setHttpMethod('GET')
                .setRelativeEndpoint('/oauth/userinfo')
                .setBaseEndpointIncluded(false)
                .setReturnType(GetUserRes.Class)
                .setTimeOut(120000)
        );

        return response;
    }
  
    public CreatedUserRes createUser(CreateUserReq body, String userURI, String accountId){
        CreatedUserRes response = (CreatedUserRes) this.makeHttpRequest(
            new HttpRequestDef()
                .setHttpMethod('POST')
                .setRelativeEndpoint(String.format('{0}/restapi/v2.1/accounts/{1}/users', new List<String>{userURI, accountId}))
                .setBaseEndpointIncluded(true)
                .setBody(body)
                .setReturnType(CreatedUserRes.Class)
                .setTimeOut(120000)
        );

        return response;
    }

    //__
    public class GetUserRes {
        public String sub;
        public String name;
        public String given_name;
        public String family_name;
        public String created;
        public String email;
        public List<Account> accounts;
    }

    //__
    public class CreatedUserRes {
        public List<CreatedUser> newUsers;
    }

    public class CreatedUser {
        public String userId;
        public String uri;
        public String email;
        public String userName;
        public String createdDateTime;
        public String userStatus;
        public ErrorDetails errorDetails;
    }

    public class ErrorDetails {
        public String errorCode;
        public String message;
    }

}