public with sharing abstract class BasePartitionCacheManager extends BaseCacheManager {
    
    protected String partitionName {get; set; }
    protected Cache.Partition partition { get; set; }

    public BasePartitionCacheManager(String partitionName) {
        this.partitionName = partitionName;
    }
    
    public abstract Cache.Partition getPartition();

    public override Object get(String key) {
        if (!cacheEnabled) return null;
        return this.getPartition().get(key);
    }

    public override void put(String key, Object value, Integer ttlSecs) {
        if (!cacheEnabled) return;

        if(ttlSecs > getMaximumTtl()) ttlSecs = getMaximumTtl();
            
        if(ttlSecs < getMinimumTtl()) ttlSecs = getMinimumTtl();

        this.getPartition().put(key, value, ttlSecs);
    }

    public override Boolean remove(String key) {
        if (!cacheEnabled) return false;
        return this.getPartition().remove(key);
    }

}