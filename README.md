<div align="center">
  <img 
    src="https://github.com/user-attachments/assets/fbdf0831-0d6a-495d-bdbf-c0aaa28bff6c" 
    alt="Logo" 
    width="400"
    style="
      filter: invert(0%);
    ">
  <p style="font-size: 100px;"><i>Speedy navigation with minimal mental overhead.</i></p>
</div>


----
Shunpo is a minimalist bash tool that tries to make directory navigation in terminal just a little bit faster.
If you frequently use commands like `cd`, `pushd`, `popd`, Shunpo might make your life easier by providing a simple bookmarking system and jump to nearby directories with fewer keystrokes.

Requirements
----
Bash 3.2 or newer.

Installation
----
Run `install.sh && source ~/.bashrc`.

Commands
----
#### Bookmarking
`sb`: Add the current directory to bookmarks.  
`sg`: Go to a bookmark.  
`sr`: Remove a bookmark.  
`sl`: List all bookmarks.  
`sc`: Clear all bookmarks.   

#### Navigation
`sj`: "Jump" up to a parent directory.  
`sd`: "Dive" down to a child directory.

#### Pages
`n`: Next page.  
`p`: Previous page.  
`b`: Move selection back to parent directory. (For `sd` only.)  
`Enter`: Navigate to selected directory (For `sd` only.)  
 
Uninstalling
----
Run `uninstall.sh`

