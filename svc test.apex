// Object obj = CarDealershipService.getCarTypes();
// String res = JSON.serializePretty(obj);
// System.debug(res);

//////////////////////////////////////////

Object obj = CarDealershipService.getInfoByCarType('a010R00000FGR6BQAX');
String res = JSON.serializePretty(obj);
System.debug(res);