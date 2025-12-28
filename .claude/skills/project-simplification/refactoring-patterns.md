# Common Refactoring Patterns

## Large Service Files

**Before**:
```
lib/services/user_service.dart (600 lines)
  - Authentication
  - Profile management
  - Settings
  - Preferences
```

**After**:
```
lib/services/
├── auth_service.dart (150 lines)
├── profile_service.dart (150 lines)
├── settings_service.dart (150 lines)
└── service_locator.dart (50 lines)
```

## Large Widget Files

**Before**:
```
lib/pages/home_page.dart (500 lines)
  - Build main layout
  - Build header widget
  - Build content widget
  - Build footer widget
```

**After**:
```
lib/pages/home/
├── home_page.dart (100 lines) - Main layout
├── home_header.dart (100 lines) - Header
├── home_content.dart (150 lines) - Content
└── home_footer.dart (80 lines) - Footer
```

## Large Model Files

**Before**:
```
lib/models/user.dart (400 lines)
  - User class
  - JSON serialization
  - Validation logic
  - Display formatting
```

**After**:
```
lib/models/
├── user.dart (100 lines) - Data class
├── user_serializable.dart (100 lines) - Serialization
├── user_validator.dart (100 lines) - Validation
└── user_display.dart (80 lines) - Formatting
```

## Extract Constants

**Before**:
```dart
static const String API_BASE_URL = 'https://api.example.com';
static const int REQUEST_TIMEOUT = 30;
```

**After**:
```
lib/config/
├── api_config.dart
├── app_constants.dart
└── theme_config.dart
```

## Extract Utilities

**Before**: Utility methods scattered across files

**After**:
```
lib/utils/
├── string_utils.dart
├── date_utils.dart
├── validation_utils.dart
└── format_utils.dart
```
