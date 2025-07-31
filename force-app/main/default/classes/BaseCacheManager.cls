public with sharing abstract class BaseCacheManager {
    
    protected Boolean cacheEnabled { get; set; }

    public BaseCacheManager() {
        this.cacheEnabled = true;
    }
    
    public Boolean toggleEnabled() {
        cacheEnabled = !cacheEnabled;
        return cacheEnabled;
    }

    public abstract Integer getMinimumTtl();

    public abstract Integer getMaximumTtl();

    public abstract Object get(String key);

    public abstract void put(String key, Object value, Integer ttlSecs);

    public abstract Boolean remove(String key);

}