# Configuration Summary

1. The Package (packages.el)
Tells Doom to download the package.

(package! org-gcal)

2. The Credentials & Setup (config.el)
Connects your Emacs to the Google Cloud app and maps your calendars to local files.

(setq org-gcal-client-id "YOUR_CLIENT_ID"
      org-gcal-client-secret "YOUR_CLIENT_SECRET"
      org-gcal-fetch-file-alist '(("primary.email@gmail.com" . "~/org/gcal.org")
                                  ("work.calendar.id@google.com" . "~/org/gcal-work.org")))

;; Tell the Agenda to actually look at the files in this folder
(setq org-agenda-files '("~/org/"))

---

# The Core org-gcal Commands (via SPC :)
These are the commands you type into the M-x (or SPC :) prompt.

* org-gcal-fetch
  - What it does: Pulls new events down from Google to your Emacs files.
  - When to use: When you just opened Emacs, or know someone sent you a calendar invite.

* org-gcal-sync
  - What it does: Two-way sync. Pulls changes down, and pushes modifications of existing events back up.
  - When to use: Your daily driver command after modifying your calendar locally.

* org-gcal-post-at-point
  - What it does: Pushes a brand new Org-mode heading up to Google as a new event.
  - When to use: Put your cursor on a new task you just made, run this, and it will give it a Google ID and push it to the cloud.

---

# Essential Agenda Shortcuts (SPC o a a)
Once you are looking at your compiled Agenda timeline, use these in Normal mode:

Navigation:
* f / b : Move forward or backward in time (by day, week, or month).
* . : Snap back to today.
* Enter : Jump from the Agenda directly to the text file where that event lives.
* q : Quit the calendar.

Changing the View:
* v d : Day view.
* v w : Week view.
* v m : Month view.
* r : Rebuild/refresh the Agenda (crucial if you just ran a fetch/sync and want to see the new data).

---

# How to Create a New Event (Step-by-Step)
1. Open your calendar file (e.g., SPC f f -> ~/org/gcal-work.org).
2. Create a heading: * Lunch with Client
3. Press SPC m d s to schedule it and type the time (e.g., tomorrow 12:00-13:00).
4. Press SPC : and run org-gcal-post-at-point.
5. Emacs attaches the Google ID, and you are done!
