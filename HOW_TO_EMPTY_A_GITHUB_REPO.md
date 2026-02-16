# How to Empty a GitHub Repository

This guide provides multiple methods to empty a GitHub repository while preserving the repository itself and its git history.

## Table of Contents
- [Why Empty a Repository?](#why-empty-a-repository)
- [Important Warnings](#important-warnings)
- [Method 1: Using Git Commands (Recommended)](#method-1-using-git-commands-recommended)
- [Method 2: Using GitHub Web Interface](#method-2-using-github-web-interface)
- [Method 3: Using GitHub CLI](#method-3-using-github-cli)
- [What Gets Preserved](#what-gets-preserved)
- [Alternative: Archive Instead of Empty](#alternative-archive-instead-of-empty)

---

## Why Empty a Repository?

Common reasons to empty a repository:
- Starting fresh with a new project in an existing repo
- Removing sensitive data before making a repo public
- Cleaning up after a migration or restructuring
- Removing all content while keeping the repository's URL and settings

---

## Important Warnings

⚠️ **CRITICAL WARNINGS** ⚠️

1. **This action is destructive** - All files will be permanently deleted
2. **Create a backup** - Consider backing up your repository first
3. **Check for sensitive data** - If removing sensitive data, consider using tools like `git-filter-repo` to remove it from history
4. **Notify collaborators** - Inform team members before emptying a shared repository
5. **Git history remains** - Emptying files doesn't remove commit history. If you need to remove history, see the section on creating a new orphan branch.

---

## Method 1: Using Git Commands (Recommended)

This is the most reliable method for emptying a repository.

### Step 1: Clone or Navigate to Your Repository

```bash
# If not already cloned
git clone https://github.com/your-username/your-repo.git
cd your-repo

# Or navigate to existing clone
cd /path/to/your-repo
```

### Step 2: Remove All Files

```bash
# Remove all files and directories (except .git)
# This command safely keeps only the .git directory
find . -maxdepth 1 ! -name '.git' ! -name '.' ! -name '..' -exec rm -rf {} +
```

### Step 3: Verify the Repository is Empty

```bash
ls -la
# Should only show . .. and .git
```

### Step 4: Commit the Changes

```bash
# Stage all deletions
git add -A

# Commit with a clear message
git commit -m "Empty repository - remove all files"
```

### Step 5: Push to GitHub

```bash
git push origin main  # or master, or your default branch name
```

### Optional: Create a Minimal README

If you want to keep a placeholder:

```bash
echo "# Repository Name" > README.md
echo "" >> README.md
echo "This repository is currently empty." >> README.md

git add README.md
git commit -m "Add placeholder README"
git push origin main
```

---

## Method 2: Using GitHub Web Interface

This method is useful for small repositories but impractical for many files.

### Steps:

1. Go to your repository on GitHub (https://github.com/your-username/your-repo)
2. Navigate to each file
3. Click the file to open it
4. Click the pencil icon (Edit) or trash icon (Delete)
5. Delete the file content or delete the file
6. Scroll down and commit the change
7. Repeat for all files

**Note**: This method is tedious for repositories with many files.

---

## Method 3: Using GitHub CLI

If you have [GitHub CLI](https://cli.github.com/) installed:

```bash
# Clone the repository
gh repo clone your-username/your-repo
cd your-repo

# Remove all files except .git
find . -maxdepth 1 ! -name '.git' ! -name '.' ! -name '..' -exec rm -rf {} +

# Commit and push
git add -A
git commit -m "Empty repository"
git push origin main
```

---

## What Gets Preserved

When you empty a repository using the methods above, the following are preserved:

✅ **Preserved:**
- Repository URL
- Repository settings
- Issues
- Pull requests
- Wiki
- Projects
- Actions
- Security settings
- Collaborators and permissions
- Stars and watchers
- Git commit history

❌ **Removed:**
- All files in the working directory
- Directory structure

---

## Removing Git History (Advanced)

If you want to start completely fresh with no history:

### Create a New Orphan Branch

```bash
# Create a new orphan branch (no history)
git checkout --orphan new-main

# Remove all files
git rm -rf .

# Create initial commit
echo "# Repository Name" > README.md
git add README.md
git commit -m "Initial commit"

# Delete old main branch and rename new one
git branch -D main  # or master
git branch -m main  # or master

# Force push to GitHub (⚠️ DESTRUCTIVE)
git push -f origin main
```

⚠️ **Warning**: Force pushing will overwrite remote history. All collaborators will need to re-clone.

---

## Alternative: Archive Instead of Empty

Instead of emptying, consider archiving the repository:

### Option 1: Archive on GitHub
1. Go to repository Settings
2. Scroll to "Danger Zone"
3. Click "Archive this repository"
4. Confirm the action

This makes the repository read-only but preserves all content.

### Option 2: Create a Backup Branch

```bash
# Create a backup branch before emptying
git checkout -b backup-$(date +%Y%m%d)
git push origin backup-$(date +%Y%m%d)

# Then empty main branch
git checkout main
# ... proceed with emptying
```

---

## Best Practices

1. **Always back up** - Create a backup branch or clone before emptying
2. **Document why** - Add a README explaining why the repo was emptied
3. **Communicate** - Notify all collaborators before making changes
4. **Consider alternatives** - Sometimes archiving or creating a new repo is better
5. **Check integrations** - Verify CI/CD, webhooks, and other integrations after emptying
6. **Update documentation** - Update any external docs that reference the old structure

---

## Troubleshooting

### Issue: "Permission denied" when removing files

```bash
# Change permissions first
chmod -R u+w .

# Then use safe find command
find . -maxdepth 1 ! -name '.git' ! -name '.' ! -name '..' -exec rm -rf {} +
```

### Issue: Hidden files not deleted

```bash
# List hidden files first
ls -la

# Delete specific hidden files
rm -f .gitignore .env .DS_Store

# Or use find (only in current directory, preserving .git)
find . -maxdepth 1 -name ".*" ! -name ".git" ! -name "." ! -name ".." -delete
```

### Issue: Git won't stage deletions

```bash
# Use -A flag to stage all changes including deletions
git add -A

# Or
git add -u  # Updates tracked files including deletions
```

---

## Example: Complete Workflow

Here's a complete example of safely emptying a repository:

```bash
# 1. Clone and enter repository
git clone https://github.com/username/myrepo.git
cd myrepo

# 2. Create backup branch
git checkout -b backup-before-empty
git push origin backup-before-empty

# 3. Return to main branch
git checkout main

# 4. Remove all files except .git
find . -maxdepth 1 ! -name '.git' ! -name '.' ! -name '..' -exec rm -rf {} +

# 5. Verify emptiness
ls -la

# 6. Create placeholder README (optional)
echo "# MyRepo" > README.md
echo "This repository is being restructured." >> README.md

# 7. Commit changes
git add -A
git commit -m "Empty repository for restructuring"

# 8. Push to GitHub
git push origin main

# 9. Verify on GitHub
# Visit https://github.com/username/myrepo
```

---

## Summary

Emptying a GitHub repository is straightforward but requires care. The recommended approach is:

1. ✅ Clone the repository locally
2. ✅ Create a backup branch
3. ✅ Remove all files except `.git`
4. ✅ Commit and push changes
5. ✅ Optionally add a placeholder README

Remember: **Always back up before making destructive changes!**

---

## Additional Resources

- [GitHub Documentation](https://docs.github.com/)
- [Git Documentation](https://git-scm.com/doc)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [git-filter-repo](https://github.com/newren/git-filter-repo) - For removing sensitive data from history

---

*Last Updated: February 2026*
