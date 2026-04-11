#!/bin/sh
#
# Script to install git hooks
#
echo "Setting up git hooks..."

# Create scripts directory if it doesn't exist
mkdir -p "$(dirname "$0")"

# Copy pre-commit hook from .github/hooks to .git/hooks
cp .github/hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "Git hooks installed successfully!"