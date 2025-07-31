public with sharing class SystemXTokenCacheManager extends OrgPartitionCacheManager {
    
    private String tokenKey;

    public AwsTokenCacheManager(String tokenKey) {
        super('partitionNameToSystemX'); 
        this.tokenKey = StringUtils.noSpecialChar(tokenKey).left(49);
    }

    public AbstractSystemFacadeService.AccessTokenResponse getToken() {
        Object token = super.get(this.tokenKey);
        return token == null
                ? null 
                : (AbstractSystemFacadeService.AccessTokenResponse) token;
    }

    public void cacheToken(AbstractSystemFacadeService.AccessTokenResponse accessToken) {
        if (accessToken == null)
            return;
        
        accessToken.expires_in = getMsFromSeconds(accessToken.expires_in);
        
        super.put(this.tokenKey, accessToken, getMinimumTtl());
    }

    public Integer getMsFromSeconds(Integer secs){
        return secs * 1000;
    }

    public Boolean isTokenExpired(AbstractSystemFacadeService.AccessTokenResponse accessToken) {
        
        if (accessToken == null)
            return true;

        if (accessToken.expires_in == null)
            return true;

        if (accessToken.created_at == null)
            return true;

        System.debug('acessToken: ' + accessToken.created_at);
        System.debug('acessToken: ' + accessToken.expires_in);

        Datetime expirationDatetime = accessToken.created_at.addSeconds(accessToken.expires_in);

        return Datetime.now() >= expirationDatetime;
    }

}