# Contributing to Ingestion pipelines

First off, thanks for taking the time to contribute!

Please follow the below guidelines while contributing. For any suggestions or 
improvement, create a pull request as per below process

## How Can I Contribute?

Devops team follows Github project for issue management and tracking. 
Link - https://github.com/orgs/IntelliGrape/projects/1

### Code Contribution

To add your contribution please do a pull request. We follow the fork and 
branch workflow to make contributions to Github.

In a nutshell, the fork and branch workflow is as below:
- [Fork](https://help.github.com/en/articles/fork-a-repo) GitHub repository
- Clone the forked repository to your local system (to be named as `origin`)
  ```bash
  # replace hrmnjt with your Github username
  git clone git@github.com:shivamkh90/terraform-drupal.git
  ```
- Add a Git remote for the original repository (to be named as `upstream`)
  ```bash
  git remote add upstream git@github.com:Intelligrape/terraform-drupal.git
  ```
  - In case the repository was already forked, update the develop branch
    ```bash
    # change current branch to main
    git checkout main
    # Pull latest changes from upstream
    git pull upstream main
    # Push latest changes to origin
    git push origin main
    ```
- Create a feature branch in which to place your changes
  ```bash
  # replace NNN with the Github project issue number
  git checkout -b NNN/small-jira-issue-header
  ```
- Make your changes to the new branch
- Commit the changes to the branch. Make sure that your changes are alinged with [editorial config file](../.editorconfig).
  ```bash
  git commit -am 'NNN(small-jira-issue-header): Adding awesomenss'
  ```
- Push the branch to GitHub
  ```bash
  git push origin NNN/small-jira-issue-header
  ```
- [Create a new pull request](https://help.github.com/en/articles/creating-a-pull-request) 
from the new branch to the original repo to merge 
`origin:NNN/small-jira-issue-header` (right side) on `upstream:develop` 
(left side) while adhering to the checklist and guidelines

- The code need to be tested on dev environment. Once approved by QA, the feature branch will be merged to **`main`** branch.

- In case of any bug in the feature, the developer needs to make the fixes in the feature branch and merge the fixes on dev environment. On QA signoff the feature will be merged into **`main`** branch

### Branches:

**`feature` branch** of your fork would be used for current development on 
local and testing

**`develop` branch** of upstream would be deployed on development environment 
for team to check the development progress

**`main` branch** of upstream would be deployed on production environment with proper tags

### Pull Requests

We need to adhere to checklist below for each pull request. This has also been 
defined in the [pull request template](./pull_request_template.md)

- Title of the PR includes **[NNN] Small description**
- Ensure request is to **pull a `NNN/topic` branch** (right side)
- Ensure pull request is against the **`develop` branch** (left side)
- Ensure Terraform style guide is followed whereever possible
- Check the commit message styles matches our requested structure
- Branch has **latest code pulled from `main`**
- **Assigned** myself to the PR
- Added **labels** to the PR
- Assigned >= 2 people to **reviewers the PR**
- **Documentation** has been written where necessary

## Styleguides

https://www.terraform.io/docs/language/syntax/style.html

## Git Hooks

We use [pre-commit](https://pre-commit.com/) hooks to run :-

- Style checks
- Security Scans
- Code Quality checks before any commit. 

You __have__ to install precommit on your local machine and enable the same on this repo before trying to commit any code.  

### Git Commit Messages
We are following 
[The seven rules of a great Git commit message](https://chris.beams.io/posts/git-commit/#seven-rules) 
by Chris Beams. Please, read them before you start to contribute. Briefly 
they are:

- Separate subject from body with a blank line
- Limit the subject line to 50 characters
- Capitalize the subject line
- Do not end the subject line with a period
- Use the imperative mood in the subject line
- Wrap the body at 72 characters
- Use the body to explain what and why vs. how
