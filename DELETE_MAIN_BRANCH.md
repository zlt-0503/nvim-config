# How to Delete the Main Branch

This repository currently has both `main` and `master` branches. The default branch is `master`, so the `main` branch can be safely deleted if it's no longer needed.

## Steps to Delete the Main Branch

### 1. Verify the Default Branch

First, check which branch is set as the default:

```bash
git remote show origin | grep "HEAD branch"
```

This should show that `master` is the default branch.

### 2. Delete the Main Branch Locally (if it exists)

If you have the `main` branch checked out locally:

```bash
# Switch to a different branch first
git checkout master

# Delete the local main branch
git branch -d main
```

If the branch has unmerged changes and you want to force delete it:

```bash
git branch -D main
```

### 3. Delete the Main Branch from Remote

To delete the `main` branch from the remote repository (GitHub):

```bash
git push origin --delete main
```

Or using the shorter syntax:

```bash
git push origin :main
```

## Alternative: Using GitHub Web Interface

You can also delete the branch through GitHub's web interface:

1. Go to the repository on GitHub: https://github.com/zlt-0503/nvim-config
2. Click on the "branches" link (shows the number of branches)
3. Find the `main` branch in the list
4. Click the trash/delete icon next to the `main` branch
5. Confirm the deletion

## Important Notes

- **Ensure the default branch is not `main`**: Before deleting, make sure your repository's default branch is set to `master` or another branch in GitHub Settings → Branches.
- **Check for open PRs**: Make sure there are no open pull requests targeting the `main` branch.
- **Notify collaborators**: If you're working with others, let them know about the branch deletion so they can clean up their local copies.

## After Deletion

Once the remote `main` branch is deleted, collaborators should clean up their local references:

```bash
# Fetch the latest changes and prune deleted remote branches
git fetch --prune

# Verify the main branch is gone
git branch -a | grep main
```

## Troubleshooting

### Error: Cannot delete branch 'main'

If you get an error saying the branch is protected or is the default branch:

1. Go to GitHub Settings → Branches
2. Change the default branch to `master`
3. Remove any branch protection rules for `main`
4. Try deleting again

### Permission Denied

You need write/admin access to the repository to delete branches. Contact the repository owner if you don't have the necessary permissions.
