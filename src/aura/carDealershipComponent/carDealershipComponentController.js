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
                const detailsComponent =  component.find("details");
                detailsComponent.renderDetails(JSON.stringify(carType), JSON.stringify(details));
            }
        }
        action.setParams({ carTypeSFId });
        action.setCallback(this, (response) => getInfoByCarTypeCallback(response));
        $A.enqueueAction(action);
    }
});