public without sharing class TrendingController {
    
    /*
        [
            {
                "attributes":
                {
                    "type": "AggregateResult"
                },
                "n": 1,
                "Ambiente__c": "Fachada",
                "Product2Id": "01t3s0000050KanAAE",
                "Grupo_Loja__c": "SC",
                "Referencia__c": "12900OF"
            },
            {
                "attributes":
                {
                    "type": "AggregateResult"
                },
                "n": 1,
                "Ambiente__c": "Itens de Assentamento",
                "Product2Id": "01t3s0000050KaiAAE",
                "Grupo_Loja__c": "SC",
                "Referencia__c": "12901OF"
            }
        ]
    */
    public static String getTrendingProducts(
        String ambiente, Boolean byState, String state, String region
    ){
        if(Cache.Org.contains('top6ProductTrending')) {
            return String.valueOf(Cache.Org.get('top6ProductTrending'));
        }

        String result = JSON.serialize([
            SELECT
                count(Id) n, 
                Ambiente__c, 
                Product2Id, 
                description,
                quote.Opportunity.Loja__r.Grupo_Loja__c,
                Product2.Referencia__c
            FROM quoteLineItem 
            WHERE quote.Opportunity.Loja__r.Grupo_Loja__c != null 
            GROUP BY Ambiente__c, quote.Opportunity.Loja__r.Grupo_Loja__c, Product2.Referencia__c, Product2Id, description
            ORDER BY count(id) DESC LIMIT 6
        ]);

        Cache.Org.put('top6ProductTrending', result, 300);

        return result;
    }



/*







        Estado + picklist = 6 items + uma contagem de 







*/



}