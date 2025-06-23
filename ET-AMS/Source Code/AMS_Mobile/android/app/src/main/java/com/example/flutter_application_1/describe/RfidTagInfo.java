package com.example.flutter_application_1.describe;

public class RfidTagInfo {
    private String Identifier;
    private String Model;
    private String EpcStorage;
    private String UserStorage;

    public RfidTagInfo(String v1, String v2, String v3, String v4) {
        this.Identifier = v1;
        this.Model = v2;
        this.EpcStorage = v3;
        this.UserStorage = v4;
    }

    public String Identifier() {
        return this.Identifier;
    }

    public String Model() {
        return this.Model;
    }

    public String Storage1() {
        return this.EpcStorage;
    }

    public String Storage2() {
        return this.UserStorage;
    }
}
