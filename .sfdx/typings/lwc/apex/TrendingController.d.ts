declare module "@salesforce/apex/TrendingController.getTrendingProducts" {
  export default function getTrendingProducts(param: {ambiente: any, byState: any, state: any, region: any}): Promise<any>;
}
declare module "@salesforce/apex/TrendingController.findProductsVotes" {
  export default function findProductsVotes(param: {products: any}): Promise<any>;
}
declare module "@salesforce/apex/TrendingController.saveUserVote" {
  export default function saveUserVote(param: {vote: any, product: any}): Promise<any>;
}
