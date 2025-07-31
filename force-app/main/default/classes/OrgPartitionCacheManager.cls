public with sharing virtual class OrgPartitionCacheManager extends BasePartitionCacheManager {
    
    public OrgPartitionCacheManager(String partitionName) {
        super(partitionName);
    }

    public override Cache.Partition getPartition() {
        if (this.partition == null)
            this.partition = Cache.Org.getPartition(partitionName);
            
        return this.partition;
    }

    public override Integer getMinimumTtl() {
        return 300;
    }

    public override Integer getMaximumTtl() {
        return 172800;
    }

}