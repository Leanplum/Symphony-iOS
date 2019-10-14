//
//  LPConstants.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 4/25/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPConstants.h"

@implementation LPConstants


@end

#pragma mark - The rest of the Leanplum constants

#ifdef PACKAGE_IDENTIFIER
NSString *LEANPLUM_PACKAGE_IDENTIFIER = @MACRO_VALUE(PACKAGE_IDENTIFIER);
#else
NSString *LEANPLUM_PACKAGE_IDENTIFIER = @"s";
#endif

NSString *LEANPLUM_DEFAULTS_COUNT_KEY = @"__leanplum_unsynced";
NSString *LEANPLUM_DEFAULTS_ITEM_KEY = @"__leanplum_unsynced_%d";
NSString *LEANPLUM_DEFAULTS_VARIABLES_KEY = @"__leanplum_variables";
NSString *LEANPLUM_DEFAULTS_ATTRIBUTES_KEY = @"__leanplum_attributes";
NSString *LEANPLUM_DEFAULTS_MESSAGES_KEY = @"__leanplum_messages";
NSString *LEANPLUM_DEFAULTS_UPDATE_RULES_KEY = @"__leanplum_interface_rules";
NSString *LEANPLUM_DEFAULTS_EVENT_RULES_KEY = @"__leanplum_interface_events";
NSString *LEANPLUM_DEFAULTS_TOKEN_KEY = @"__leanplum_token";
NSString *LEANPLUM_DEFAULTS_MESSAGE_TRIGGER_OCCURRENCES_KEY = @"__leanplum_message_trigger_occurrences_%@";
NSString *LEANPLUM_DEFAULTS_MESSAGE_IMPRESSION_OCCURRENCES_KEY = @"__leanplum_message_occurrences_%@";
NSString *LEANPLUM_DEFAULTS_MESSAGE_MUTED_KEY = @"__leanplum_message_muted_%@";
NSString *LEANPLUM_DEFAULTS_PUSH_TOKEN_KEY = @"__leanplum_push_token_%@-%@-%@";
NSString *LEANPLUM_DEFAULTS_USER_NOTIFICATION_SETTINGS_KEY = @"__leanplum_user_notification_%@-%@-%@";
NSString *LEANPLUM_DEFAULTS_REGION_STATE_KEY = @"__leanplum_region_state";
NSString *LEANPLUM_DEFAULTS_PRE_LEANPLUM_INSTALL_KEY = @"__leanplum_pre_leanplum_install";
NSString *LEANPLUM_DEFAULTS_SDK_VERSION = @"__leanplum_version";
NSString *LEANPLUM_DEFAULTS_INBOX_KEY = @"__leanplum_newsfeed";
NSString *LEANPLUM_DEFAULTS_APP_VERSION_KEY = @"leanplum_savedAppVersionKey";
NSString *LEANPLUM_DEFAULTS_UUID_KEY = @"__leanplum_uuid";

NSString *LEANPLUM_SQLITE_NAME = @"__leanplum.sqlite";

NSString *LP_METHOD_GET_VARS = @"getVars";
NSString *LP_METHOD_MULTI = @"multi";
NSString *LP_METHOD_UPLOAD_FILE = @"uploadFile";
NSString *LP_METHOD_LOG = @"log";

NSString *LP_PARAM_ACTION = @"action";
NSString *LP_PARAM_ACTION_DEFINITIONS = @"actionDefinitions";
NSString *LP_PARAM_APP_ID = @"appId";
NSString *LP_PARAM_API_VERSION = @"apiVersion";
NSString *LP_PARAM_CLIENT = @"client";
NSString *LP_PARAM_CLIENT_KEY = @"clientKey";
NSString *LP_PARAM_DATA = @"data";
NSString *LP_PARAM_COUNT = @"count";
NSString *LP_PARAM_DEV_MODE = @"devMode";
NSString *LP_PARAM_DEVICE_MODEL = @"deviceModel";
NSString *LP_PARAM_DEVICE_NAME = @"deviceName";
NSString *LP_PARAM_DEVICE_SYSTEM_NAME = @"systemName";
NSString *LP_PARAM_DEVICE_SYSTEM_VERSION = @"systemVersion";
NSString *LP_PARAM_EMAIL = @"email";
NSString *LP_PARAM_EVENT = @"event";
NSString *LP_PARAM_FILE = @"file";
NSString *LP_PARAM_FILES_PATTERN = @"file%d";
NSString *LP_PARAM_FILE_ATTRIBUTES = @"fileAttributes";
NSString *LP_PARAM_INCLUDE_DEFAULTS = @"includeDefaults";
NSString *LP_PARAM_INCLUDE_MESSAGE_ID = @"includeMessageId";
NSString *LP_PARAM_INCLUDE_VARIANT_DEBUG_INFO = @"includeVariantDebugInfo";
NSString *LP_PARAM_INFO = @"info";
NSString *LP_PARAM_INSTALL_DATE = @"installDate";
NSString *LP_PARAM_KINDS = @"kinds";
NSString *LP_PARAM_NEW_USER_ID = @"newUserId";
NSString *LP_PARAM_DEVICE_PUSH_TOKEN = @"iosPushToken";
NSString *LP_PARAM_DEVICE_USER_NOTIFICATION_TYPES = @"iosPushTypes";
NSString *LP_PARAM_DEVICE_USER_NOTIFICATION_CATEGORIES = @"iosPushCategories";
NSString *LP_PARAM_SDK_VERSION = @"sdkVersion";
NSString *LP_PARAM_STATE = @"state";
NSString *LP_PARAM_TIME = @"time";
NSString *LP_PARAM_TYPE = @"type";
NSString *LP_PARAM_DEVICE_ID = @"deviceId";
NSString *LP_PARAM_UPDATE_DATE = @"updateDate";
NSString *LP_PARAM_USER_ID = @"userId";
NSString *LP_PARAM_USER_ATTRIBUTES = @"userAttributes";
NSString *LP_PARAM_REQUEST_ID = @"reqId";
NSString *LP_PARAM_TRAFFIC_SOURCE = @"trafficSource";
NSString *LP_PARAM_VALUE = @"value";
NSString *LP_PARAM_VARS = @"vars";
NSString *LP_PARAM_VERSION_CODE = @"versionCode";
NSString *LP_PARAM_VERSION_NAME = @"versionName";
NSString *LP_PARAM_TOKEN = @"token";
NSString *LP_PARAM_PARAMS = @"params";
NSString *LP_PARAM_LIMIT_TRACKING = @"limitTracking";
NSString *LP_PARAM_NAME = @"name";
NSString *LP_PARAM_MESSAGE = @"message";
NSString *LP_PARAM_MESSAGE_ID = @"messageId";
NSString *LP_PARAM_BACKGROUND = @"background";
NSString *LP_PARAM_INBOX_MESSAGES = @"newsfeedMessages";
NSString *LP_PARAM_INBOX_MESSAGE_ID = @"newsfeedMessageId";
NSString *LP_PARAM_RICH_PUSH_ENABLED = @"richPushEnabled";
NSString *LP_PARAM_UUID = @"uuid";
NSString *LP_PARAM_CURRENCY_CODE = @"currencyCode";

NSString *LP_KEY_REASON = @"reason";
NSString *LP_KEY_STACK_TRACE = @"stackTrace";
NSString *LP_KEY_USER_INFO = @"userInfo";
NSString *LP_KEY_VARS = @"vars";
NSString *LP_KEY_MESSAGES = @"messages";
NSString *LP_KEY_UPDATE_RULES = @"interfaceRules";
NSString *LP_KEY_EVENT_RULES = @"interfaceEvents";
NSString *LP_KEY_VARS_FROM_CODE = @"varsFromCode";
NSString *LP_KEY_IS_REGISTERED = @"isRegistered";
NSString *LP_KEY_IS_REGISTERED_FROM_OTHER_APP = @"isRegisteredFromOtherApp";
NSString *LP_KEY_LATEST_VERSION = @"latestVersion";
NSString *LP_KEY_SIZE = @"size";
NSString *LP_KEY_HASH = @"hash";
NSString *LP_KEY_FILENAME = @"filename";
NSString *LP_KEY_LOCALE = @"locale";
NSString *LP_KEY_COUNTRY = @"country";
NSString *LP_KEY_TIMEZONE = @"timezone";
NSString *LP_KEY_TIMEZONE_OFFSET_SECONDS = @"timezoneOffsetSeconds";
NSString *LP_KEY_REGION = @"region";
NSString *LP_KEY_CITY = @"city";
NSString *LP_KEY_LOCATION = @"location";
NSString *LP_KEY_LOCATION_ACCURACY_TYPE = @"locationAccuracyType";
NSString *LP_KEY_TOKEN = @"token";
NSString *LP_KEY_PUSH_MESSAGE_ID = @"_lpm";
NSString *LP_KEY_PUSH_MUTE_IN_APP = @"_lpu";
NSString *LP_KEY_PUSH_NO_ACTION = @"_lpn";
NSString *LP_KEY_PUSH_NO_ACTION_MUTE = @"_lpv";
NSString *LP_KEY_PUSH_ACTION = @"_lpx";
NSString *LP_KEY_PUSH_CUSTOM_ACTIONS = @"_lpc";
NSString *LP_KEY_REGIONS = @"regions";
NSString *LP_KEY_FILE_ATTRIBUTES = @"fileAttributes";
NSString *LP_KEY_UPLOAD_URL = @"uploadUrl";
NSString *LP_KEY_VARIANTS = @"variants";
NSString *LP_KEY_VARIANT_DEBUG_INFO = @"variantDebugInfo";
NSString *LP_KEY_ENABLED_COUNTERS = @"enabledSdkCounters";
NSString *LP_KEY_ENABLED_FEATURE_FLAGS = @"enabledFeatureFlags";
NSString *LP_KEY_INBOX_MESSAGES = @"newsfeedMessages";
NSString *LP_KEY_UNREAD_COUNT = @"unreadCount";
NSString *LP_KEY_SYNC_INBOX = @"syncNewsfeed";
NSString *LP_KEY_LOGGING_ENABLED = @"loggingEnabled";
NSString *LP_KEY_MESSAGE_DATA = @"messageData";
NSString *LP_KEY_IS_READ = @"isRead";
NSString *LP_KEY_DELIVERY_TIMESTAMP = @"deliveryTimestamp";
NSString *LP_KEY_EXPIRATION_TIMESTAMP = @"expirationTimestamp";
NSString *LP_KEY_TITLE = @"Title";
NSString *LP_KEY_SUBTITLE = @"Subtitle";
NSString *LP_KEY_IMAGE = @"Image";
NSString *LP_KEY_DATA = @"Data";

NSString *LP_EVENT_EXCEPTION = @"__exception";

NSString *LP_HELD_BACK_EVENT_NAME = @"Held Back";
NSString *LP_HELD_BACK_MESSAGE_PREFIX = @"__held_back__";

NSString *LP_KIND_INT = @"integer";
NSString *LP_KIND_FLOAT = @"float";
NSString *LP_KIND_STRING = @"string";
NSString *LP_KIND_BOOLEAN = @"bool";
NSString *LP_KIND_FILE = @"file";
NSString *LP_KIND_DICTIONARY = @"group";
NSString *LP_KIND_ARRAY = @"list";
NSString *LP_KIND_ACTION = @"action";
NSString *LP_KIND_COLOR = @"color";

NSString *LP_VALUE_DETECT = @"(detect)";
NSString *LP_VALUE_ACTION_PREFIX = @"__action__";
NSString *LP_VALUE_RESOURCES_VARIABLE = @"__Resources";
NSString *LP_VALUE_ACTION_ARG = @"__name__";
NSString *LP_VALUE_CHAIN_MESSAGE_ARG = @"Chained message";
NSString *LP_VALUE_CHAIN_MESSAGE_ACTION_NAME = @"Chain to Existing Message";
NSString *LP_VALUE_DEFAULT_PUSH_ACTION = @"Open action";
NSString *LP_VALUE_DEFAULT_PUSH_MESSAGE = @"Push message goes here.";
NSString *LP_VALUE_SDK_LOG = @"sdkLog";
NSString *LP_VALUE_SDK_COUNT = @"sdkCount";
NSString *LP_VALUE_SDK_ERROR = @"sdkError";
NSString *LP_VALUE_SDK_START_LATENCY = @"sdkStartLatency";

NSString *LP_KEYCHAIN_SERVICE_NAME = @"com.leanplum.storage";
NSString *LP_KEYCHAIN_USERNAME = @"defaultUser";

NSString *LP_PATH_DOCUMENTS = @"Leanplum_Resources";
NSString *LP_PATH_BUNDLE = @"Leanplum_Bundle";
NSString *LP_SWIZZLING_ENABLED = @"LeanplumSwizzlingEnabled";

NSString *LP_APP_ICON_NAME = @"__iOSAppIcon";
NSString *LP_APP_ICON_FILE_PREFIX = @"__iOSAppIcon-";
NSString *LP_APP_ICON_PRIMARY_NAME = @"PrimaryIcon";

NSString *LP_INVALID_IDFA = @"00000000-0000-0000-0000-000000000000";

NSString *LP_NOTIFICATION_LOCATION_UPDATE = @"updateLocationForUser";
