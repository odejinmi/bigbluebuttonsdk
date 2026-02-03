import 'dart:convert';

InviteHistory inviteHistoryFromJson(String str) => InviteHistory.fromJson(json.decode(str));

String inviteHistoryToJson(InviteHistory data) => json.encode(data.toJson());

class InviteHistory {
    int currentPage;
    List<Invite> data;
    String firstPageUrl;
    int from;
    int lastPage;
    String lastPageUrl;
    List<Link> links;
    dynamic nextPageUrl;
    String path;
    int perPage;
    dynamic prevPageUrl;
    int to;
    int total;

    InviteHistory({
        required this.currentPage,
        required this.data,
        required this.firstPageUrl,
        required this.from,
        required this.lastPage,
        required this.lastPageUrl,
        required this.links,
        required this.nextPageUrl,
        required this.path,
        required this.perPage,
        required this.prevPageUrl,
        required this.to,
        required this.total,
    });

    factory InviteHistory.fromJson(Map<String, dynamic> json) => InviteHistory(
        currentPage: json["current_page"],
        data: List<Invite>.from(json["data"].map((x) => Invite.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
    };
}

class Invite {
    int id;
    int userId;
    int? roomId;
    String type;
    String hostname;
    String roomlink;
    String accesscode;
    String title;
    DateTime date;
    String time;
    String totime;
    String roomname;
    String timezone;
    String additional;
    String guest;
    DateTime createdAt;
    DateTime updatedAt;

    Invite({
        required this.id,
        required this.userId,
        required this.roomId,
        required this.type,
        required this.hostname,
        required this.roomlink,
        required this.accesscode,
        required this.title,
        required this.date,
        required this.time,
        required this.totime,
        required this.roomname,
        required this.timezone,
        required this.additional,
        required this.guest,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Invite.fromJson(Map<String, dynamic> json) => Invite(
        id: json["id"],
        userId: json["user_id"],
        roomId: json["room_id"],
        type: json["type"],
        hostname: json["hostname"],
        roomlink: json["roomlink"],
        accesscode: json["accesscode"],
        title: json["title"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        totime: json["totime"],
        roomname: json["roomname"],
        timezone: json["timezone"],
        additional: json["additional"],
        guest: json["guest"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "room_id": roomId,
        "type": type,
        "hostname": hostname,
        "roomlink": roomlink,
        "accesscode": accesscode,
        "title": title,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "totime": totime,
        "roomname": roomname,
        "timezone": timezone,
        "additional": additional,
        "guest": guest,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Link {
    String? url;
    String label;
    bool active;

    Link({
        required this.url,
        required this.label,
        required this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}