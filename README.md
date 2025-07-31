# apex-random-features

## 🌐 Façade for HTTP Callouts

- [**AbstractFacadeService&lt;T&gt;**](https://github.com/LucasBaierle/apex-random-features/blob/main/force-app/main/default/classes/AbstractFacadeService.cls): define o modelo genérico de façade para callouts, com estrutura base de requisições HTTP.  
- [**AbstractSystemFacadeService&lt;T&gt;**](https://github.com/LucasBaierle/apex-random-features/blob/main/force-app/main/default/classes/AbstractSystemFacadeService.cls): extensão abstrata para sistemas que requerem autenticação, com lógica de token, cache e configuração dinâmica.  
- [**SystemFacadeService**](https://github.com/LucasBaierle/apex-random-features/blob/main/force-app/main/default/classes/SystemFacadeService.cls): implementação concreta da façade para o sistema “System”, contendo métodos específicos de integração como criação e consulta de usuários.  
- [**RetryableHttp**](https://github.com/LucasBaierle/apex-random-features/blob/main/force-app/main/default/classes/RetryableHttp.cls): utilitário que encapsula a lógica de repetição automática para chamadas HTTP em caso de falhas.  
- [**SystemXTokenCacheManager**](https://github.com/LucasBaierle/apex-random-features/blob/main/force-app/main/default/classes/SystemXTokenCacheManager.cls): gerencia o cache particionado de tokens por sistema, otimizando autenticação e evitando chamadas desnecessárias.  

## 🔐 Apex

- [Encrypt and Decrypt on AES256/192/128](https://github.com/LucasBaierle/apex-random-features/blob/main/force-app/main/default/classes/SecurityUtils.cls) + [Test](https://github.com/LucasBaierle/apex-random-features/blob/main/force-app/main/default/classes/SecurityUtilsTest.cls)  
- [Skip triggers if only your specified fields were changed](https://github.com/LucasBaierle/apex-random-features/blob/main/force-app/main/default/classes/TriggerExecutionChecker.cls)

## ⚡ LWC

- [**Brazil State Selection**](https://github.com/LucasBaierle/apex-random-features/tree/main/force-app/main/default/lwc/brazilStateSelection) → [🎞️ Demo](https://github.com/LucasBaierle/apex-random-features/blob/main/force-app/main/default/lwc/brazilStateSelection/example.gif)  
- [**Confetti on Container**](https://github.com/LucasBaierle/apex-random-features/tree/main/force-app/main/default/lwc/confettiBox) → [🎞️ git demo](https://github.com/LucasBaierle/apex-random-features/blob/main/force-app/main/default/lwc/confettiBox/example.gif)  
- [**Star Rating**](https://github.com/LucasBaierle/apex-random-features/tree/main/force-app/main/default/lwc/starRating) → [🎞️ git demo](https://github.com/LucasBaierle/apex-random-features/blob/main/force-app/main/default/lwc/starRating/example.gif)
