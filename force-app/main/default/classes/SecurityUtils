public with sharing class SecurityUtils {

    public class EncryptDef{
        public EncryptDef(){
            this.encryptType = 'AES256';
        }

        public String encryptType;
        public String encryptKey;
        public String inicializationVector;
        public Map<Object, Object> body;

        public EncryptDef setEncryptType(String encryptType){
            this.encryptType = encryptType;
            return this;
        }

        public EncryptDef setEncryptKey(String encryptKey){
            this.encryptKey = encryptKey;
            return this;
        }

        public EncryptDef setInicializationVector(String inicializationVector){
            this.inicializationVector = inicializationVector;
            return this;
        }

        public EncryptDef setBody(Map<Object, Object> body){
            this.body = body;
            return this;
        }

    }
   
    public Blob encryptOnAES256(EncryptDef encryptDef){
        Blob encrypted = Crypto.encrypt(
            encryptDef.encryptType, 
            Blob.valueOf(encryptDef.encryptKey), 
            Blob.valueOf(encryptDef.inicializationVector), 
            Blob.valueOf(JSON.serialize(encryptDef.body))
        );

        return encrypted;
    }

    public Blob decryptOnAES256(Blob encrypted, EncryptDef encryptDef){
        Blob decrypted = Crypto.decrypt(
            encryptDef.encryptType, 
            Blob.valueOf(encryptDef.encryptKey), 
            Blob.valueOf(encryptDef.inicializationVector), 
            encrypted
        );

        return decrypted;
    }

}
