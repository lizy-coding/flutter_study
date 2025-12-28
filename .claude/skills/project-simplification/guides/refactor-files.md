# Refactor Large Files

Break up oversized files into more maintainable, focused components following the Single Responsibility Principle.

## What This Does

Identifies and helps refactor files that are too large (recommended threshold: >500 lines):
- Finds large files in your project
- Suggests extraction strategies
- Helps split into logical components
- Updates imports and references
- Maintains functionality while improving structure

## Quick Start

```bash
python .claude/skills/project-simplification/scripts/find_large_files.py
```

**Recommended Threshold**: Files over 500 lines should be considered for refactoring.

## Custom Threshold

Adjust the line count threshold:

```bash
FILE_SIZE_THRESHOLD=400 python .claude/skills/project-simplification/scripts/find_large_files.py
```

## Manual Search

Find large files manually:

```bash
# Find Dart files and count lines, show top 20
find lib/ -name "*.dart" -exec wc -l {} + | sort -rn | head -20

# Find files over 500 lines
find lib/ -name "*.dart" -exec wc -l {} + | awk '$1 > 500'
```

## Refactoring Process

For each file identified for refactoring:

### 1. Analyze Responsibilities

- Read the entire file carefully
- Identify distinct logical components
- Note dependencies between components
- Check if file violates Single Responsibility Principle
- List what the file is trying to do

### 2. Identify Logical Components

Common patterns to extract:

- **Models/Data Classes**: Business objects, DTOs, data structures
- **Services**: Business logic, external API integrations
- **Widgets**: UI components, custom widgets
- **Controllers/State**: State management, business logic controllers
- **Utilities/Helpers**: Pure functions, formatting, calculations
- **Constants**: Configuration values, enums, constant data

### 3. Plan Extraction

Decide how to split:

- Which components to extract first
- New file names and locations
- How to maintain existing imports
- What needs to remain in original file
- Order of extraction (least to most coupled)

### 4. Extract to Separate Files

Follow these principles:

#### Single Responsibility Principle
Each file should have one clear, well-defined purpose.

#### Clear Module Boundaries
Related files should be grouped together:

```
lib/
  feature_name/
    models/
      user.dart
      post.dart
      comment.dart
    services/
      api_service.dart
      cache_service.dart
    widgets/
      user_list.dart
      user_card.dart
    controllers/
      user_controller.dart
```

#### Consistent Naming Patterns
- **Models**: `user_model.dart` or `user.dart`
- **Services**: `api_service.dart`, `auth_service.dart`
- **Widgets**: `user_card.dart`, `post_list.dart`
- **Controllers**: `user_controller.dart`, `auth_controller.dart`
- **Utilities**: `date_utils.dart`, `string_helpers.dart`

### 5. Update Imports

After extraction:

```bash
# Find all files importing the refactored file
grep -r "import.*old_file.dart" lib/

# Update each import statement
# Add new imports for extracted files
```

### 6. Verify Functionality

Ensure nothing broke:

```bash
# Run static analysis
flutter analyze

# Run tests
flutter test

# Run app
flutter run

# Test affected features manually
```

## Refactoring Strategies by File Type

### Large State Classes (800+ lines)

**Before**:
```dart
// user_page.dart (800 lines)
class UserPageState {
  // Models (200 lines)
  // API calls (200 lines)
  // Business logic (200 lines)
  // UI helpers (200 lines)
}
```

**After**:
```
lib/user/
  models/
    user_model.dart           # 50 lines
    user_profile.dart         # 50 lines
  services/
    user_service.dart         # 150 lines
  controllers/
    user_controller.dart      # 200 lines
  widgets/
    user_page.dart            # 150 lines (UI only)
    user_profile_card.dart    # 100 lines
```

**Strategy**:
1. Extract models first (no dependencies)
2. Extract services (depend on models)
3. Extract controller (depends on services, models)
4. Keep UI in original file, now much smaller

### Large Widgets (600+ lines)

**Before**:
```dart
// dashboard.dart (600 lines)
class DashboardPage extends StatelessWidget {
  // All sub-widgets defined inline
  // Complex build method
  // Helper methods
}
```

**After**:
```
lib/dashboard/
  widgets/
    dashboard_page.dart       # 100 lines (main layout)
    dashboard_header.dart     # 80 lines
    dashboard_stats.dart      # 100 lines
    dashboard_chart.dart      # 120 lines
    dashboard_actions.dart    # 90 lines
  dashboard_view.dart         # 110 lines (barrel/组合)
```

**Strategy**:
1. Identify logical UI sections
2. Extract each section to widget file
3. Keep main page as composition/layout only
4. Create barrel file if needed

### Large Services (700+ lines)

**Before**:
```dart
// api_service.dart (700 lines)
class ApiService {
  // User endpoints (200 lines)
  // Post endpoints (200 lines)
  // Comment endpoints (150 lines)
  // Auth endpoints (150 lines)
}
```

**After**:
```
lib/services/api/
  base_api_service.dart       # 100 lines (shared logic)
  user_api_service.dart       # 200 lines
  post_api_service.dart       # 200 lines
  comment_api_service.dart    # 150 lines
  auth_api_service.dart       # 150 lines
```

**Strategy**:
1. Extract common/shared logic to base class
2. Split by domain/resource type
3. Each service extends base class
4. Update dependency injection

### Large Models (500+ lines)

**Before**:
```dart
// user.dart (500 lines)
class User {
  // Properties (50 lines)
  // Serialization (150 lines)
  // Validation (150 lines)
  // Display logic (150 lines)
}
```

**After**:
```
lib/models/user/
  user.dart                   # 80 lines (core model)
  user_serializer.dart        # 150 lines
  user_validator.dart         # 150 lines
  user_extensions.dart        # 120 lines (display helpers)
```

**Strategy**:
1. Keep core data model minimal
2. Extract serialization logic
3. Extract validation to separate class
4. Use extensions for display/computed properties

## Complete Refactoring Example

### Original File (600 lines)

```dart
// lib/features/chat/chat_page.dart (600 lines)
import 'package:flutter/material.dart';

// Models (100 lines)
class Message { /* ... */ }
class User { /* ... */ }
class ChatRoom { /* ... */ }

// Service (200 lines)
class ChatService { /* ... */ }

// State Management (150 lines)
class ChatController extends ChangeNotifier { /* ... */ }

// UI Components (150 lines)
class ChatPage extends StatelessWidget { /* ... */ }
class MessageBubble extends StatelessWidget { /* ... */ }
class ChatInput extends StatefulWidget { /* ... */ }
```

### Refactored Structure

```
lib/features/chat/
  models/
    message.dart              # 40 lines
    user.dart                 # 30 lines
    chat_room.dart            # 30 lines
  services/
    chat_service.dart         # 200 lines
  controllers/
    chat_controller.dart      # 150 lines
  widgets/
    chat_page.dart            # 60 lines
    message_bubble.dart       # 50 lines
    chat_input.dart           # 40 lines
```

### Updated Imports

```dart
// lib/features/chat/widgets/chat_page.dart
import '../models/message.dart';
import '../models/user.dart';
import '../models/chat_room.dart';
import '../services/chat_service.dart';
import '../controllers/chat_controller.dart';
import 'message_bubble.dart';
import 'chat_input.dart';

class ChatPage extends StatelessWidget {
  // Now only 60 lines of UI code
}
```

## Best Practices

### Before Refactoring

1. **Commit Current State**:
   ```bash
   git add .
   git commit -m "checkpoint: before refactoring [filename]"
   ```

2. **Run Tests**: Ensure all tests pass
3. **Document Plan**: Write down refactoring approach
4. **Backup**: Keep copy of original file temporarily

### During Refactoring

1. **Extract Incrementally**: One component at a time
2. **Test After Each Step**: Verify nothing broke
3. **Update Imports Immediately**: Fix imports right away
4. **Keep Git History Clean**: Make atomic, logical commits
5. **Don't Change Logic**: Only move code, don't modify behavior

### After Refactoring

1. **Run Full Test Suite**: `flutter test`
2. **Check Code Quality**: `flutter analyze`
3. **Verify App Functionality**: `flutter run` + manual testing
4. **Update Documentation**: If needed
5. **Code Review**: Have teammate review changes
6. **Clean Up**: Remove old backup files

## Validation Checklist

After refactoring:

- [ ] All files under 500 lines (or your threshold)
- [ ] Each file has single, clear purpose
- [ ] All imports updated correctly
- [ ] `flutter analyze` passes with no new issues
- [ ] All tests pass
- [ ] App builds successfully
- [ ] App runs without errors
- [ ] No functionality changed (behavior identical)
- [ ] Code is more readable and maintainable
- [ ] Git history is clean and descriptive

## Common Pitfalls

### Over-Splitting
- **Problem**: Creating too many tiny files (20-30 lines each)
- **Solution**: Balance between file size and navigability
- **Guideline**: 50-500 lines is usually good range

### Breaking Dependencies
- **Problem**: Creating circular dependencies after split
- **Solution**: Use dependency injection, interfaces, or inversion
- **Tool**: Check with `dart analyze` for circular imports

### Losing Context
- **Problem**: Related code spread too far apart
- **Solution**: Keep related files in same directory
- **Organization**: Use clear directory structure

### Import Hell
- **Problem**: Files with 20+ import statements
- **Solution**: Use barrel files (`index.dart`) for grouping
- **Alternative**: Reconsider component boundaries

### Not Testing
- **Problem**: Refactoring without testing each change
- **Solution**: Test incrementally, automate if possible
- **Practice**: Write tests first if they don't exist

## Creating Barrel Files

For cleaner imports, create `index.dart` files:

```dart
// lib/features/chat/models/index.dart
export 'message.dart';
export 'user.dart';
export 'chat_room.dart';

// Now can import all models with:
// import '../models/index.dart';
```

**When to use**:
- Grouping related exports (models, widgets)
- Simplifying complex import statements
- Creating public API for a package

**When NOT to use**:
- Small groups (2-3 files) - direct imports are fine
- When it hides important dependencies

## Automated Refactoring Tools

Consider using:

- **IDE Refactoring**: Extract method, extract class (VS Code, IntelliJ)
- **dartfmt**: Format code consistently
- **dart fix**: Apply automated fixes
- **dart analyze**: Find issues before they become problems

## Next Steps

After refactoring large files:

1. **Commit changes**:
   ```bash
   git add .
   git commit -m "refactor: break up large [feature] files"
   ```

2. **Choose next action**:
   - Continue to [Generate Documentation](generate-docs.md)
   - Or go to [Complete Workflow](complete-workflow.md)

3. **Share patterns**: Document refactoring patterns for team
4. **Update architecture docs**: If project structure changed significantly
