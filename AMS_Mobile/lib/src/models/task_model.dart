

class Task {
  final dynamic assetTagID;
  final String? assetID;
  final String? assetsStatus;
  final String? purchasedDate;
  final String? assetDescription;
  final String? categoryDescription;
  final String? cost;
  final String? createdDate;
  final String? siteID;
  final String? siteDescription;
  final String? locationID;
  final String? locationDescription;
  final String? depreciation;
  final String? depreciationMethod;
  final String? image;
  final String? isDepreciation;
  final String? categoryID;
  final String? employeeID;
  final String? employeeName;



  Task({
    required this.assetTagID,
     this.assetID,
    this.assetsStatus,
     this.locationDescription,
     this.assetDescription,
     this.purchasedDate,
     this.createdDate,
     this.cost,
     this.siteID,
     this.locationID,
     this.depreciation,
     this.depreciationMethod,
     this.image,
     this.isDepreciation,
     this.categoryID,
     this.employeeID,
     this.siteDescription,
     this.categoryDescription,
     this.employeeName,



  });

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    assetTagID: map['AssetTagID'],
    assetID: map['AssetID'],
    assetsStatus: map['AssetsStatus'],
    locationDescription: map['LocationDescription'],
    assetDescription: map['AssetDescription'],
    purchasedDate: map['PurchasedDate'],
    createdDate: map['CreatedDate'],
    cost: map['Cost'],
    siteID: map['SiteID'],
    locationID: map['Location'],
    depreciation: map['Depreciation'],
    depreciationMethod: map['DepreciationMethod'],
    image: map['Image'],
    isDepreciation: map['IsDepreciation'],
    categoryID: map['CategoryID'],
    employeeID: map['EmployeeID'],
    siteDescription: map['SiteDescription'],
    categoryDescription: map['CategoryDescription'],
    employeeName: map['EmployeeName'],


  );

  Map<String, dynamic> toMap() => {
    "AssetTagID": assetTagID,
    "AssetID": assetID,
    "AssetsStatus": assetsStatus,
    "LocationDescription": locationDescription,
    "AssetDescription": assetDescription,
    "PurchasedDate": purchasedDate,
    "CreatedDate": createdDate,
    "Cost": cost,
    "SiteID": siteID,
    "LocationID": locationID,
    "Depreciation": depreciation,
    "DepreciationMethod": depreciationMethod,
    "Image": image,
    "IsDepreciation": isDepreciation,
    "CategoryID": categoryID,
    "EmployeeID": employeeID,
    "SiteDescription": siteDescription,
    "CategoryDescription": categoryDescription,
    "EmployeeName": employeeName,


  };
}
