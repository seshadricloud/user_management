# Contributing to Linux User Management Script

Thank you for considering contributing to this project! We welcome all forms of contributions, from bug reports to feature implementations.

## 🛠 How to Contribute

### 1. Reporting Issues
- Check existing issues to avoid duplicates
- Use the issue template and include:
  markdown
  ### Description
  ### Steps to Reproduce
  ### Expected Behavior
  ### Actual Behavior
  ### System Information
  ```

### 2. Feature Requests
- Open an issue with `[Feature]` prefix
- Describe the use case and proposed solution

### 3. Code Contributions
#### Prerequisites
- Bash 4.0+
- Linux environment (Ubuntu/CentOS recommended)
- Git installed

#### Setup Guide
bash
# Fork and clone the repo
git clone https://github.com/YOUR_USERNAME/user_management.git
cd user_management

# Create a feature branch
git checkout -b feature/your-feature


#### Coding Standards
- Follow Google Shell Style Guide
- Add comments for complex logic
- Keep functions under 50 lines
- Use `local` for function variables

#### Testing Requirements
- Verify changes work on:
  - Ubuntu 20.04+
  - CentOS 7+
- Test edge cases (special chars in usernames, etc.)
- Update documentation if needed

### 4. Pull Request Process
1. Ensure your branch is updated with `main`
2. Include clear description of changes
3. Reference related issues (e.g., "Fixes #123")
4. Wait for CI checks to pass
5. Address review comments if any

## 🏷️ Issue Labels
| Label | Purpose |
|-------|---------|
| `bug` | Unexpected behavior |
| `enhancement` | Feature improvements |
| `security` | Security-related issues |
| `docs` | Documentation updates |

## 💬 Communication
- Use GitHub discussions for questions
- Be respectful and professional
- Allow 2-3 business days for responses

## 🏆 Your First Contribution?
Try these beginner-friendly issues:
- Improve help text formatting
- Add more input validation examples
- Update documentation typos

We value all contributions, big or small!


### Key Features:
1. **Clear Workflow**: Step-by-step contribution process
2. **Quality Standards**: Specific coding/testing requirements
3. **Beginner-Friendly**: Labeled good first issues
4. **Professional Tone**: Encourages respectful collaboration

### Recommended Files to Add:
1. `.github/ISSUE_TEMPLATE.md` (for standardized issue reporting)
2. `.github/PULL_REQUEST_TEMPLATE.md` (for PR consistency)
3. `TESTING.md` (detailed test cases)
