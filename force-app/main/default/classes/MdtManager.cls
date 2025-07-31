//bad design to manual consent auth system. 
public with sharing class MdtManager implements Queueable { 
    public String data ; 
    public MdtManager(String data){
        this.data = data;  
    }
    public void execute(QueueableContext context) {

        BaseDocusingFacadeService.AccessTokenResponse token = 
            (BaseDocusingFacadeService.AccessTokenResponse) JSON.deserialize(
                data, BaseDocusingFacadeService.AccessTokenResponse.class
            );
  
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        
        Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
        metadataRec.fullName = 'Callout_Config__mdt.SystemX_Auth';
        metadataRec.label = 'SystemX_Auth';

        Metadata.CustomMetadataValue tokenField = new Metadata.CustomMetadataValue();
        tokenField.field = 'Access_Token__c';
        tokenField.value = token.access_token;

        Metadata.CustomMetadataValue expireAtField = new Metadata.CustomMetadataValue();
        expireAtField.field = 'Token_Expires_At__c';
        expireAtField.value = Datetime.now().getTime() + ((token.expires_in * 1000) * 0.9);

        Metadata.CustomMetadataValue refreshTokenField = new Metadata.CustomMetadataValue();
        refreshTokenField.field = 'Refresh_Token__c';
        refreshTokenField.value = token.refresh_token;

        metadataRec.values.add(tokenField);
        metadataRec.values.add(expireAtField);
        metadataRec.values.add(refreshTokenField);
  
        mdContainer.addMetadata(metadataRec);
          
        Metadata.Operations.enqueueDeployment(mdContainer, null);
    }
}