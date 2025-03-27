# Contributing to Advanced User Management Script

We welcome contributions from the community! Here's how you can help improve this project.

## 📋 Contribution Guidelines

### 🐛 Reporting Bugs
1. Check existing issues to avoid duplicates
2. Use this bug report format:
markdown
**Description**:  
**Steps to Reproduce**:  
**Expected Behavior**:  
**Actual Behavior**:  
**Environment**:  
- OS: [e.g., Ubuntu 22.04]
- Bash Version: [e.g., 5.1.16]

### 💡 Feature Requests
1. Start with `[Feature]` in issue title
2. Describe:
   - Use case
   - Proposed implementation
   - Potential impact

### 🛠 Development Setup
bash
# Fork and clone
git clone https://github.com/YOUR_USERNAME/user_management.git
cd user_management

# Create feature branch
git checkout -b feature/your-feature-name

### 🔧 Coding Standards
- Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Use `shellcheck` for linting
- Keep functions focused (max 50 lines)
- Add comments for complex logic

### ✅ Testing Requirements
Test your changes on:
- Ubuntu 20.04/22.04
- CentOS 7/8
- Different permission levels

### 📦 Dependency Management
Ensure these are available:
- `coreutils` (for basic commands)
- `passwd` (from shadow-utils)
- `grep`, `awk`, `sed`

## 🚀 Pull Request Process
1. Update `CHANGELOG.md` with your changes
2. Ensure tests pass:
bash
# Run basic functionality tests
./test_script.sh
3. Include screenshots for UI changes
4. Reference related issues

## 📊 Test Cases
We particularly need tests for:
1. Edge case usernames (special chars, spaces)
2. Password complexity validation
3. Group management scenarios
4. Lock/unlock functionality

Example test format:
bash
# Test user creation
test_create_user() {
  output=$(./user_management.sh <<< $'1\ntestuser\nP@ssw0rd!\nn\nn\nn')
  assertContains "$output" "User 'testuser' created"
}

## 📜 Documentation Standards
- Update both `README.md` and inline help text
- Use consistent verb tense
- Add examples for new features

## 🏷️ Issue Labels
| Label | Purpose |
|-------|---------|
| `bug` | Defects or unexpected behavior |
| `enhancement` | New features or improvements |
| `security` | Security-related issues |
| `docs` | Documentation updates |

## 💬 Communication
- Use GitHub Discussions for questions
- Be respectful and professional
- Allow 48 hours for maintainer responses

## 🌱 First Time Contributors
Check out these `good first issue` labeled tasks to start!

---

Thank you for helping make this project better! ✨
