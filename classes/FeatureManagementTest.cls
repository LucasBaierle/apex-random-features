@isTest
public with sharing class FeatureManagementTest {
    @isTest
    static void FeatureManagementTest() {
        Test.startTest();
            Map<String, Set<String>> actualMissingAccess = 
                FeatureManagement.checkObjectAccess(
                    new Map<String, List<FeatureManagement.ObjectAccess>>{
                        'Order' => new List<FeatureManagement.ObjectAccess>{
                            FeatureManagement.ObjectAccess.READ,
                            FeatureManagement.ObjectAccess.aDELETE,
                            FeatureManagement.ObjectAccess.aUPDATE,
                            FeatureManagement.ObjectAccess.CREATE
                        }
                    },
                    true
                );

            Map<String, Map<String, Set<String>>> actualMissingFieldAccess = 
                FeatureManagement.checkFieldAccess(
                    new Map<String, Map<String, Set<FeatureManagement.FieldAccess>>>{
                        'Order' => new Map<String, Set<FeatureManagement.FieldAccess>>{
                            'Status' => new Set<FeatureManagement.FieldAccess>{
                                FeatureManagement.FieldAccess.READ,
                                FeatureManagement.FieldAccess.CREATE,
                                FeatureManagement.FieldAccess.aUPDATE
                            }
                        }
                    },
                    true
                );

        Test.stopTest();

        Assert.isTrue(actualMissingAccess.keySet().isEmpty());
        Assert.isTrue(actualMissingFieldAccess.keySet().isEmpty());
    }

    @isTest
    static void updateObjectResult(){
        Map<String, Set<String>> missingPermissions = new Map<String, Set<String>>();

        Test.startTest();
            FeatureManagement.updateObjectResult('Order', 'Visualizar', missingPermissions);
        Test.stopTest();

        Assert.isTrue(missingPermissions.get('Order').contains('Visualizar'));
    }

    @isTest
    static void updateObjectFieldResult(){
        Map<String, Map<String, Set<String>>> missingPermissions = 
            new Map<String, Map<String, Set<String>>>();

        Test.startTest();
            FeatureManagement.updateObjectFieldResult('Order', 'Status', 'Leitura', missingPermissions);
        Test.stopTest();

        Assert.isTrue(missingPermissions.get('Order').get('Status').contains('Leitura'));
    }
}