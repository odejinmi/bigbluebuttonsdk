import 'dart:convert';

MeetingResponse meetingResponseFromJson(String str) =>
    MeetingResponse.fromJson(json.decode(str));

String meetingResponseToJson(MeetingResponse data) =>
    json.encode(data.toJson());

class MeetingResponse {
  final String msg;
  final String collection;
  final String id;
  final MeetingFields fields;

  MeetingResponse({
    required this.msg,
    required this.collection,
    required this.id,
    required this.fields,
  });

  factory MeetingResponse.fromJson(Map<String, dynamic> json) {
    return MeetingResponse(
      msg: json['msg'],
      collection: json['collection'],
      id: json['id'],
      fields: MeetingFields.fromJson(json['fields']),
    );
  }

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'collection': collection,
        'id': id,
        'fields': fields.toJson(),
      };
}

class MeetingFields {
  final String meetingId;
  final BreakoutProps breakoutProps;
  final DurationProps durationProps;
  final List<dynamic> groups;
  final String guestLobbyMessage;
  final String layout;
  final LockSettingsProps lockSettingsProps;
  final bool meetingEnded;
  final MeetingProp meetingProp;
  final MetadataProp metadataProp;
  final bool publishedPoll;
  final List<dynamic> randomlySelectedUser;
  final SystemProps systemProps;
  final UsersProp usersProp;
  final VoiceProp voiceProp;
  final WelcomeProp welcomeProp;

  MeetingFields({
    required this.meetingId,
    required this.breakoutProps,
    required this.durationProps,
    required this.groups,
    required this.guestLobbyMessage,
    required this.layout,
    required this.lockSettingsProps,
    required this.meetingEnded,
    required this.meetingProp,
    required this.metadataProp,
    required this.publishedPoll,
    required this.randomlySelectedUser,
    required this.systemProps,
    required this.usersProp,
    required this.voiceProp,
    required this.welcomeProp,
  });

  factory MeetingFields.fromJson(Map<String, dynamic> json) {
    return MeetingFields(
      meetingId: json['meetingId'],
      breakoutProps: BreakoutProps.fromJson(json['breakoutProps']),
      durationProps: DurationProps.fromJson(json['durationProps']),
      groups: json['groups'],
      guestLobbyMessage: json['guestLobbyMessage'],
      layout: json['layout'],
      lockSettingsProps: LockSettingsProps.fromJson(json['lockSettingsProps']),
      meetingEnded: json['meetingEnded'],
      meetingProp: MeetingProp.fromJson(json['meetingProp']),
      metadataProp: MetadataProp.fromJson(json['metadataProp']),
      publishedPoll: json['publishedPoll'],
      randomlySelectedUser: json['randomlySelectedUser'],
      systemProps: SystemProps.fromJson(json['systemProps']),
      usersProp: UsersProp.fromJson(json['usersProp']),
      voiceProp: VoiceProp.fromJson(json['voiceProp']),
      welcomeProp: WelcomeProp.fromJson(json['welcomeProp']),
    );
  }

  Map<String, dynamic> toJson() => {
        'meetingId': meetingId,
        'breakoutProps': breakoutProps.toJson(),
        'durationProps': durationProps.toJson(),
        'groups': groups,
        'guestLobbyMessage': guestLobbyMessage,
        'layout': layout,
        'lockSettingsProps': lockSettingsProps.toJson(),
        'meetingEnded': meetingEnded,
        'meetingProp': meetingProp.toJson(),
        'metadataProp': metadataProp.toJson(),
        'publishedPoll': publishedPoll,
        'randomlySelectedUser': randomlySelectedUser,
        'systemProps': systemProps.toJson(),
        'usersProp': usersProp.toJson(),
        'voiceProp': voiceProp.toJson(),
        'welcomeProp': welcomeProp.toJson(),
      };
}

class BreakoutProps {
  final List<dynamic> breakoutRooms;
  final bool captureNotes;
  final String captureNotesFilename;
  final bool captureSlides;
  final String captureSlidesFilename;
  final bool freeJoin;
  final String parentId;
  final bool privateChatEnabled;
  final bool record;
  final int sequence;

  BreakoutProps({
    required this.breakoutRooms,
    required this.captureNotes,
    required this.captureNotesFilename,
    required this.captureSlides,
    required this.captureSlidesFilename,
    required this.freeJoin,
    required this.parentId,
    required this.privateChatEnabled,
    required this.record,
    required this.sequence,
  });

  factory BreakoutProps.fromJson(Map<String, dynamic> json) {
    return BreakoutProps(
      breakoutRooms: json['breakoutRooms'],
      captureNotes: json['captureNotes'],
      captureNotesFilename: json['captureNotesFilename'],
      captureSlides: json['captureSlides'],
      captureSlidesFilename: json['captureSlidesFilename'],
      freeJoin: json['freeJoin'],
      parentId: json['parentId'],
      privateChatEnabled: json['privateChatEnabled'],
      record: json['record'],
      sequence: json['sequence'],
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
  final String createdDate;
  final int createdTime;
  final int duration;
  final bool endWhenNoModerator;
  final int endWhenNoModeratorDelayInMinutes;
  final int meetingExpireIfNoUserJoinedInMinutes;
  final int meetingExpireWhenLastUserLeftInMinutes;
  final int timeRemaining;
  final int userActivitySignResponseDelayInMinutes;
  final int userInactivityInspectTimerInMinutes;
  final int userInactivityThresholdInMinutes;

  DurationProps({
    required this.createdDate,
    required this.createdTime,
    required this.duration,
    required this.endWhenNoModerator,
    required this.endWhenNoModeratorDelayInMinutes,
    required this.meetingExpireIfNoUserJoinedInMinutes,
    required this.meetingExpireWhenLastUserLeftInMinutes,
    required this.timeRemaining,
    required this.userActivitySignResponseDelayInMinutes,
    required this.userInactivityInspectTimerInMinutes,
    required this.userInactivityThresholdInMinutes,
  });

  factory DurationProps.fromJson(Map<String, dynamic> json) {
    return DurationProps(
      createdDate: json['createdDate'],
      createdTime: json['createdTime'],
      duration: json['duration'],
      endWhenNoModerator: json['endWhenNoModerator'],
      endWhenNoModeratorDelayInMinutes:
          json['endWhenNoModeratorDelayInMinutes'],
      meetingExpireIfNoUserJoinedInMinutes:
          json['meetingExpireIfNoUserJoinedInMinutes'],
      meetingExpireWhenLastUserLeftInMinutes:
          json['meetingExpireWhenLastUserLeftInMinutes'],
      timeRemaining: json['timeRemaining'],
      userActivitySignResponseDelayInMinutes:
          json['userActivitySignResponseDelayInMinutes'],
      userInactivityInspectTimerInMinutes:
          json['userInactivityInspectTimerInMinutes'],
      userInactivityThresholdInMinutes:
          json['userInactivityThresholdInMinutes'],
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
  final bool disableCam;
  final bool disableMic;
  final bool disablePrivateChat;
  final bool disablePublicChat;
  final bool disableNotes;
  final bool hideUserList;
  final bool lockOnJoin;
  final bool lockOnJoinConfigurable;
  final bool hideViewersCursor;
  final bool hideViewersAnnotation;
  final String setBy;

  LockSettingsProps({
    required this.disableCam,
    required this.disableMic,
    required this.disablePrivateChat,
    required this.disablePublicChat,
    required this.disableNotes,
    required this.hideUserList,
    required this.lockOnJoin,
    required this.lockOnJoinConfigurable,
    required this.hideViewersCursor,
    required this.hideViewersAnnotation,
    required this.setBy,
  });

  factory LockSettingsProps.fromJson(Map<String, dynamic> json) {
    return LockSettingsProps(
      disableCam: json['disableCam'],
      disableMic: json['disableMic'],
      disablePrivateChat: json['disablePrivateChat'],
      disablePublicChat: json['disablePublicChat'],
      disableNotes: json['disableNotes'],
      hideUserList: json['hideUserList'],
      lockOnJoin: json['lockOnJoin'],
      lockOnJoinConfigurable: json['lockOnJoinConfigurable'],
      hideViewersCursor: json['hideViewersCursor'],
      hideViewersAnnotation: json['hideViewersAnnotation'],
      setBy: json['setBy'],
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
  final List<dynamic> disabledFeatures;
  final String extId;
  final String intId;
  final bool isBreakout;
  final int maxPinnedCameras;
  final int meetingCameraCap;
  final String name;
  final bool notifyRecordingIsOn;
  final String presentationUploadExternalDescription;
  final String presentationUploadExternalUrl;

  MeetingProp({
    required this.disabledFeatures,
    required this.extId,
    required this.intId,
    required this.isBreakout,
    required this.maxPinnedCameras,
    required this.meetingCameraCap,
    required this.name,
    required this.notifyRecordingIsOn,
    required this.presentationUploadExternalDescription,
    required this.presentationUploadExternalUrl,
  });

  factory MeetingProp.fromJson(Map<String, dynamic> json) {
    return MeetingProp(
      disabledFeatures: json['disabledFeatures'],
      extId: json['extId'],
      intId: json['intId'],
      isBreakout: json['isBreakout'],
      maxPinnedCameras: json['maxPinnedCameras'],
      meetingCameraCap: json['meetingCameraCap'],
      name: json['name'],
      notifyRecordingIsOn: json['notifyRecordingIsOn'],
      presentationUploadExternalDescription:
          json['presentationUploadExternalDescription'],
      presentationUploadExternalUrl: json['presentationUploadExternalUrl'],
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
  final Map<String, dynamic> metadata;

  MetadataProp({required this.metadata});

  factory MetadataProp.fromJson(Map<String, dynamic> json) {
    return MetadataProp(
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() => {
        'metadata': metadata,
      };
}

class SystemProps {
  final int html5InstanceId;

  SystemProps({required this.html5InstanceId});

  factory SystemProps.fromJson(Map<String, dynamic> json) {
    return SystemProps(
      html5InstanceId: json['html5InstanceId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'html5InstanceId': html5InstanceId,
      };
}

class UsersProp {
  final bool allowModsToEjectCameras;
  final bool allowModsToUnmuteUsers;
  final bool allowPromoteGuestToModerator;
  final bool authenticatedGuest;
  final String guestPolicy;
  final int maxUserConcurrentAccesses;
  final int maxUsers;
  final String meetingLayout;
  final int userCameraCap;
  final bool webcamsOnlyForModerator;

  UsersProp({
    required this.allowModsToEjectCameras,
    required this.allowModsToUnmuteUsers,
    required this.allowPromoteGuestToModerator,
    required this.authenticatedGuest,
    required this.guestPolicy,
    required this.maxUserConcurrentAccesses,
    required this.maxUsers,
    required this.meetingLayout,
    required this.userCameraCap,
    required this.webcamsOnlyForModerator,
  });

  factory UsersProp.fromJson(Map<String, dynamic> json) {
    return UsersProp(
      allowModsToEjectCameras: json['allowModsToEjectCameras'],
      allowModsToUnmuteUsers: json['allowModsToUnmuteUsers'],
      allowPromoteGuestToModerator: json['allowPromoteGuestToModerator'],
      authenticatedGuest: json['authenticatedGuest'],
      guestPolicy: json['guestPolicy'],
      maxUserConcurrentAccesses: json['maxUserConcurrentAccesses'],
      maxUsers: json['maxUsers'],
      meetingLayout: json['meetingLayout'],
      userCameraCap: json['userCameraCap'],
      webcamsOnlyForModerator: json['webcamsOnlyForModerator'],
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
  final String dialNumber;
  final bool muteOnStart;
  final String telVoice;
  final String voiceConf;

  VoiceProp({
    required this.dialNumber,
    required this.muteOnStart,
    required this.telVoice,
    required this.voiceConf,
  });

  factory VoiceProp.fromJson(Map<String, dynamic> json) {
    return VoiceProp(
      dialNumber: json['dialNumber'],
      muteOnStart: json['muteOnStart'],
      telVoice: json['telVoice'],
      voiceConf: json['voiceConf'],
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
  final String welcomeMsg;
  final String welcomeMsgTemplate;

  WelcomeProp({
    required this.welcomeMsg,
    required this.welcomeMsgTemplate,
  });

  factory WelcomeProp.fromJson(Map<String, dynamic> json) {
    return WelcomeProp(
      welcomeMsg: json['welcomeMsg'],
      welcomeMsgTemplate: json['welcomeMsgTemplate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'welcomeMsg': welcomeMsg,
        'welcomeMsgTemplate': welcomeMsgTemplate,
      };
}
