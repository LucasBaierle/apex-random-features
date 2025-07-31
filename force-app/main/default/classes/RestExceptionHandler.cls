@RestResource(urlMapping='/api/*')
global class RestExceptionHandler {

    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            String param = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

            if (param == 'invalid') {
                throw new ApplicationException(400, 'Parâmetro inválido.');
            }

            if (param == 'notfound') {
                throw new ApplicationException(404, 'Recurso não encontrado.');
            }
            
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{'status' => 'success', 'data' => 'Processado: ' + param}));

        } catch (ApplicationException e) {
            res.statusCode = e.errorCode;
            res.responseBody = Blob.valueOf(JSON.serialize(createErrorResponse(e.errorCode, e.getMessage())));
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(createErrorResponse(500, 'Erro interno do servidor: ' + e.getMessage())));
        }
    }

    private static Map<String, Object> createErrorResponse(Integer code, String message) {
        Map<String, Object> errorBody = new Map<String, Object>();
        errorBody.put('status', 'error');
        errorBody.put('code', code);
        errorBody.put('message', message);
        return errorBody;
    }

    public class ApplicationException extends Exception {
        public Integer errorCode;

        public ApplicationException(Integer code, String message){
            this.setMessage(message);
            this.errorCode = code;
        }
    }
}