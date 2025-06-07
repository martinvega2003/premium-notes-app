# Contributing to Premium Notes App

## Workflow

1. Create a branch from `develop`:
   ```
   bash
   git checkout develop
   git checkout -b feature/<US-XX>-short-description
   ```

3. Work on your feature or fix, making **atomic commits** following Conventional Commits.

4. Push your branch to the remote:

    ```
    bash
    git push -u origin feature/<US-XX>-short-description
    ```

5. Open a Pull Request from your branch into `develop`:

   * **Title**: `[US-XX] <type>(<scope>): <short description>`
   * **Description**:

     * Summary of the change
     * Related issue (`Closes #XX`)
     * Steps to test locally

6. Assign at least one reviewer and wait for approval.

7. Once approved and CI is green, merge using **Squash and Merge**.

## Commit Conventions

Use the format:

    <type>(<scope>): <short description>

* **type**: feat | fix | chore | docs | style | refactor | test
* **scope**: area of code affected
* **short description**: concise but descriptive

## Pull Request Guidelines

* PR title should start with `[US-XX]` to reference the user story and follow Conventional Commits format.
* In the PR description include:

  1. **What** this change does.
  2. **Why** it's needed (link the issue, e.g. `Closes #XX`).
  3. **How to test** it locally (minimal steps).

## Issue Format

When creating an **Issue**:

* Use a clear title: `[US-XX] Short description`
* In the body, include:

  * **User story** (see template in docs/templates)
  * **Acceptance criteria** (checklist)
