/**
 * Created by Dante on 07/07/2022.
 */

({
    handleCarTypeSelectionEvent: function (component, event) {
        event.stopPropagation();
        const carTypeSFId = event.getParam("carTypeSFId");
        const action = component.get("c.getInfoByCarType");
        function getInfoByCarTypeCallback(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const detailsResponse = response.getReturnValue();
                const details = detailsResponse['details'];
                const carType = detailsResponse['carType'];
                debugger;
                const salesDetailsComponent =  component.get("v.related")[0]
                salesDetailsComponent.renderSalesDetails(details, carType);
            }
        }
        action.setParams({ carTypeSFId });
        action.setCallback(this, (response) => getInfoByCarTypeCallback(response));
        $A.enqueueAction(action);
    }
});