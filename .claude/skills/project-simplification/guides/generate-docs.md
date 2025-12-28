# Generate Documentation

Automatically generate comprehensive README files for all modules and the project root.

## What This Does

Creates well-structured documentation by:
- Analyzing all modules in `lib/` directory
- Extracting descriptions from code comments
- Identifying pages, widgets, models, services
- Counting files and lines of code
- Detecting dependencies
- Generating README files for each module
- Creating comprehensive root README

## Quick Start

### Generate All Documentation

```bash
python scripts/generate_module_descriptions.py && \
python scripts/generate_module_readmes.py && \
python scripts/generate_root_readme.py
```

This runs all three steps in sequence.

## Three-Step Process

### Step 1: Generate Module Descriptions

Analyze all modules and extract information:

```bash
python scripts/generate_module_descriptions.py
```

**What it does**:
- Scans all modules in `lib/` directory
- Extracts descriptions from comments
- Identifies pages, widgets, models, services
- Counts files and lines of code
- Detects dependencies between modules
- Generates `module_descriptions.json`

**Output**: `module_descriptions.json` containing metadata for all modules

### Step 2: Generate Module READMEs

Create individual README for each module:

```bash
python scripts/generate_module_readmes.py
```

**What it creates**:
Each module gets a `README.md` including:
- Module overview and description
- Feature list
- Project structure tree
- Main files description
- Usage examples
- Code samples
- Tech stack
- File statistics
- Dependencies
- Test information

**Output**: `lib/<module_name>/README.md` for each module

### Step 3: Generate Root README

Create comprehensive project README:

```bash
python scripts/generate_root_readme.py
```

**What it creates**:
Root `README.md` including:
- Project overview and statistics
- Complete module list with links
- Module categorization (UI/Async/Arch/Network/etc.)
- Learning paths (beginner/advanced)
- Quick start guide
- Project structure
- Tech stack
- Development tools
- Contributing guide
- License information

**Output**: `README.md` at project root

## What Gets Included in READMEs

### Module README Structure

```markdown
# Module Name

## Overview
[Description extracted from code or module_descriptions.json]

## Features
- Feature 1
- Feature 2
- Feature 3

## Project Structure
```
module_name/
├── models/
├── services/
├── widgets/
└── pages/
```

## Main Files
- `file1.dart` - Description
- `file2.dart` - Description

## Usage
[Usage examples if available]

## Code Example
```dart
// Example code
```

## Tech Stack
- Dependencies used
- Flutter version

## Statistics
- Files: X
- Lines of code: Y

## Dependencies
- Other modules used
- External packages

## Tests
- Test files: X
- Test coverage: Y%
```

### Root README Structure

```markdown
# Project Name

## Overview
[Project description]

## Statistics
- Total Modules: X
- Total Files: Y
- Lines of Code: Z

## Modules

### UI Components
- [Module 1](lib/module1/) - Description
- [Module 2](lib/module2/) - Description

### Async & Concurrency
- [Module 3](lib/module3/) - Description

### Architecture & Patterns
- [Module 4](lib/module4/) - Description

## Learning Paths

### Beginner Path
1. Start with [Module A]
2. Then explore [Module B]

### Advanced Path
1. Study [Module C]
2. Deep dive into [Module D]

## Quick Start
[Installation and setup instructions]

## Project Structure
[Overall project layout]

## Tech Stack
- Flutter
- Dart
- Key packages

## Development
[Development setup instructions]

## Contributing
[Contribution guidelines]

## License
[License information]
```

## Customizing Generated Documentation

### Adding Custom Descriptions

Add comments to your module entry files (e.g., `lib/my_module/my_module.dart`):

```dart
/// # My Amazing Module
///
/// This module demonstrates advanced Flutter patterns including:
/// - State management with Provider
/// - Custom animations
/// - API integration
///
/// ## Key Features
/// - Feature A: Does X
/// - Feature B: Does Y
///
/// ## Usage
/// ```dart
/// MyModule().init();
/// ```
library my_module;
```

The generator will extract this and use it in the README.

### Enhancing Generated Content

After generation, you can manually enhance:

1. **Add screenshots/GIFs**: Visual examples improve understanding
2. **Add detailed examples**: Show real-world usage
3. **Add architecture diagrams**: Explain complex interactions
4. **Add troubleshooting**: Common issues and solutions
5. **Add FAQ**: Frequently asked questions

### Module Categories

The root README categorizes modules automatically. Common categories:

- **UI Components**: Widgets, custom UI elements
- **Async & Concurrency**: Streams, Isolates, async patterns
- **Architecture & Patterns**: State management, design patterns
- **Network**: API clients, HTTP interceptors
- **Storage & Data**: Local storage, caching
- **Utilities**: Helpers, extensions, utils
- **Animation**: Custom animations, transitions
- **Testing**: Test utilities, mocks

## Documentation Best Practices

### 1. Regular Updates

Regenerate after significant changes:

```bash
# After adding new modules
python scripts/generate_module_descriptions.py && \
python scripts/generate_module_readmes.py && \
python scripts/generate_root_readme.py
```

### 2. Manual Review

Always review generated content:
- Check for accuracy
- Fix any extraction errors
- Add missing context
- Improve examples

### 3. Custom Descriptions

Add detailed comments in module entry files:
- Explain module purpose
- List key features
- Provide usage examples
- Note important considerations

### 4. Code Examples

Enhance with practical examples:
- Show common use cases
- Include setup steps
- Add error handling
- Demonstrate best practices

### 5. Keep Links Valid

Verify all internal links work:

```bash
# Check for broken links
grep -r "\[.*\](.*))" README.md lib/*/README.md
```

### 6. Update Screenshots

Keep visual content current:
- Update when UI changes
- Show latest features
- Use consistent style

### 7. Version Documentation

Track documentation versions:
- Update version numbers
- Note breaking changes
- Link to changelog

## Configuration Options

### Custom Output Paths

Set environment variables:

```bash
# Custom descriptions file path
DESCRIPTIONS_FILE=custom_path.json python scripts/generate_module_descriptions.py

# Custom README template
TEMPLATE_PATH=custom_template.md python scripts/generate_module_readmes.py
```

### Include/Exclude Modules

```bash
# Only process specific modules
MODULES="module1,module2" python scripts/generate_module_descriptions.py

# Exclude certain modules
EXCLUDE="test_module,old_module" python scripts/generate_module_descriptions.py
```

## Troubleshooting

### No Descriptions Extracted

**Problem**: Module descriptions are empty or generic

**Solutions**:
- Add doc comments to module entry files
- Use `///` (three slashes) for documentation comments
- Follow Dart documentation conventions

### Broken Links in Generated READMEs

**Problem**: Links don't work

**Solutions**:
- Use relative paths
- Check file structure matches links
- Regenerate after moving files

### Missing Modules

**Problem**: Some modules not included

**Solutions**:
- Ensure module has proper structure
- Check module has entry file
- Verify module not in exclude list

### Formatting Issues

**Problem**: Generated markdown looks wrong

**Solutions**:
- Check template files
- Verify JSON structure
- Update generator script

## Integration with CI/CD

Add to your CI pipeline:

```yaml
# .github/workflows/docs.yml
name: Generate Documentation

on:
  push:
    branches: [main]
    paths:
      - 'lib/**'

jobs:
  generate-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Generate docs
        run: |
          python scripts/generate_module_descriptions.py
          python scripts/generate_module_readmes.py
          python scripts/generate_root_readme.py
      - name: Commit docs
        run: |
          git config user.name "Documentation Bot"
          git config user.email "bot@example.com"
          git add README.md lib/*/README.md
          git commit -m "docs: auto-generate documentation" || true
          git push
```

## Next Steps

After generating documentation:

1. **Review and enhance**: Check generated content for accuracy
2. **Add visuals**: Include screenshots, diagrams
3. **Commit changes**:
   ```bash
   git add README.md lib/*/README.md
   git commit -m "docs: generate module documentation"
   ```

4. **Choose next action**:
   - Continue to [Validate Project](validate.md)
   - Or go to [Complete Workflow](complete-workflow.md)

## Additional Resources

For more details, see [readme-generation.md](../readme-generation.md) (if it exists).
