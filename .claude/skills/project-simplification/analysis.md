# Project Structure Analysis

## Overview

This document provides detailed guidance on analyzing Flutter project structures.

## Directory Depth Analysis

Recommended maximum depth:
```
lib/
├── module_name/          # Level 1
│   ├── models/          # Level 2
│   │   └── user.dart    # Level 3 - OK
│   └── ui/
│       └── screens/
│           └── home/
│               └── widgets/  # Level 5+ - Too Deep!
```

Flatten when depth > 4 levels for most files.

## Module Organization

### Good Structure
```
lib/
├── common/              # Shared utilities
├── features/            # Feature modules
│   ├── auth/
│   ├── profile/
│   └── dashboard/
└── core/               # Core infrastructure
    ├── api/
    ├── database/
    └── services/
```

### Issues to Watch

**Circular Dependencies**: Module A imports from B, B imports from A
**Too Many Files**: >30 files in a single directory
**Missing Boundaries**: No clear module interfaces
**Deep Nesting**: Files buried 5+ levels deep
**Unused Code**: Dead code and unused imports

## Metrics

| Metric | Ideal | Warning | Critical |
|--------|-------|---------|----------|
| Files per dir | <20 | 20-30 | >30 |
| Directory depth | <4 | 4-5 | >5 |
| File size (lines) | <300 | 300-500 | >500 |
| Import count | <15 | 15-25 | >25 |
| Class size (lines) | <200 | 200-400 | >400 |
