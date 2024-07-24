@IsTest
public with sharing class SecurityUtilsTest {
   
    @isTest
    static void encryptDecryptOnAES256Test(){

        Map<Object, Object> expectedData = new Map<Object, Object>{
            'email' => 'lucasBayer24@gmail.com',
            'date' => '2024-07-24 23:01:12'
        };
        String type = 'AES256';
        String key = 'tYsHr8UmLgvWwTQrTvXU4tcl4AsuHhpu';
        String vector = 'tYsHr8UTrXUuHhpu';

        SecurityUtils security = new SecurityUtils();

        Test.startTest();

            Blob encriptedToken = security.encryptOnAES256(
                new SecurityUtils.EncryptDef()
                    .setEncryptType(type)
                    .setEncryptKey(key)
                    .setInicializationVector(vector)
                    .setBody(expectedData)
            );

            Blob actual = security.decryptOnAES256(
                encriptedToken,
                new SecurityUtils.EncryptDef()
                    .setEncryptType(type)
                    .setEncryptKey(key)
                    .setInicializationVector(vector)
            );

        Test.stopTest();

        Assert.areEqual(JSON.serialize(expectedData), actual.toString());
    }

}
