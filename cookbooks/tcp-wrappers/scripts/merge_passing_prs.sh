#!/bin/bash
set -e

# Script to monitor GitHub Actions and merge PRs when they pass
# Usage: ./merge_passing_prs.sh [--auto-approve]

echo "Starting PR monitor script..."
AUTO_APPROVE=${1:-""}

# Check if gh CLI is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is not installed. Please install it first."
    exit 1
fi

# Check authentication status
if ! gh auth status &> /dev/null; then
    echo "Not authenticated with GitHub. Please run 'gh auth login' first."
    exit 1
fi

echo "Checking for open PRs..."
OPEN_PRS=$(gh pr list --json number,headRefName,title,headRepository,mergeStateStatus,reviewDecision,checksStatus --jq '.')

if [ -z "$OPEN_PRS" ]; then
    echo "No open PRs found."
    exit 0
fi

echo "$OPEN_PRS" | jq -c '.[]' | while read -r PR; do
    PR_NUMBER=$(echo "$PR" | jq -r '.number')
    PR_TITLE=$(echo "$PR" | jq -r '.title')
    PR_BRANCH=$(echo "$PR" | jq -r '.headRefName')
    MERGE_STATUS=$(echo "$PR" | jq -r '.mergeStateStatus')
    CHECKS_STATUS=$(echo "$PR" | jq -r '.checksStatus')
    REVIEW_DECISION=$(echo "$PR" | jq -r '.reviewDecision')
    
    echo "----------------------------------------"
    echo "PR #$PR_NUMBER: $PR_TITLE"
    echo "Branch: $PR_BRANCH"
    echo "Merge status: $MERGE_STATUS"
    echo "Checks status: $CHECKS_STATUS"
    echo "Review decision: $REVIEW_DECISION"
    
    # Check if PR is ready to merge
    if [ "$CHECKS_STATUS" == "SUCCESS" ] && [ "$MERGE_STATUS" == "CLEAN" ]; then
        if [ "$AUTO_APPROVE" == "--auto-approve" ] || [ "$REVIEW_DECISION" == "APPROVED" ]; then
            echo "All checks passed for PR #$PR_NUMBER. Merging..."
            
            if [ "$AUTO_APPROVE" == "--auto-approve" ] && [ "$REVIEW_DECISION" != "APPROVED" ]; then
                echo "Auto-approving PR..."
                gh pr review $PR_NUMBER --approve
            fi
            
            gh pr merge $PR_NUMBER --squash --delete-branch
            echo "PR #$PR_NUMBER merged successfully!"
        else
            echo "PR #$PR_NUMBER is ready to merge but needs approval."
        fi
    else
        echo "PR #$PR_NUMBER is not ready to merge."
        
        # Check CI status more specifically
        if [ "$CHECKS_STATUS" != "SUCCESS" ]; then
            echo "CI checks are not passing. Current status: $CHECKS_STATUS"
            gh run list --branch $PR_BRANCH --limit 5
        fi
        
        if [ "$MERGE_STATUS" != "CLEAN" ]; then
            echo "PR has merge conflicts that need to be resolved."
        fi
    fi
done

echo "----------------------------------------"
echo "PR monitoring complete!"