public with sharing class TriggerUtils {
    public static Boolean onlySkippableFieldsChanged(Map<Id, SObject> oldRecords, List<SObject> newRecords){

        if(oldRecords == null) return false;

        List<String> skippableRollupFields = new List<String>{
            'Numero_de_Oportunidades__c', 'LastModifiedDate', 'SystemModstamp'
        };

        Boolean onlySkippableFieldsChanged = true;

        for(SObject newRecord : newRecords){

            SObject oldRecord = oldRecords.get((Id) newRecord.get('Id'));

            Map<String, Object> newFields = newRecord.getPopulatedFieldsAsMap();
            Map<String, Object> oldFields = oldRecord.getPopulatedFieldsAsMap();
    
            String sobjectName = String.valueOf(newRecord.getSObjectType());

            Set<String> fieldNames = new Set<String>();
            fieldNames.addAll(newFields.keySet());
            fieldNames.addAll(oldFields.keySet());

            for (String fieldName : fieldNames){

                Object oldValue = oldFields?.get(fieldName);
                Object newValue = newFields?.get(fieldName);
    
                Boolean valueChanged = oldValue != newValue;

                if(valueChanged && !skippableRollupFields.contains(fieldName) && onlySkippableFieldsChanged)
                    onlySkippableFieldsChanged = false;
            }
        }

        return onlySkippableFieldsChanged;
    }
}