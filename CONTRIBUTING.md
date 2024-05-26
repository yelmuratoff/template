
## Git, Git Flow
**Feature:**

1. **Starting a new feature.**  
Create a new `feature/future_name` branch from `develop`.

2. **Finalizing the feature.**  
Merge `feature/future_name` into `develop`, delete `feature/future_name`.

3. **Starting a release.**  
Create a release branch release/vX.X.X, branching off the develop branch.

4. **Release completion.**  
Release branch `release/vX.X.X` is merged into `master`, release is tagged, release branch is merged into `develop`, release branch is deleted.

**Fix:**

1. **Start fixing.**  
From the `master` branch create `hotfix/fix_name`.

2. **Finalization of the hotfix.**  
The `hotfix/fix_name` branch is merged into `develop` and `master`, the fix branch is deleted.

## Arlo's Commit Notation Cheat Sheet

### Risk Categories
| Symbol | Risk Description                     |
|--------|--------------------------------------|
| .      | Provable (changes are easy to verify)|
| -      | Tested (changes have been tested)    |
| !      | Single Action (single, atomic change)|
| @      | Other (miscellaneous changes)        |

### Action Categories
| Symbol | Action Description                       |
|--------|------------------------------------------|
| r      | Refactoring (improving code structure)   |
| e      | Environment (non-code changes)           |
| d      | Documentation (changes to documentation) |
| t      | Test only (changes to tests)             |
| F      | Feature (new features)                   |
| B      | Bugfix (fixing bugs)                     |

### Examples
- `.r rename variable`: Provable refactoring change, such as renaming a variable.
- `-e update build script`: Tested change to the environment, such as updating a build script.
- `!B fixed spelling on label`: Single action bugfix, like fixing a spelling error on a label.
- `@d update README`: Miscellaneous documentation change, like updating the README file.

### Commit Message Guidelines
- Always use the appropriate risk and action symbols to describe the change.
- Provide a concise description of the change after the symbols.

### Example Commit Messages
- `.r rename variable`: This commit renames a variable, which is a provable refactoring change.
- `-e update build script`: This commit updates a build script, indicating a tested environment change.
- `!B fixed spelling on label`: This commit fixes a spelling error on a label, a single action bugfix.
- `@d update README`: This commit updates the README file, categorized as other documentation change.

By using this notation, you can clearly and concisely describe the nature and risk of your changes in commit messages.

Summary of the Arlo's Commit Notation:

<img src="https://github.com/K1yoshiSho/packages_assets/blob/main/assets/approval_tests/arlo_git_notation.png?raw=true" alt="CommandLineComparator img" title="ApprovalTests" style="max-width: 500px;">
