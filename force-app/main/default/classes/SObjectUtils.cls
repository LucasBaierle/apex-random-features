public with sharing class SObjectUtils {

    public static Boolean isValidSalesforceId(String sfId, System.Type type){
        try {
            if ( Pattern.compile( '[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}' ).matcher(sfId).matches() ){
                Id id = sfId;

                sObject sObj = (sObject) type.newInstance();
                sObj.Id = id;

                return true;
            }
        } catch ( Exception e ) {}

        return false;
    }
    
    public static List<String> convertIdsToStrings(List<Id> idList) {
        if (idList == null) {
            return new List<String>();
        }
        return new List<String>((List<String>)idList);
    }

    public static Set<String> convertIdSetToStringSet(Set<Id> idSet) {
        if (idSet == null) {
            return new Set<String>();
        }
        return new Set<String>((List<String>)new List<Id>(idSet));
    }

    public static List<Id> convertStringsToIds(List<String> stringList) {
        if (stringList == null) {
            return new List<Id>();
        }
        return new List<Id>((List<Id>)stringList);
    }

    public static Set<Id> convertStringSetToIdSet(Set<String> stringSet) {
        if (stringSet == null) {
            return new Set<Id>();
        }
        return new Set<Id>((List<Id>)new List<String>(stringSet));
    }

}