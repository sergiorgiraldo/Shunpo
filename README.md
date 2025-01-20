<div align="center">
  <picture>
    <source srcset="logos/shunpo_logo.png" media="(prefers-color-scheme: dark)">
    <img src="logos/shunpo_logo_inverted.png" alt="Logo" width="400" style="margin: 0; padding: 0;">
  </picture>
  <h4><i>Quick navigation with minimal mental overhead.</i></h4>
</div>

----
Shunpo is a minimalist bash tool that tries to make directory navigation in terminal just a little bit faster by providing a simple system to manage bookmarks and jump to directories with only a few keystrokes.
If you frequently need to use commands like `cd`, `pushd`, or `popd`, Shunpo is for you.

Requirements
----
Bash 3.2 or newer.

Installation
----
Run `install.sh && source ~/.bashrc`.

Tutorial
----
Click [here](https://www.youtube.com/watch?v=gaEYkoFPwK4) for a video tutorial.

Commands
----
#### Bookmarking:
`sb`: Add the current directory to bookmarks.  
`sg`: Go to a bookmark.  
`sr`: Remove a bookmark.  
`sl`: List all bookmarks.  
`sc`: Clear all bookmarks.   

#### Navigation:
`sj`: "Jump" up to a parent directory.  
`sd`: "Dive" down to a child directory.

#### Selection:
`0~9`: Select an option.  
`n`: Next page.  
`p`: Previous page.  
`b`: Move selection back to parent directory. (For `sd` only.)  
`Enter`: Navigate to selected directory (For `sd` only.)  
 
Uninstalling
----
Run `uninstall.sh`

