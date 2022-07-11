/**
 * Created by Dante on 08/07/2022.
 */

({
    renderDetails : function(component, event){
        const carType = JSON.parse(event.getParam('arguments')['carType']);
        const details = JSON.parse(event.getParam('arguments')['details']);
        console.log(carType);
        console.log(details);
        component.set('v.carType', carType);
        component.set('v.details', details);
    }
});