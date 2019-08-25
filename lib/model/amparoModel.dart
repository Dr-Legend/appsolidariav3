import 'dart:convert';

Amparo amparoFromJson(String str) {
  final jsonData = json.decode(str);
  return Amparo.fromMap(jsonData);
}

String amparoToJson(Amparo data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Amparo {

  int policy;

  String coverName; //Nombre del amparo
  String initialDate;
  String finalDate;
  int additionalTerm; //Plazo adicional del amparo en años

  double porcentage;
  double insuredValue;
  double coverRate;
  double minimumRate;
  double insurancePremium;
  

  Amparo({

    this.policy,

    this.coverName,
    this.initialDate,
    this.finalDate,
    this.additionalTerm,

    this.porcentage,
    this.insuredValue,
    this.coverRate,
    this.minimumRate,
    this.insurancePremium,
    
  });

  factory Amparo.fromMap(Map<String, dynamic> json) => new Amparo(

    policy: json["poliza"],

    coverName: json["concepto"],
    initialDate: json["fechaInicial"],
    finalDate: json["fechaFinal"],
    additionalTerm: json["plazoAdic"],

    porcentage: json["porcentaje"],
    insuredValue: json["valorAsegurado"],
    coverRate: json["tasaAmparo"],
    minimumRate: json["tasaMinima"],
    insurancePremium: json["prima"],
    
  );

  Map<String, dynamic> toMap() => {
    "concepto": coverName,
    "fechaInicial": initialDate,
    "fechaFinal": finalDate,
    "plazoAdic" :additionalTerm,

    "porcentaje": porcentage,
    "valorAsegurado": insuredValue,
    "tasaAmparo": coverRate,
    "tasaMinima": minimumRate,
    "prima": insurancePremium,
  };

  @override
  String toString() {
    return "Policy: $policy, CoverNAme: $coverName, "
        "CoverInitialDate: $initialDate, CoverFinalDate: $finalDate, AditionalTerm: $additionalTerm, Porcentage: $porcentage,"
        "InsuredValue: $insuredValue, CoverRate: $coverRate, MinimumInsuranceRate: $minimumRate,"
        "Premium: $insurancePremium";
  }
}
