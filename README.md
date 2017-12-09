# GistMGR
Manages URLs in a text file using grep

## Installation
* Copy `gistmgr.sh` into a bin folder like ~/bin or /usr/local/bin.
* Optionally, copy `gistmgr.1` into your `MANPATH`.
* `chmod +x (where you put gistmgr.sh)`
* Run it from the command line.

## Usage
By default, GistMGR stores the gistlist in ~/.gistmgr. You can change
this in ~/.gistmgrrc.
```sh
# Add to the GistMGR list
gistmgr add 00 https://google.com

# Remove from the list
gistmgr add 00 https://google.com

# Add to the list with a comment
gistmgr add 00 https://google.com/search 'Amazing!'

# Get everything in list 00.
gistmgr list 00
# => 00 https://google.com/search Amazing!
```
Each time, it will `git commit`. It's up to you to git-push, though.
You also have to configure the remote to work with Bitbucket Snippets
or GitHub Gists.

## Internal File Storage
Internally, GistMGR stores the URLs as follows:
```
<list> <url> [comment]
```

A list also begins with a comment 'GistMGR' to prevent potential
errors when removing a file. For example, a list may look like follows.
```
# GistMGR
00 https://google.com/search
00 https://medium.com Really neat!
00 https://reddit.com
```

In addition, any spaces in the URL are transformed to `%20`. So,
if you `gistmgr add 00 'https://google.com/search?q=hi world'`, it
will be logged as follows:
```
00 https://google.com/search?q=hi%20world
```
This shouldn't cause any problems with websites.

## License
GistMGR is under the GNU General Public License.

