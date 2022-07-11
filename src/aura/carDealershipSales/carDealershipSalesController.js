/**
 * Created by Dante on 07/07/2022.
 */

({
    renderSalesDetails : function(component, event){
        const details = JSON.parse(event.getParam('arguments')['details']);
        component.set('v.details', details);
    }
});