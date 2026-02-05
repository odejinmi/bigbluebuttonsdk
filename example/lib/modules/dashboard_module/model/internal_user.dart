
import 'dart:convert';

List<InternalUser> internalUserFromJson(String str) => List<InternalUser>.from(json.decode(str).map((x) => InternalUser.fromJson(x)));

String internalUserToJson(List<InternalUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InternalUser {
    final String? token;
    final String? email;
    final String? firstname;
    final String? lastname;
    final String? phone;
    final DateTime? createdTime;
    final DateTime? updateTime;
    final int? updatedBy;
    final bool? isActive;
    final String? roles;
    final String? tenantId;
    final bool? visibility;
    final String? twoFactorAuth;
    final String? designation;
    final String? created;
    final bool? isAccountLocked;
    final String? cicodNumber;
    final String? userPlan;
    final bool? hasConfirmed;

    InternalUser({
        this.token,
        this.email,
        this.firstname,
        this.lastname,
        this.phone,
        this.createdTime,
        this.updateTime,
        this.updatedBy,
        this.isActive,
        this.roles,
        this.tenantId,
        this.visibility,
        this.twoFactorAuth,
        this.designation,
        this.created,
        this.isAccountLocked,
        this.cicodNumber,
        this.userPlan,
        this.hasConfirmed,
    });

    factory InternalUser.fromJson(Map<String, dynamic> json) => InternalUser(
        token: json["token"],
        email: json["email"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phone: json["phone"],
        createdTime: json["createdTime"] == null ? null : DateTime.parse(json["createdTime"]),
        updateTime: json["updateTime"] == null ? null : DateTime.parse(json["updateTime"]),
        updatedBy: json["updatedBy"],
        isActive: json["isActive"],
        roles: json["roles"],
        tenantId: json["tenantId"],
        visibility: json["visibility"],
        twoFactorAuth: json["twoFactorAuth"],
        designation: json["designation"],
        created: json["created"],
        isAccountLocked: json["isAccountLocked"],
        cicodNumber: json["cicodNumber"],
        userPlan: json["userPlan"],
        hasConfirmed: json["hasConfirmed"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "createdTime": createdTime?.toIso8601String(),
        "updateTime": updateTime?.toIso8601String(),
        "updatedBy": updatedBy,
        "isActive": isActive,
        "roles": roles,
        "tenantId": tenantId,
        "visibility": visibility,
        "twoFactorAuth": twoFactorAuth,
        "designation": designation,
        "created": created,
        "isAccountLocked": isAccountLocked,
        "cicodNumber": cicodNumber,
        "userPlan": userPlan,
        "hasConfirmed": hasConfirmed,
    };
}
