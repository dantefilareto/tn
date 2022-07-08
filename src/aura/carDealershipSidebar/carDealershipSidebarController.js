({
    initSidebar: function (component) {
        const action = component.get("c.getCarTypes");
        function getCarTypesCallback(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const carTypesResponse = response.getReturnValue();
                console.log(carTypesResponse);
                component.set("v.carTypes", carTypesResponse['carTypes']);
            }
        }
        action.setCallback(this, (response)=>getCarTypesCallback(response));
        $A.enqueueAction(action);
    },
    onModelSelection: function (component, event) {
        const carTypeSFId = event.target.id;
        const myEvent = $A.get("e.c:onCarTypeSelected");
        myEvent.setParam("carTypeSFId", carTypeSFId);
        myEvent.fire();
    }
})