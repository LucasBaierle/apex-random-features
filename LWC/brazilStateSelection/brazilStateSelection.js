import { LightningElement, api, track } from 'lwc';

export default class BrazilStateSelection extends LightningElement {

    @api recordId;

    @track selectedRegion = 'MG';

    handleRegionClick(event) {
        const region = event.currentTarget.dataset.region;

        if(region && region.length == 2)
            this.selectedRegion = region;

        console.log(this.selectedRegion);
    }

    get isTOSelected(){
        return this.selectedRegion == 'TO' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isBASelected(){
        return this.selectedRegion == 'BA' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isSESelected(){
        return this.selectedRegion == 'SE' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isPESelected(){
        return this.selectedRegion == 'PE' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isALSelected(){
        return this.selectedRegion == 'AL' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isRNSelected(){
        return this.selectedRegion == 'RN' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isCESelected(){
        return this.selectedRegion == 'CE' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isPISelected(){
        return this.selectedRegion == 'PI' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isMASelected(){
        return this.selectedRegion == 'MA' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isAPSelected(){
        return this.selectedRegion == 'AP' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isPASelected(){
        return this.selectedRegion == 'PA' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isRRSelected(){
        return this.selectedRegion == 'RR' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isAMSelected(){
        return this.selectedRegion == 'AM' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isACSelected(){
        return this.selectedRegion == 'AC' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isROSelected(){
        return this.selectedRegion == 'RO' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isMTSelected(){
        return this.selectedRegion == 'MT' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isMSSelected(){
        return this.selectedRegion == 'MS' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isGOSelected(){
        return this.selectedRegion == 'GO' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isPRSelected(){
        return this.selectedRegion == 'PR' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isSCSelected(){
        return this.selectedRegion == 'SC' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isRSSelected(){
        return this.selectedRegion == 'RS' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isSPSelected(){
        return this.selectedRegion == 'SP' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isMGSelected(){
        return this.selectedRegion == 'MG' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isRJSelected(){
        return this.selectedRegion == 'RJ' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isESSelected(){
        return this.selectedRegion == 'ES' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isDFSelected(){
        return this.selectedRegion == 'DF' ? 'fill: #003399' : 'fill: #0094d9';
    }
    get isPBSelected(){
        return this.selectedRegion == 'PB' ? 'fill: #003399' : 'fill: #0094d9';
    }
}