
### 1. TESTING.md
markdown
# Test Cases for User Management Script

## 🧪 Unit Tests

### User Creation
bash
# Test valid user creation
test_create_valid_user() {
  output=$(sudo ./user_management.sh <<< $'1\ntestuser1\nValid@Pass123\ny\nsudo\ny\nn')
  assertContains "$output" "User 'testuser1' created"
}

# Test duplicate user
test_duplicate_user() {
  sudo ./user_management.sh <<< $'1\ntestuser2\nPass@123\nn\nn\nn'
  output=$(sudo ./user_management.sh <<< $'1\ntestuser2\nPass@123\nn\nn\nn')
  assertContains "$output" "already exists"
}

### Password Validation
bash
# Test weak password
test_weak_password() {
  output=$(sudo ./user_management.sh <<< $'1\ntestuser3\nweak\nn\nn\nn')
  assertContains "$output" "must contain at least"
}

## 🖥️ Integration Tests

| Test Case | Command | Expected Result |
|-----------|---------|-----------------|
| Lock user | `5 → testuser1` | "has been locked" |
| Unlock user | `6 → testuser1` | "has been unlocked" |
| List users | `3` | Shows testuser1 |

## 🧹 Cleanup
bash
# Remove test users
sudo userdel -r testuser1
sudo userdel -r testuser2
