import { LightningElement, api, track } from 'lwc';
import starRatingStyles from './starRating.css';

export default class StarRating extends LightningElement {

    @api ratingValue = '';
    @api handleQuestionRes = (e, n, v)=>{};
    @api questionNumber = 0;

    onClick(event){
        const value = event.target.dataset.value;
        this._ratingValue = value;
        this.handleQuestionRes(event, this.questionNumber, value);
    }

    get isRating1Checked() {
        return this.ratingValue === '1';
    }

    get isRating2Checked() {
        return this.ratingValue === '2';
    }

    get isRating3Checked() {
        return this.ratingValue === '3';
    }

    get isRating4Checked() {
        return this.ratingValue === '4';
    }

    get isRating5Checked() {
        return this.ratingValue === '5';
    }
}