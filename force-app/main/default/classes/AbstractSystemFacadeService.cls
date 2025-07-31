public abstract with sharing class AbstractSystemFacadeService extends AbstractFacadeService {

    private final Callout_Config__c baseEndpointConfig = CalloutConfigSelector.getByLabel(
        'SystemXBaseEndpoint'
    );

    protected virtual String getClientId() {
        return baseEndpointConfig.Client_ID__c;
    }

    protected virtual String getClientSecret() {
        return baseEndpointConfig.Client_Secret__c;
    }

    protected override String getBaseEndpoint() {
        return baseEndpointConfig.Endpoint__c;
    }

    protected override void setAuthHeaders(Map<String, String> headers) {

        AccessTokenResponse accessToken = getTokenCacheManager().getToken();

        if (accessToken == null)
            accessToken = this.getAccessToken();
        
        if (getTokenCacheManager().isTokenExpired(accessToken))
            accessToken = this.getAccessToken(accessToken.refresh_token);

        headers.put('client_id', getClientId());
        headers.put('Authorization', String.format(
            'Bearer {0}', new List<String>{accessToken.access_token}
        ));
    }
    
   public class AccessTokenResponse {
        public String access_token;
        public String refresh_token;
        public String token_type;
        public Integer expires_in;
        public Datetime created_at;
    }
    
    private TokenCacheManager tokenCacheManager;

    private TokenCacheManager getTokenCacheManager() {
        
        if (tokenCacheManager == null)
            tokenCacheManager = new TokenCacheManager(getClientId());

        return tokenCacheManager;
    }

    protected AccessTokenResponse getAccessToken() {
      
        Callout_Config__c authTokenEndpointConfig = CalloutConfigSelector.getByLabel('SystemXAuthEndpoint');

        AccessTokenResponse accessToken = (AccessTokenResponse) this.makeHttpRequest(
            new HttpRequestDef()
                .setHttpMethod('GET')
                .setRelativeEndpoint(authTokenEndpointConfig.Endpoint__c)
                .setReturnType(AccessTokenResponse.class)
                .setHeader('Authorization', String.format('Basic {0}', new List<String>{ getClientId() }))
        );
        
        accessToken.created_at = Datetime.now();

        TokenCacheManager().cacheToken(accessToken); 

        return accessToken;
    }

    @TestVisible
    protected AccessTokenResponse getAccessToken(String refreshToken) {
        
        Callout_Config__c refreshTokenEndpointConfig = CalloutConfigSelector.getByName(
            'SytemXAuthRefreshToken'
        );

        String basicAuthorizationToken = EncodingUtil.base64Encode(
            Blob.valueOf(
                String.format(
                    '{0}:{1}',
                    new List<String>{
                        getClientId(),
                        getClientSecret()
                    }
                )
            )
        );

        AccessTokenResponse accessToken = (AccessTokenResponse) this.makeHttpRequest(
            new HttpRequestDef()
                .setHttpMethod('POST')
                .setRelativeEndpoint(refreshTokenEndpointConfig.Endpoint__c)
                .setBody(new RefreshTokenRequest(refreshToken))
                .setReturnType(AccessTokenResponse.class)
                .setHeader('Authorization', String.format('Basic {0}', new List<String>{ basicAuthorizationToken }))
        );

        accessToken.created_at = Datetime.now();

        TokenCacheManager().cacheToken(accessToken);

        return accessToken;
    }

    
}