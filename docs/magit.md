# Magit Cheat Sheet for Doom Emacs

## Getting Started
* SPC g g   - Open Magit Status (the main cockpit)
* q         - Quit / Close Magit buffers

## Navigation in Magit Status
* j / k     - Move cursor down / up
* Tab       - Expand or collapse diff details for a file or section
* $         - View the raw command line output of running Git processes

## Staging & Unstaging (The "s" & "u" Keys)
* s         - Stage the file or hunk under the cursor
* u         - Unstage the file or hunk under the cursor
* S         - Stage ALL unstaged changes
* U         - Unstage ALL staged changes
* k         - Discard / delete the unstaged changes under cursor (CAREFUL!)

## Committing (The "c" Key)
* c c       - Open the commit window to write a commit message
* C-c C-c   - Save commit message and finalize the commit
* C-c C-k   - Cancel and discard the current commit draft

## Pushing & Pulling (The "P" & "F" Keys)
* P u       - Push to upstream (pushes your committed changes to GitHub)
* F u       - Pull from upstream (pulls down latest changes from GitHub)

## Branching & Logs (The "b" & "l" Keys)
* l l       - Show local commit history log
* b b       - Switch to a different branch
* b c       - Create and checkout a new branch

