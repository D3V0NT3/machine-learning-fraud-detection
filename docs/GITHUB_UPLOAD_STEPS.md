# GitHub Upload Steps

## Option 1: Upload using the GitHub website

1. Go to GitHub and create a new repository.
2. Recommended repository name: `machine-learning-fraud-detection`.
3. Set the repository to **Private** while the coursework is awaiting marking.
4. Upload the contents of this folder.
5. Commit the files with the message: `Initial machine learning fraud detection project`.

## Option 2: Upload using Git commands

From inside this project folder, run:

```bash
git init
git add .
git commit -m "Initial machine learning fraud detection project"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/machine-learning-fraud-detection.git
git push -u origin main
```

Replace `YOUR-USERNAME` with your GitHub username.

## Suggested commit messages

```bash
git commit -m "Add fraud detection dataset"
git commit -m "Add R analysis script"
git commit -m "Add model evaluation outputs"
git commit -m "Add ROC and variable importance plots"
git commit -m "Update README with project results"
```
