/**
 * Created by Dante on 06/07/2022.
 */

public with sharing class CarDealershipService {

    @AuraEnabled
    public static CarTypesResponse getCarTypes() {
        CarTypesResponse response = new CarTypesResponse();
        List<CarType__c> carTypes = [
                SELECT Id, CarTypeId__c, Model__c, CarBrand__c, BodyStyle__c
                FROM CarType__c
                ORDER BY CarBrand__c, Model__c
        ];
        for (CarType__c carType : carTypes) {
            CarType obj = new CarType();
            obj.carTypeSFId = carType.Id;
            obj.carTypeId = Integer.valueOf(carType.CarTypeId__c);
            obj.model = carType.Model__c;
            obj.brand = carType.CarBrand__c;
            obj.bodyStyle = carType.BodyStyle__c;
            response.carTypes.add(obj);
        }
        System.debug('response: ' + JSON.serializePretty(response));
        return response;
    }
    @AuraEnabled
    public static DetailsResponse getInfoByCarType(String carTypeSFId) {
        DetailsResponse response = new DetailsResponse();
        List<CarSale__c> carSales = [
                SELECT Id, Price__c, Date__c, RelatedCar__r.Car_License__c,
                        RelatedCar__r.RelatedCarType__r.CarTypeId__c,
                        RelatedCar__r.RelatedCarType__r.Model__c,
                        RelatedCar__r.RelatedCarType__r.CarBrand__c,
                        RelatedCar__r.RelatedCarType__r.BodyStyle__c,
                        RelatedCar__r.CarCountry__c
                FROM CarSale__c
                WHERE RelatedCar__r.RelatedCarType__c = :carTypeSFId
                AND Date__c = N_YEARS_AGO:3 // The records point to 2019..
                ORDER BY Date__c
        ];
        Decimal totalAmtRaised = 0;
        Date mostExpSaleDate;
        Decimal mostExpSaleDateAmount = 0;
        String mostExpLicensePlate;
        Decimal mostExpLicensePlateAmount = 0;
        Map<Date, Decimal> AmountPerDate = new Map<Date, Decimal>();
        for(CarSale__c carSale : carSales){
            if(response.carType.carTypeSFId==null){
                response.carType.carTypeSFId = carSale.RelatedCar__r.RelatedCarType__r.Id;
                response.carType.carTypeId = Integer.valueOf(carSale.RelatedCar__r.RelatedCarType__r.CarTypeId__c);
                response.carType.model = carSale.RelatedCar__r.RelatedCarType__r.Model__c;
                response.carType.brand = carSale.RelatedCar__r.RelatedCarType__r.CarBrand__c;
                response.carType.bodyStyle = carSale.RelatedCar__r.RelatedCarType__r.BodyStyle__c;
            }
            totalAmtRaised+=carSale.Price__c;
            if(carSale.Price__c>mostExpLicensePlateAmount){
                mostExpLicensePlate = carSale.RelatedCar__r.Car_License__c;
                mostExpLicensePlateAmount = carSale.Price__c;
            }
            Decimal dayAmount = carSale.Price__c;
            if(AmountPerDate.containsKey(carSale.Date__c)){
                dayAmount += AmountPerDate.get(carSale.Date__c);
            }
            AmountPerDate.put(carSale.Date__c, dayAmount);
        }
        for(Date dateAux : AmountPerDate.keySet()){
            if(AmountPerDate.get(dateAux)>mostExpSaleDateAmount){
                mostExpSaleDate = dateAux;
                mostExpSaleDateAmount = AmountPerDate.get(dateAux);
            }
        }
        // In case there are no sales we still have to display some data
        if(carSales.isEmpty()){
            CarType__c carType = [
                    SELECT Id, CarTypeId__c, Model__c, CarBrand__c, BodyStyle__c
                    FROM CarType__c
                    WHERE Id =:carTypeSFId
            ];
            response.carType.carTypeSFId = carType.Id;
            response.carType.carTypeId = Integer.valueOf(carType.CarTypeId__c);
            response.carType.model = carType.Model__c;
            response.carType.brand = carType.CarBrand__c;
            response.carType.bodyStyle = carType.BodyStyle__c;
        }
        response.details.totalQttSold = carSales.size();
        response.details.totalAmtRaised = totalAmtRaised;
        response.details.mostExpSaleDate = mostExpSaleDate;
        response.details.mostExpLicensePlate = mostExpLicensePlate;
        response.details.mostExpSalePrice = mostExpLicensePlateAmount;
        return response;
    }
    public class CarTypesResponse {
        @AuraEnabled public List<CarType> carTypes = new List<CarType>();
    }
    public class CarType {
        @AuraEnabled public Id carTypeSFId { get; set; }
        @AuraEnabled public Integer carTypeId { get; set; }
        @AuraEnabled public String model { get; set; }
        @AuraEnabled public String brand { get; set; }
        @AuraEnabled public String bodyStyle { get; set; }
    }
    public class DetailsResponse {
        @AuraEnabled public Details details = new Details();
        @AuraEnabled public CarType carType = new CarType();
    }
    public class Details {
        @AuraEnabled public Integer totalQttSold { get; set; } // Total Quantity sold value
        @AuraEnabled public Decimal totalAmtRaised { get; set; }  // Total Money Raised value
        @AuraEnabled public Date mostExpSaleDate { get; set; }  // Most expensive sale date during the period
        @AuraEnabled public String mostExpLicensePlate { get; set; }  // Most expensive Car license plate during the period
        @AuraEnabled public Decimal mostExpSalePrice { get; set; }  // Most expensive sale price during the period
    }
}