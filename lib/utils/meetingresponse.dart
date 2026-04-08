import 'dart:convert';

MeetingResponse meetingResponseFromJson(String str) =>
    MeetingResponse.fromJson(json.decode(str));

String meetingResponseToJson(MeetingResponse data) =>
    json.encode(data.toJson());

class MeetingResponse {
  final String? msg;
  final String? collection;
  final String? id;
  final MeetingFields? fields;

  MeetingResponse({
    this.msg,
    this.collection,
    this.id,
    this.fields,
  });

  factory MeetingResponse.fromJson(Map<String, dynamic> json) {
    return MeetingResponse(
      msg: json['msg']?.toString(),
      collection: json['collection']?.toString(),
      id: json['id']?.toString(),
      fields: json['fields'] != null ? MeetingFields.fromJson(json['fields']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'collection': collection,
        'id': id,
        'fields': fields?.toJson(),
      };
}

class MeetingFields {
  final String? meetingId;
  final BreakoutProps? breakoutProps;
  final DurationProps? durationProps;
  final List<dynamic>? groups;
  final String? guestLobbyMessage;
  final String? layout;
  final LockSettingsProps? lockSettingsProps;
  final bool? meetingEnded;
  final MeetingProp? meetingProp;
  final MetadataProp? metadataProp;
  final bool? publishedPoll;
  final List<dynamic>? randomlySelectedUser;
  final SystemProps? systemProps;
  final UsersProp? usersProp;
  final VoiceProp? voiceProp;
  final WelcomeProp? welcomeProp;

  MeetingFields({
    this.meetingId,
    this.breakoutProps,
    this.durationProps,
    this.groups,
    this.guestLobbyMessage,
    this.layout,
    this.lockSettingsProps,
    this.meetingEnded,
    this.meetingProp,
    this.metadataProp,
    this.publishedPoll,
    this.randomlySelectedUser,
    this.systemProps,
    this.usersProp,
    this.voiceProp,
    this.welcomeProp,
  });

  factory MeetingFields.fromJson(Map<String, dynamic> json) {
    return MeetingFields(
      meetingId: json['meetingId']?.toString(),
      breakoutProps: json['breakoutProps'] != null ? BreakoutProps.fromJson(json['breakoutProps']) : null,
      durationProps: json['durationProps'] != null ? DurationProps.fromJson(json['durationProps']) : null,
      groups: json['groups'] as List<dynamic>?,
      guestLobbyMessage: json['guestLobbyMessage']?.toString(),
      layout: json['layout']?.toString(),
      lockSettingsProps: json['lockSettingsProps'] != null ? LockSettingsProps.fromJson(json['lockSettingsProps']) : null,
      meetingEnded: json['meetingEnded'] as bool?,
      meetingProp: json['meetingProp'] != null ? MeetingProp.fromJson(json['meetingProp']) : null,
      metadataProp: json['metadataProp'] != null ? MetadataProp.fromJson(json['metadataProp']) : null,
      publishedPoll: json['publishedPoll'] as bool?,
      randomlySelectedUser: json['randomlySelectedUser'] as List<dynamic>?,
      systemProps: json['systemProps'] != null ? SystemProps.fromJson(json['systemProps']) : null,
      usersProp: json['usersProp'] != null ? UsersProp.fromJson(json['usersProp']) : null,
      voiceProp: json['voiceProp'] != null ? VoiceProp.fromJson(json['voiceProp']) : null,
      welcomeProp: json['welcomeProp'] != null ? WelcomeProp.fromJson(json['welcomeProp']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'meetingId': meetingId,
        'breakoutProps': breakoutProps?.toJson(),
        'durationProps': durationProps?.toJson(),
        'groups': groups,
        'guestLobbyMessage': guestLobbyMessage,
        'layout': layout,
        'lockSettingsProps': lockSettingsProps?.toJson(),
        'meetingEnded': meetingEnded,
        'meetingProp': meetingProp?.toJson(),
        'metadataProp': metadataProp?.toJson(),
        'publishedPoll': publishedPoll,
        'randomlySelectedUser': randomlySelectedUser,
        'systemProps': systemProps?.toJson(),
        'usersProp': usersProp?.toJson(),
        'voiceProp': voiceProp?.toJson(),
        'welcomeProp': welcomeProp?.toJson(),
      };
}

class BreakoutProps {
  final List<dynamic>? breakoutRooms;
  final bool? captureNotes;
  final String? captureNotesFilename;
  final bool? captureSlides;
  final String? captureSlidesFilename;
  final bool? freeJoin;
  final String? parentId;
  final bool? privateChatEnabled;
  final bool? record;
  final int? sequence;

  BreakoutProps({
    this.breakoutRooms,
    this.captureNotes,
    this.captureNotesFilename,
    this.captureSlides,
    this.captureSlidesFilename,
    this.freeJoin,
    this.parentId,
    this.privateChatEnabled,
    this.record,
    this.sequence,
  });

  factory BreakoutProps.fromJson(Map<String, dynamic> json) {
    return BreakoutProps(
      breakoutRooms: json['breakoutRooms'] as List<dynamic>?,
      captureNotes: json['captureNotes'] as bool?,
      captureNotesFilename: json['captureNotesFilename']?.toString(),
      captureSlides: json['captureSlides'] as bool?,
      captureSlidesFilename: json['captureSlidesFilename']?.toString(),
      freeJoin: json['freeJoin'] as bool?,
      parentId: json['parentId']?.toString(),
      privateChatEnabled: json['privateChatEnabled'] as bool?,
      record: json['record'] as bool?,
      sequence: json['sequence'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'breakoutRooms': breakoutRooms,
        'captureNotes': captureNotes,
        'captureNotesFilename': captureNotesFilename,
        'captureSlides': captureSlides,
        'captureSlidesFilename': captureSlidesFilename,
        'freeJoin': freeJoin,
        'parentId': parentId,
        'privateChatEnabled': privateChatEnabled,
        'record': record,
        'sequence': sequence,
      };
}

class DurationProps {
  final String? createdDate;
  final int? createdTime;
  final int? duration;
  final bool? endWhenNoModerator;
  final int? endWhenNoModeratorDelayInMinutes;
  final int? meetingExpireIfNoUserJoinedInMinutes;
  final int? meetingExpireWhenLastUserLeftInMinutes;
  final int? timeRemaining;
  final int? userActivitySignResponseDelayInMinutes;
  final int? userInactivityInspectTimerInMinutes;
  final int? userInactivityThresholdInMinutes;

  DurationProps({
    this.createdDate,
    this.createdTime,
    this.duration,
    this.endWhenNoModerator,
    this.endWhenNoModeratorDelayInMinutes,
    this.meetingExpireIfNoUserJoinedInMinutes,
    this.meetingExpireWhenLastUserLeftInMinutes,
    this.timeRemaining,
    this.userActivitySignResponseDelayInMinutes,
    this.userInactivityInspectTimerInMinutes,
    this.userInactivityThresholdInMinutes,
  });

  factory DurationProps.fromJson(Map<String, dynamic> json) {
    return DurationProps(
      createdDate: json['createdDate']?.toString(),
      createdTime: json['createdTime'] as int?,
      duration: json['duration'] as int?,
      endWhenNoModerator: json['endWhenNoModerator'] as bool?,
      endWhenNoModeratorDelayInMinutes:
          json['endWhenNoModeratorDelayInMinutes'] as int?,
      meetingExpireIfNoUserJoinedInMinutes:
          json['meetingExpireIfNoUserJoinedInMinutes'] as int?,
      meetingExpireWhenLastUserLeftInMinutes:
          json['meetingExpireWhenLastUserLeftInMinutes'] as int?,
      timeRemaining: json['timeRemaining'] as int?,
      userActivitySignResponseDelayInMinutes:
          json['userActivitySignResponseDelayInMinutes'] as int?,
      userInactivityInspectTimerInMinutes:
          json['userInactivityInspectTimerInMinutes'] as int?,
      userInactivityThresholdInMinutes:
          json['userInactivityThresholdInMinutes'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'createdDate': createdDate,
        'createdTime': createdTime,
        'duration': duration,
        'endWhenNoModerator': endWhenNoModerator,
        'endWhenNoModeratorDelayInMinutes': endWhenNoModeratorDelayInMinutes,
        'meetingExpireIfNoUserJoinedInMinutes':
            meetingExpireIfNoUserJoinedInMinutes,
        'meetingExpireWhenLastUserLeftInMinutes':
            meetingExpireWhenLastUserLeftInMinutes,
        'timeRemaining': timeRemaining,
        'userActivitySignResponseDelayInMinutes':
            userActivitySignResponseDelayInMinutes,
        'userInactivityInspectTimerInMinutes':
            userInactivityInspectTimerInMinutes,
        'userInactivityThresholdInMinutes': userInactivityThresholdInMinutes,
      };
}

class LockSettingsProps {
  final bool? disableCam;
  final bool? disableMic;
  final bool? disablePrivateChat;
  final bool? disablePublicChat;
  final bool? disableNotes;
  final bool? hideUserList;
  final bool? lockOnJoin;
  final bool? lockOnJoinConfigurable;
  final bool? hideViewersCursor;
  final bool? hideViewersAnnotation;
  final String? setBy;

  LockSettingsProps({
    this.disableCam,
    this.disableMic,
    this.disablePrivateChat,
    this.disablePublicChat,
    this.disableNotes,
    this.hideUserList,
    this.lockOnJoin,
    this.lockOnJoinConfigurable,
    this.hideViewersCursor,
    this.hideViewersAnnotation,
    this.setBy,
  });

  factory LockSettingsProps.fromJson(Map<String, dynamic> json) {
    return LockSettingsProps(
      disableCam: json['disableCam'] as bool?,
      disableMic: json['disableMic'] as bool?,
      disablePrivateChat: json['disablePrivateChat'] as bool?,
      disablePublicChat: json['disablePublicChat'] as bool?,
      disableNotes: json['disableNotes'] as bool?,
      hideUserList: json['hideUserList'] as bool?,
      lockOnJoin: json['lockOnJoin'] as bool?,
      lockOnJoinConfigurable: json['lockOnJoinConfigurable'] as bool?,
      hideViewersCursor: json['hideViewersCursor'] as bool?,
      hideViewersAnnotation: json['hideViewersAnnotation'] as bool?,
      setBy: json['setBy']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'disableCam': disableCam,
        'disableMic': disableMic,
        'disablePrivateChat': disablePrivateChat,
        'disablePublicChat': disablePublicChat,
        'disableNotes': disableNotes,
        'hideUserList': hideUserList,
        'lockOnJoin': lockOnJoin,
        'lockOnJoinConfigurable': lockOnJoinConfigurable,
        'hideViewersCursor': hideViewersCursor,
        'hideViewersAnnotation': hideViewersAnnotation,
        'setBy': setBy,
      };
}

class MeetingProp {
  final List<dynamic>? disabledFeatures;
  final String? extId;
  final String? intId;
  final bool? isBreakout;
  final int? maxPinnedCameras;
  final int? meetingCameraCap;
  final String? name;
  final bool? notifyRecordingIsOn;
  final String? presentationUploadExternalDescription;
  final String? presentationUploadExternalUrl;

  MeetingProp({
    this.disabledFeatures,
    this.extId,
    this.intId,
    this.isBreakout,
    this.maxPinnedCameras,
    this.meetingCameraCap,
    this.name,
    this.notifyRecordingIsOn,
    this.presentationUploadExternalDescription,
    this.presentationUploadExternalUrl,
  });

  factory MeetingProp.fromJson(Map<String, dynamic> json) {
    return MeetingProp(
      disabledFeatures: json['disabledFeatures'] as List<dynamic>?,
      extId: json['extId']?.toString(),
      intId: json['intId']?.toString(),
      isBreakout: json['isBreakout'] as bool?,
      maxPinnedCameras: json['maxPinnedCameras'] as int?,
      meetingCameraCap: json['meetingCameraCap'] as int?,
      name: json['name']?.toString(),
      notifyRecordingIsOn: json['notifyRecordingIsOn'] as bool?,
      presentationUploadExternalDescription:
          json['presentationUploadExternalDescription']?.toString(),
      presentationUploadExternalUrl: json['presentationUploadExternalUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'disabledFeatures': disabledFeatures,
        'extId': extId,
        'intId': intId,
        'isBreakout': isBreakout,
        'maxPinnedCameras': maxPinnedCameras,
        'meetingCameraCap': meetingCameraCap,
        'name': name,
        'notifyRecordingIsOn': notifyRecordingIsOn,
        'presentationUploadExternalDescription':
            presentationUploadExternalDescription,
        'presentationUploadExternalUrl': presentationUploadExternalUrl,
      };
}

class MetadataProp {
  final Map<String, dynamic>? metadata;

  MetadataProp({this.metadata});

  factory MetadataProp.fromJson(Map<String, dynamic> json) {
    return MetadataProp(
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'metadata': metadata,
      };
}

class SystemProps {
  final int? html5InstanceId;

  SystemProps({this.html5InstanceId});

  factory SystemProps.fromJson(Map<String, dynamic> json) {
    return SystemProps(
      html5InstanceId: json['html5InstanceId'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'html5InstanceId': html5InstanceId,
      };
}

class UsersProp {
  final bool? allowModsToEjectCameras;
  final bool? allowModsToUnmuteUsers;
  final bool? allowPromoteGuestToModerator;
  final bool? authenticatedGuest;
  final String? guestPolicy;
  final int? maxUserConcurrentAccesses;
  final int? maxUsers;
  final String? meetingLayout;
  final int? userCameraCap;
  final bool? webcamsOnlyForModerator;

  UsersProp({
    this.allowModsToEjectCameras,
    this.allowModsToUnmuteUsers,
    this.allowPromoteGuestToModerator,
    this.authenticatedGuest,
    this.guestPolicy,
    this.maxUserConcurrentAccesses,
    this.maxUsers,
    this.meetingLayout,
    this.userCameraCap,
    this.webcamsOnlyForModerator,
  });

  factory UsersProp.fromJson(Map<String, dynamic> json) {
    return UsersProp(
      allowModsToEjectCameras: json['allowModsToEjectCameras'] as bool?,
      allowModsToUnmuteUsers: json['allowModsToUnmuteUsers'] as bool?,
      allowPromoteGuestToModerator: json['allowPromoteGuestToModerator'] as bool?,
      authenticatedGuest: json['authenticatedGuest'] as bool?,
      guestPolicy: json['guestPolicy']?.toString(),
      maxUserConcurrentAccesses: json['maxUserConcurrentAccesses'] as int?,
      maxUsers: json['maxUsers'] as int?,
      meetingLayout: json['meetingLayout']?.toString(),
      userCameraCap: json['userCameraCap'] as int?,
      webcamsOnlyForModerator: json['webcamsOnlyForModerator'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'allowModsToEjectCameras': allowModsToEjectCameras,
        'allowModsToUnmuteUsers': allowModsToUnmuteUsers,
        'allowPromoteGuestToModerator': allowPromoteGuestToModerator,
        'authenticatedGuest': authenticatedGuest,
        'guestPolicy': guestPolicy,
        'maxUserConcurrentAccesses': maxUserConcurrentAccesses,
        'maxUsers': maxUsers,
        'meetingLayout': meetingLayout,
        'userCameraCap': userCameraCap,
        'webcamsOnlyForModerator': webcamsOnlyForModerator,
      };
}

class VoiceProp {
  final String? dialNumber;
  final bool? muteOnStart;
  final String? telVoice;
  final String? voiceConf;

  VoiceProp({
    this.dialNumber,
    this.muteOnStart,
    this.telVoice,
    this.voiceConf,
  });

  factory VoiceProp.fromJson(Map<String, dynamic> json) {
    return VoiceProp(
      dialNumber: json['dialNumber']?.toString(),
      muteOnStart: json['muteOnStart'] as bool?,
      telVoice: json['telVoice']?.toString(),
      voiceConf: json['voiceConf']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'dialNumber': dialNumber,
        'muteOnStart': muteOnStart,
        'telVoice': telVoice,
        'voiceConf': voiceConf,
      };
}

class WelcomeProp {
  final String? welcomeMsg;
  final String? welcomeMsgTemplate;

  WelcomeProp({
    this.welcomeMsg,
    this.welcomeMsgTemplate,
  });

  factory WelcomeProp.fromJson(Map<String, dynamic> json) {
    return WelcomeProp(
      welcomeMsg: json['welcomeMsg']?.toString(),
      welcomeMsgTemplate: json['welcomeMsgTemplate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'welcomeMsg': welcomeMsg,
        'welcomeMsgTemplate': welcomeMsgTemplate,
      };
}

class NotificationSettingsProps {
  final bool? joined;
  final bool? leave;
  final bool? newMessage;
  final bool? handRaise;
  final bool? error;

  NotificationSettingsProps({
    this.joined,
    this.leave,
    this.newMessage,
    this.handRaise,
    this.error,
  });

  NotificationSettingsProps copyWith({
    bool? joined,
    bool? leave,
    bool? newMessage,
    bool? handRaise,
    bool? error,
  }) {
    return NotificationSettingsProps(
      joined: joined ?? this.joined,
      leave: leave ?? this.leave,
      newMessage: newMessage ?? this.newMessage,
      handRaise: handRaise ?? this.handRaise,
      error: error ?? this.error,
    );
  }

  factory NotificationSettingsProps.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsProps(
      joined: json['joined'] as bool?,
      leave: json['leave'] as bool?,
      newMessage: json['newMessage'] as bool?,
      handRaise: json['handRaise'] as bool?,
      error: json['error'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'joined': joined,
        'leave': leave,
        'newMessage': newMessage,
        'handRaise': handRaise,
        'error': error,
      };
}
