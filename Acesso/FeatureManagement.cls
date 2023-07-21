public with sharing class FeatureManagement {
    public static Map<String, Schema.SObjectType> globalDescribe {
        protected set; 
        get {
            if(globalDescribe == null)
                globalDescribe = Schema.getGlobalDescribe();

            return globalDescribe;
        }
    }
    
    public enum ObjectAccess {
        READ, aUPDATE, CREATE, aDELETE
    }
    public enum FieldAccess {
        READ, aUPDATE, CREATE
    }

    public static Map<String, Set<String>> checkObjectAccess(Map<String, List<ObjectAccess>> accessRequiredByObject, Boolean raiseError){
        
        Map<String, Set<String>> missingPermissions = new Map<String, Set<String>>();

        for(String objectName : accessRequiredByObject.keySet()){
            List<ObjectAccess> requiredAccess = accessRequiredByObject.get(objectName);

            if(requiredAccess.contains(ObjectAccess.READ)){
                Boolean hasAccess = globalDescribe.get(objectName).getDescribe().isAccessible();

                if(!hasAccess) 
                    updateObjectResult(objectName, 'Visualizar', missingPermissions);
            }
            if(requiredAccess.contains(ObjectAccess.aUPDATE)){
                Boolean hasAccess = globalDescribe.get(objectName).getDescribe().isUpdateable();

                if(!hasAccess) 
                    updateObjectResult(objectName, 'Atualizar', missingPermissions);
            }
            if(requiredAccess.contains(ObjectAccess.CREATE)){
                Boolean hasAccess = globalDescribe.get(objectName).getDescribe().isCreateable();

                if(!hasAccess) 
                    updateObjectResult(objectName, 'Criar', missingPermissions);
            }
            if(requiredAccess.contains(ObjectAccess.aDELETE)){
                Boolean hasAccess = globalDescribe.get(objectName).getDescribe().isDeletable();

                if(!hasAccess) 
                    updateObjectResult(objectName, 'Deletar', missingPermissions);
            }

            if(raiseError && missingPermissions.containsKey(objectName)){
                throw new MissingAccessException(String.format(
                    'Seu usuário precisa das seguintes permissões: {0}. Para o objeto: {1}',
                    new List<String>{String.join(new List<String>(missingPermissions.get(objectName)), ', '), objectName}
                ));
            }
        }

        return missingPermissions;
    }

    public static Map<String, Map<String, Set<String>>> checkFieldAccess(
        Map<String, Map<String, Set<FieldAccess>>> requiredFieldAccess, Boolean raiseError
    ){

        Map<String, Map<String, Set<String>>> missingPermissions = new Map<String, Map<String, Set<String>>>();

        for(String objectName : requiredFieldAccess.keySet()){
            Map<String, Schema.SObjectField> objectFields = globalDescribe.get(objectName).getDescribe().fields.getMap();

            for(String fieldName : requiredFieldAccess.get(objectName).keySet()){
                Set<FieldAccess> requiredAccess = requiredFieldAccess.get(objectName).get(fieldName);

                if(requiredAccess.contains(FieldAccess.CREATE)){
                    Boolean hasAccess = objectFields.get(fieldName).getDescribe().isCreateable();

                    if(!hasAccess) 
                        updateObjectFieldResult(objectName, fieldName, 'Criação', missingPermissions);
                }
                if(requiredAccess.contains(FieldAccess.READ)){
                    Boolean hasAccess = objectFields.get(fieldName).getDescribe().isAccessible();

                    if(!hasAccess) 
                        updateObjectFieldResult(objectName, fieldName, 'Leitura', missingPermissions);
                }
                if(requiredAccess.contains(FieldAccess.aUPDATE)){
                    Boolean hasAccess = objectFields.get(fieldName).getDescribe().isUpdateable();

                    if(!hasAccess) 
                        updateObjectFieldResult(objectName, fieldName, 'Atualização', missingPermissions);
                }

                if(raiseError && missingPermissions.containsKey(objectName) && missingPermissions.get(objectName).containsKey(fieldName)){
                    throw new MissingAccessException(String.format(
                        'Seu usuário precisa das seguintes permissões: {0}, para o Campo: {1} do objeto: {2}',
                        new List<String>{String.join(new List<String>(missingPermissions.get(objectName).get(fieldName)), ', '), fieldName, objectName}
                    ));
                }
            }
        }

        return missingPermissions;
    }

    public static void updateObjectResult(
        String objectName, 
        String missingAccess,
        Map<String, Set<String>> missingPermissions
    ){
        if(!missingPermissions.containsKey(objectName))
            missingPermissions.put(objectName, new Set<String>());

        missingPermissions.get(objectName).add(missingAccess);
    }

    public static void updateObjectFieldResult(
        String objectName, 
        String fieldName,
        String missingAccess,
        Map<String, Map<String, Set<String>>> missingPermissions
    ){
        if(!missingPermissions.containsKey(objectName))
            missingPermissions.put(objectName, new Map<String, Set<String>>());

        if(!missingPermissions.get(objectName).containsKey(fieldName))
            missingPermissions.get(objectName).put(fieldName, new Set<String>());

        missingPermissions.get(objectName).get(fieldName).add(missingAccess);
    }

    private class MissingAccessException extends Exception{}
}