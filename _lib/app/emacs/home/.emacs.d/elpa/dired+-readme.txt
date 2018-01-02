   Extensions to Dired.

 This file extends functionalities provided by standard GNU Emacs
 files `dired.el', `dired-aux.el', and `dired-x.el'.

 Key bindings changed.  Menus redefined.  `diredp-mouse-3-menu'
 popup menu added.  New commands.  Some commands enhanced.

 All of the new functions, variables, and faces defined here have
 the prefix `diredp-' (for Dired Plus) in their names.


 Wraparound Navigation
 ---------------------

 In vanilla Dired, `dired-next-marked-file' (`M-}' or `* C-n') and
 `dired-previous-marked-file' (`M-{' or `* C-p') wrap around when
 you get to the end or the beginning of the Dired buffer.  Handy.

 But the other navigation commands do not wrap around.  In `Dired+'
 they do, provided option `diredp-wrap-around-flag' is non-nil,
 which it is by default.  This means the following commands:

   `diredp-next-line'     - `n', `C-n', `down', `SPC'
   `diredp-previous-line' - `p', `C-p', `up'
   `diredp-next-dirline'  - `>'
   `diredp-prev-dirline'  - `<'
   `diredp-next-subdir'   - `C-M-n'
   `diredp-prev-subdir'   - `C-M-p'


 Fontification
 -------------

 If you want a maximum or minimum fontification for Dired mode,
 then customize option `font-lock-maximum-decoration'.  If you want
 a different fontification level for Dired than for other modes,
 you can do this too by customizing
 `font-lock-maximize-decoration'.

 A few of the user options defined here have an effect on
 font-locking, and this effect is established only when Dired+ is
 loaded, which defines the font-lock keywords for Dired.  These
 options include `diredp-compressed-extensions',
 `diredp-ignore-compressed-flag', and `dired-omit-extensions'.
 This means that if you change the value of such an option then you
 will see the change only in a new Emacs session.

 (You can see the effect in the same session if you use `C-M-x' on
 the `defvar' sexp for `diredp-font-lock-keywords-1', and then you
 toggle font-lock off and back on.)


 Act on All Files
 ----------------

 Most of the commands (such as `C' and `M-g') that operate on the
 marked files have the added feature here that multiple `C-u' use
 not the files that are marked or the next or previous N files, but
 *all* of the files in the Dired buffer.  Just what "all" files
 means changes with the number of `C-u', as follows:

   `C-u C-u'         - Use all files present, but no directories.
   `C-u C-u C-u'     - Use all files and dirs except `.' and `..'.
   `C-u C-u C-u C-u' - use all files and dirs, `.' and `..'.

   (More than four `C-u' act the same as two.)

 This feature can be particularly useful when you have a Dired
 buffer with files chosen from multiple directories.

 Note that in most cases this behavior is described only in the doc
 string of function `dired-get-marked-files'.  It is generally
 *not* described in the doc strings of the various commands,
 because that would require redefining each command separately
 here.  Instead, we redefine macro `dired-map-over-marks' and
 function `dired-get-filename' in order to achieve this effect.

 Commands such as `dired-do-load' for which it does not make sense
 to act on directories generally treat more than two `C-u' the same
 as two `C-u'.

 Exceptions to the general behavior described here are called out
 in the doc strings.  In particular, the behavior of a prefix arg
 for `dired-do-query-replace-regexp' is different, so that you can
 use it also to specify word-delimited replacement.


 Act on Marked (or All) Files Here and Below
 -------------------------------------------

 The prefix argument behavior just described does not apply to the
 `diredp-*-recursive' commands.  These commands act on the marked
 files in the current Dired buffer or on all files in the directory
 if none are marked.

 But these commands also handle marked subdirectories recursively,
 in the same way.  That is, they act also on the marked files in
 any marked subdirectories, found recursively.  If there is no
 Dired buffer for a given marked subdirectory then all of its files
 and subdirs are acted on.

 With a prefix argument, all marks are ignored.  The commands act
 on all files in the current Dired buffer and all of its
 subdirectories, recursively.

 All of the `diredp-*-recursive' commands are on prefix key `M-+',
 and they are available on submenu `Marked Here and Below' of the
 `Multiple' menu-bar menu.

 If you use library `Icicles' then you have these additional
 commands/keys that act recursively on marked files.  They are in
 the `Icicles' submenu of menu `Multiple' > `Marked Here and
 Below'.

 * `M-+ M-s M-s' or `M-s M-s m' - Use Icicles search (and its
                 on-demand replace) on the marked files.

 * Save the names of the marked files:

   `M-+ C-M->' - Save as a completion set, for use during
                 completion (e.g. with `C-x C-f').

   `M-+ C->'   - Add marked names to the names in the current saved
                 completion set.

   `M-+ C-}'   - Save persistently to an Icicles cache file, for
                 use during completion in another session.

   `icicle-dired-save-marked-to-fileset-recursive' - Like `M-+
                 C-}', but save persistently to an Emacs fileset.

   `M-+ C-M-}' - Save to a Lisp variable.


 In the other direction, if you have a saved set of file names then
 you can use `C-M-<' (`icicle-dired-chosen-files-other-window') in
 Dired to open a Dired buffer for just those files.  So you can
 mark some files and subdirs in a hierarchy of Dired buffers, use
 `M-+ C-}' to save their names persistently, then later use `C-{'
 to retrieve them, and `C-M-<' (in Dired) to open Dired on them.


 Image Files
 -----------

 `Dired+' provides several enhancements regarding image files.
 Most of these require standard library `image-dired.el'.  One of
 them, command `diredp-do-display-images', which displays all of
 the marked image files, requires standard library `image-file.el'.

 `Dired+' loads these libraries automatically, if available, which
 means an Emacs version that supports image display (Emacs 22 or
 later).  (You must of course have installed whatever else your
 Emacs version needs to display images.)

 Besides command `diredp-do-display-images', see the commands whose
 names have prefix `diredp-image-'.  And see options
 `diredp-image-preview-in-tooltip' and
 `diredp-auto-focus-frame-for-thumbnail-tooltip-flag'.


 Inserted Subdirs, Multiple Dired Buffers, Files from Anywhere,...
 -----------------------------------------------------------------

 These three standard Dired features are worth pointing out.  The
 third in particular is little known because (a) it is limited in
 vanilla Dired and (b) you cannot use it interactively.

  * You can pass a glob pattern with wildcards to `dired'
    interactively, as the file name.

  * You can insert multiple subdirectory listings into a single
    Dired buffer using `i' on each subdir line.  Use `C-u i' to
    specify `ls' switches.  Specifying switch `R' inserts the
    inserted subdirectory's subdirs also, recursively.  You can
    also use `i' to bounce between a subdirectory line and its
    inserted-listing header line.  You can delete a subdir listing
    using `C-u k' on its header line.  You can hide/show an
    inserted subdir using `$'.  You can use `C-_' to undo any of
    these operations.

  * You can open a Dired buffer for an arbitrary set of files from
    different directories.  You do this by invoking `dired'
    non-interactively, passing it a cons of a Dired buffer name and
    the file names.  Relative file names are interpreted relative
    to the value of `default-directory'.  Use absolute file names
    when appropriate.

 `Dired+' makes these features more useful.

 `$' is improved: It is a simple toggle - it does not move the
 cursor forward.  `M-$' advances the cursor, in addition to
 toggling like `$'.  `C-u $' does hide/show all (what `M-$' does in
 vanilla Dired).

 `i' is improved in these ways:

  * Once a subdir has been inserted, `i' bounces between the subdir
    listing and the subdir line in the parent listing.  If the
    parent dir is hidden, then `i' from a subdir opens the parent
    listing so it can move to the subdir line there (Emacs 24+).

  * Vanilla Dired lets you create a Dired listing with files and
    directories from arbitrary locations, but you cannot insert
    (`i') such a directory if it is not in the same directory tree
    as the `default-directory' used to create the Dired buffer.
    `Dired+' removes this limitation; you can insert any non-root
    directories (that is, not `/', `c:/', etc.).

 `Dired+' lets you create Dired buffers that contain arbitrary
 files and directories interactively, not just using Lisp.  Just
 use a non-positive prefix arg (e.g., `C--') when invoking `dired'.

 You are then prompted for the Dired buffer name (anything you
 like, not necessarily a directory name) and the individual files
 and directories that you want listed.

 A non-negative prefix arg still prompts you for the `ls' switches
 to use.  (So `C-0' does both: prompts for `ls' switches and for
 the Dired buffer name and the files to list.)

 `Dired+' adds commands for combining and augmenting Dired
 listings:

  * `diredp-add-to-dired-buffer', bound globally to `C-x D A', lets
    you add arbitrary file and directory names to an existing Dired
    buffer.

  * `diredp-dired-union', bound globally to `C-x D U', lets you
    take the union of multiple Dired listings, or convert an
    ordinary Dired listing to an explicit list of absolute file
    names.  With a non-positive prefix arg, you can add extra file
    and directory names, just as for `diredp-add-to-dired-buffer'.

 You can optionally add a header line to a Dired buffer using
 toggle command `diredp-breadcrumbs-in-header-line-mode'.  (A
 header line remains at the top of the window - no need to scroll
 to see it.)  If you want to show the header line automatically in
 all Dired buffers, you can do this:

   (add-hook 'dired-before-readin-hook
             'diredp-breadcrumbs-in-header-line-mode)

 Some other libraries, such as `Bookmark+' and `Icicles', make it
 easy to create or re-create Dired buffers that list specific files
 and have a particular set of markings.  `Bookmark+' records Dired
 buffers persistently, remembering `ls' switches, markings, subdir
 insertions, and hidden subdirs.  If you use `Icicles' then `dired'
 is a multi-command: you can open multiple Dired buffers with one
 `dired' invocation.

 Dired can help you manage projects.  You might have multiple Dired
 buffers with quite specific contents.  You might have some
 subdirectories inserted in the same Dired buffer, and you might
 have separate Dired buffers for some subdirectories.  Sometimes it
 is useful to have both for the same subdirectory.  And sometimes
 it is useful to move from one presentation to the other.

 This is one motivation for the `Dired+' `diredp-*-recursive'
 commands, which act on the marked files in marked subdirectories,
 recursively.  In one sense, these commands are an alternative to
 using a single Dired buffer with inserted subdirectories.  They
 let you use the same operations on the files in a set of Dired
 directories, without inserting those directories into an ancestor
 Dired buffer.

 You can use command `diredp-dired-inserted-subdirs' to open a
 separate Dired buffer for each of the subdirs that is inserted in
 the current Dired buffer.  Markings and Dired switches are
 preserved.

 In the opposite direction, if you use `Icicles' then you can use
 multi-command `icicle-dired-insert-as-subdir', which lets you
 insert any number of directories you choose interactively into a
 Dired ancestor directory listing.  If a directory you choose to
 insert already has its own Dired buffer, then its markings and
 switches are preserved for the new, subdirectory listing in the
 ancestor Dired buffer.


 Hide/Show Details
 -----------------

 Starting with Emacs 24.4, listing details are hidden by default.
 Note that this is different from the vanilla Emacs behavior, which
 is to show details by default.

 Use `(' anytime to toggle this hiding.  You can use option
 `diredp-hide-details-initially-flag' to change the default/initial
 state.  See also option `diredp-hide-details-propagate-flag'.

 NOTE: If you do not want to hide details initially then you must
       either (1) change `diredp-hide-details-initially-flag' using
       Customize (recommended) or (2) set it to `nil' (e.g., using
       `setq') *BEFORE* loading `dired+.el'.

 If you have an Emacs version older than 24.4, you can use library
 `dired-details+.el' (plus `dired-details.el') to get similar
 behavior.


 If You Use Dired+ in Terminal Mode
 ----------------------------------

 By default, Dired+ binds some keys that can be problematic in some
 terminals when you use Emacs in terminal mode (i.e., `emacs -nw').
 This is controlled by option
 `diredp-bind-problematic-terminal-keys'.

 In particular, keys that use modifiers Meta and Shift together can
 be problematic.  If you use Dired+ in terminal mode, and you find
 that your terminal does not support such keys then you might want
 to customize the option to set the value to `nil', and then bind
 the commands to some other keys, which your terminal supports.

 Regardless of the option value, unless Emacs is in terminal mode
 the keys are bound by default.  The problematic keys used by
 Dired+ include these:

   `M-M'   (aka `M-S-m')   - `diredp-chmod-this-file'
   `M-O'   (aka `M-S-o')   - `diredp-chown-this-file'
   `M-T'   (aka `M-S-t')   - `diredp-touch-this-file'
   `C-M-B' (aka `C-M-S-b') - `diredp-do-bookmark-in-bookmark-file'
   `C-M-G' (aka `C-M-S-g') - `diredp-chgrp-this-file'
   `C-M-R' (aka `C-M-S-r') - `diredp-toggle-find-file-reuse-dir'
   `C-M-T' (aka `C-M-S-t') - `dired-do-touch'
   `M-+ M-B'   (aka `M-+ M-S-b') -
       `diredp-do-bookmark-dirs-recursive'
   `M-+ C-M-B' (aka `M-+ C-M-S-b') -
       `diredp-do-bookmark-in-bookmark-file-recursive'
   `M-+ C-M-T' (aka `M-+ C-M-S-t') - `diredp-do-touch-recursive'

 (See also `(info "(org) TTY keys")' for more information about
 keys that can be problematic in terminal mode.)


 Faces defined here:

   `diredp-autofile-name', `diredp-compressed-file-suffix',
   `diredp-date-time', `diredp-deletion',
   `diredp-deletion-file-name', `diredp-dir-heading',
   `diredp-dir-priv', `diredp-exec-priv', `diredp-executable-tag',
   `diredp-file-name', `diredp-file-suffix', `diredp-flag-mark',
   `diredp-flag-mark-line', `diredp-get-file-or-dir-name',
   `diredp-ignored-file-name', `diredp-link-priv',
   `diredp-mode-line-flagged', `diredp-mode-line-marked'
   `diredp-no-priv', `diredp-number', `diredp-other-priv',
   `diredp-rare-priv', `diredp-read-priv', `diredp-symlink',
   `diredp-tagged-autofile-name', `diredp-write-priv'.

 Commands defined here:

   `diredp-add-to-dired-buffer', `diredp-add-to-this-dired-buffer',
   `diredp-do-apply-function',
   `diredp-do-apply-function-recursive',
   `diredp-async-shell-command-this-file',
   `diredp-bookmark-this-file',
   `diredp-breadcrumbs-in-header-line-mode' (Emacs 22+),
   `diredp-byte-compile-this-file', `diredp-capitalize',
   `diredp-capitalize-recursive', `diredp-capitalize-this-file',
   `diredp-chgrp-this-file', `diredp-chmod-this-file',
   `diredp-chown-this-file',
   `diredp-compilation-files-other-window' (Emacs 24+),
   `diredp-compress-this-file',
   `diredp-copy-filename-as-kill-recursive',
   `diredp-copy-tags-this-file', `diredp-copy-this-file',
   `diredp-decrypt-this-file', `diredp-delete-this-file',
   `diredp-describe-autofile', `diredp-describe-file',
   `diredp-describe-marked-autofiles', `diredp-describe-mode',
   `diredp-dired-for-files', `diredp-dired-for-files-other-window',
   `diredp-dired-inserted-subdirs', `diredp-dired-plus-help',
   `diredp-dired-recent-dirs',
   `diredp-dired-recent-dirs-other-window',
   `diredp-dired-this-subdir', `diredp-dired-union',
   `diredp-do-async-shell-command-recursive', `diredp-do-bookmark',
   `diredp-do-bookmark-dirs-recursive',
   `diredp-do-bookmark-in-bookmark-file',
   `diredp-do-bookmark-in-bookmark-file-recursive',
   `diredp-do-bookmark-recursive', `diredp-do-chmod-recursive',
   `diredp-do-chgrp-recursive', `diredp-do-chown-recursive',
   `diredp-do-copy-recursive', `diredp-do-decrypt-recursive',
   `diredp-do-delete-recursive', `diredp-do-display-images' (Emacs
   22+), `diredp-do-encrypt-recursive',
   `diredp-do-find-marked-files-recursive', `diredp-do-grep',
   `diredp-do-grep-recursive', `diredp-do-hardlink-recursive',
   `diredp-do-isearch-recursive',
   `diredp-do-isearch-regexp-recursive',
   `diredp-do-move-recursive', `diredp-do-paste-add-tags',
   `diredp-do-paste-replace-tags', `diredp-do-print-recursive',
   `diredp-do-query-replace-regexp-recursive',
   `diredp-do-redisplay-recursive',
   `diredp-do-relsymlink-recursive', `diredp-do-remove-all-tags',
   `diredp-do-search-recursive', `diredp-do-set-tag-value',
   `diredp-do-shell-command-recursive', `diredp-do-sign-recursive',
   `diredp-do-symlink-recursive', `diredp-do-tag',
   `diredp-do-touch-recursive', `diredp-do-untag',
   `diredp-do-verify-recursive', `diredp-downcase-recursive',
   `diredp-downcase-this-file', `diredp-ediff',
   `diredp-encrypt-this-file', `diredp-fileset',
   `diredp-fileset-other-window', `diredp-find-a-file',
   `diredp-find-a-file-other-frame',
   `diredp-find-a-file-other-window',
   `diredp-find-file-other-frame',
   `diredp-find-file-reuse-dir-buffer',
   `diredp-find-line-file-other-window',
   `diredp-flag-region-files-for-deletion',
   `diredp-grepped-files-other-window', `diredp-grep-this-file',
   `diredp-hardlink-this-file', `diredp-highlight-autofiles-mode',
   `diredp-image-dired-comment-file',
   `diredp-image-dired-comment-files-recursive',
   `diredp-image-dired-copy-with-exif-name',
   `diredp-image-dired-create-thumb',
   `diredp-image-dired-delete-tag',
   `diredp-image-dired-delete-tag-recursive',
   `diredp-image-dired-display-thumb',
   `diredp-image-dired-display-thumbs-recursive',
   `diredp-image-dired-edit-comment-and-tags',
   `diredp-image-dired-tag-file',
   `diredp-image-dired-tag-files-recursive',
   `diredp-image-show-this-file', `diredp-insert-as-subdir',
   `diredp-insert-subdirs', `diredp-insert-subdirs-recursive',
   `diredp-kill-this-tree', `diredp-list-marked-recursive',
   `diredp-load-this-file', `diredp-mark-autofiles',
   `diredp-marked', `diredp-marked-other-window',
   `diredp-marked-recursive',
   `diredp-marked-recursive-other-window',
   `diredp-mark-extension-recursive',
   `diredp-mark-files-regexp-recursive',
   `diredp-mark-files-tagged-all', `diredp-mark-files-tagged-none',
   `diredp-mark-files-tagged-not-all',
   `diredp-mark-files-tagged-some',
   `diredp-mark-files-tagged-regexp', `diredp-mark-region-files',
   `diredp-mark/unmark-autofiles', `diredp-mark/unmark-extension',
   `diredp-mouse-3-menu', `diredp-mouse-backup-diff',
   `diredp-mouse-copy-tags', `diredp-mouse-describe-autofile',
   `diredp-mouse-describe-file', `diredp-mouse-diff',
   `diredp-mouse-do-bookmark', `diredp-mouse-do-byte-compile',
   `diredp-mouse-do-chgrp', `diredp-mouse-do-chmod',
   `diredp-mouse-do-chown', `diredp-mouse-do-compress',
   `diredp-mouse-do-copy', `diredp-mouse-do-delete',
   `diredp-mouse-do-grep', `diredp-mouse-do-hardlink',
   `diredp-mouse-do-load', `diredp-mouse-do-print',
   `diredp-mouse-do-remove-all-tags', `diredp-mouse-do-rename',
   `diredp-mouse-do-set-tag-value',
   `diredp-mouse-do-shell-command', `diredp-mouse-do-symlink',
   `diredp-mouse-do-tag', `diredp-mouse-do-untag',
   `diredp-mouse-downcase', `diredp-mouse-ediff',
   `diredp-mouse-find-file',
   `diredp-mouse-find-line-file-other-window',
   `diredp-mouse-find-file-other-frame',
   `diredp-mouse-find-file-reuse-dir-buffer',
   `diredp-mouse-flag-file-deletion', `diredp-mouse-mark',
   `diredp-mouse-mark-region-files', `diredp-mouse-mark/unmark',
   `diredp-mouse-unmark', `diredp-mouse-upcase',
   `diredp-mouse-view-file',
   `diredp-multiple-w32-browser-recursive',
   `diredp-nb-marked-in-mode-name', `diredp-next-dirline',
   `diredp-next-line', `diredp-next-subdir', `diredp-omit-marked',
   `diredp-omit-unmarked', `diredp-paste-add-tags-this-file',
   `diredp-paste-replace-tags-this-file', `diredp-prev-dirline',
   `diredp-previous-line', `diredp-prev-subdir',
   `diredp-print-this-file', `diredp-relsymlink-this-file',
   `diredp-remove-all-tags-this-file', `diredp-rename-this-file',
   `diredp-send-bug-report',
   `diredp-set-bookmark-file-bookmark-for-marked',
   `diredp-set-bookmark-file-bookmark-for-marked-recursive',
   `diredp-set-tag-value-this-file',
   `diredp-shell-command-this-file', `diredp-show-metadata',
   `diredp-show-metadata-for-marked', `diredp-sign-this-file',
   `diredp-symlink-this-file', `diredp-tag-this-file',
   `diredp-toggle-find-file-reuse-dir',
   `diredp-toggle-marks-in-region', `diredp-touch-this-file',
   `diredp-unmark-autofiles', `diredp-unmark-files-tagged-all',
   `diredp-unmark-files-tagged-none',
   `diredp-unmark-files-tagged-not-all',
   `diredp-unmark-files-tagged-some', `diredp-unmark-region-files',
   `diredp-untag-this-file', `diredp-upcase-recursive',
   `diredp-up-directory', `diredp-up-directory-reuse-dir-buffer',
   `diredp-upcase-this-file', `diredp-verify-this-file',
   `diredp-w32-drives', `diredp-w32-drives-mode',
   `global-dired-hide-details-mode' (Emacs 24.4+),
   `toggle-diredp-find-file-reuse-dir'.

 User options defined here:

   `diredp-auto-focus-frame-for-thumbnail-tooltip-flag',
   `diredp-bind-problematic-terminal-keys',
   `diredp-compressed-extensions', `diredp-dwim-any-frame-flag'
   (Emacs 22+), `diredp-image-preview-in-tooltip', `diff-switches',
   `diredp-hide-details-initially-flag' (Emacs 24.4+),
   `diredp-highlight-autofiles-mode',
   `diredp-hide-details-propagate-flag' (Emacs 24.4+),
   `diredp-ignore-compressed-flag',
   `diredp-image-show-this-file-use-frame-flag' (Emacs 22+),
   `diredp-max-frames', `diredp-prompt-for-bookmark-prefix-flag',
   `diredp-w32-local-drives', `diredp-wrap-around-flag'.

 Non-interactive functions defined here:

   `derived-mode-p' (Emacs < 22), `diredp-all-files',
   `diredp-ancestor-dirs', `diredp-bookmark',
   `diredp-create-files-non-directory-recursive',
   `diredp-delete-dups', `diredp-directories-within',
   `diredp-dired-plus-description',
   `diredp-dired-plus-description+links',
   `diredp-dired-plus-help-link', `diredp-dired-union-1',
   `diredp-dired-union-interactive-spec',
   `diredp-display-graphic-p', `diredp-display-image' (Emacs 22+),
   `diredp-do-chxxx-recursive', `diredp-do-create-files-recursive',
   `diredp-do-grep-1', `diredp-ensure-bookmark+',
   `diredp-ensure-mode', `diredp-existing-dired-buffer-p',
   `diredp-fewer-than-2-files-p', `diredp-fileset-1',
   `diredp-find-a-file-read-args',
   `diredp-file-for-compilation-hit-at-point' (Emacs 24+),
   `diredp-files-within', `diredp-files-within-1',
   `diredp-fit-frame-unless-buffer-narrowed' (Emacs 24.4+),
   `diredp-get-confirmation-recursive', `diredp-get-files',
   `diredp-get-files-for-dir', `diredp-get-subdirs',
   `diredp-hide-details-if-dired' (Emacs 24.4+),
   `diredp-hide/show-details' (Emacs 24.4+),
   `diredp-highlight-autofiles', `diredp-image-dired-required-msg',
   `diredp-get-image-filename', `diredp-internal-do-deletions',
   `diredp-list-files', `diredp-looking-at-p',
   `diredp-make-find-file-keys-reuse-dirs',
   `diredp-make-find-file-keys-not-reuse-dirs', `diredp-maplist',
   `diredp-marked-here', `diredp-mark-files-tagged-all/none',
   `diredp-mark-files-tagged-some/not-all',
   `diredp-nonempty-region-p', `diredp-parent-dir',
   `diredp-paste-add-tags', `diredp-paste-replace-tags',
   `diredp-read-bookmark-file-args', `diredp-read-include/exclude',
   `diredp-read-regexp', `diredp-recent-dirs',
   `diredp-refontify-buffer', `diredp-remove-if',
   `diredp-remove-if-not', `diredp-root-directory-p',
   `diredp-set-header-line-breadcrumbs' (Emacs 22+),
   `diredp-set-tag-value', `diredp-set-union',
   `diredp--set-up-font-locking', `diredp-string-match-p',
   `diredp-tag', `diredp-this-file-marked-p',
   `diredp-this-file-unmarked-p', `diredp-this-subdir',
   `diredp-untag', `diredp-y-or-n-files-p'.

 Variables defined here:

   `diredp-bookmark-menu', `diredp-file-line-overlay',
   `diredp-files-within-dirs-done', `diredp-font-lock-keywords-1',
   `diredp-hide-details-last-state' (Emacs 24.4+),
   `diredp-hide-details-toggled' (Emacs 24.4+),
   `diredp-hide/show-menu', `diredp-images-recursive-menu',
   `diredp-list-files-map', `diredp-loaded-p',
   `diredp-marks-recursive-menu', `diredp-menu-bar-dir-menu',
   `diredp-menu-bar-marks-menu', `diredp-menu-bar-multiple-menu',
   `diredp-menu-bar-regexp-menu', `diredp-menu-bar-single-menu',
   `diredp-multiple-bookmarks-menu', `diredp-multiple-delete-menu',
   `diredp-multiple-dired-menu', `diredp-multiple-images-menu',
   `diredp-multiple-encryption-menu',
   `diredp-multiple-move-copy-link-menu',
   `diredp-multiple-omit-menu', `diredp-multiple-recursive-menu',
   `diredp-multiple-rename-menu', `diredp-multiple-search-menu',
   `diredp-navigate-menu', `diredp-regexp-recursive-menu',
   `diredp-re-no-dot', `diredp-single-bookmarks-menu',
   `diredp-single-encryption-menu', `diredp-single-image-menu',
   `diredp-single-move-copy-link-menu', `diredp-single-open-menu',
   `diredp-single-rename-menu', `diredp-w32-drives-mode-map'.

 Macros defined here:

   `diredp-with-help-window'.


 ***** NOTE: The following macros defined in `dired.el' have
             been REDEFINED HERE:

 `dired-map-over-marks'    - Treat multiple `C-u' specially.
 `dired-mark-if'           - Better initial msg - Emacs bug #8523.


 ***** NOTE: The following functions defined in `dired.el' have
             been REDEFINED or ADVISED HERE:

 `dired'                   - Handle non-positive prefix arg.
 `dired-do-delete'         - Display message to warn that marked,
                             not flagged, files will be deleted.
 `dired-do-flagged-delete' - Display message to warn that flagged,
                             not marked, files will be deleted.
 `dired-dwim-target-directory' - Uses `diredp-dwim-any-frame-flag'.
 `dired-find-file'         - Allow `.' and `..' (Emacs 20 only).
 `dired-get-filename'      - Test `./' and `../' (like `.', `..').
 `dired-goto-file'         - Fix Emacs bug #7126.
                             Remove `/' from dir before compare.
                             (Emacs < 24 only.)
 `dired-hide-details-mode' - Respect new user options:
                             * `diredp-hide-details-initially-flag'
                             * `diredp-hide-details-propagate-flag'
                             (Emacs 24.4+)
 `dired-insert-directory'  - Compute WILDCARD arg for
                             `insert-directory' for individual file
                             (don't just use nil). (Emacs 23+, and
                             only for MS Windows)
 `dired-insert-set-properties' - `mouse-face' on whole line.
 `dired-mark-files-regexp' - Add regexp to `regexp-search-ring'.
                             More matching possibilities.
                             Added optional arg LOCALP.
 `dired-mark-pop-up'       - Delete the window or frame popped up,
                             afterward, and bury its buffer. Do not
                             show a menu bar for pop-up frame.
 `dired-other-frame'       - Handle non-positive prefix arg.
 `dired-other-window'      - Handle non-positive prefix arg.
 `dired-pop-to-buffer'     - Put window point at bob (bug #12281).
                             (Emacs 22-24.1)
 `dired-read-dir-and-switches' - Non-positive prefix arg behavior.
