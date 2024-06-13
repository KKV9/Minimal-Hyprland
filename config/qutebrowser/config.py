# Do not edit this file directly
# It is liable to change when updating
# Create overrides.py in this folder instead
# Refresh after making changes
import pywalQute.draw
import os.path

home = str(os.environ['HOME'])

## Appearance ##
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = True
pywalQute.draw.color(c, {"spacing": {"vertical": 6, "horizontal": 8}})
c.fonts.default_family = "JetBrainsMonoNerdFont"
c.tabs.show = "switching"
c.scrolling.bar = "never"
#######

## Privacy & Adblock ##
c.content.cookies.accept = "never"
c.content.blocking.method = "both"
c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"
c.content.cache.size = 500  # enable cache, common in browsers
c.content.webgl = False  # Disable webgl finger printing
c.content.canvas_reading = False  # Disable canvas finger printing
#######

## Permissions ##
with open(f'{home}/.config/qutebrowser/permissions/cookies') as f:
    for site in f:
        config.set("content.cookies.accept", "no-3rdparty",
                   f"{site}")  # Allow cookies

with open(f'{home}/.config/qutebrowser/permissions/clipboard') as f:
    for site in f:
        config.set("content.javascript.clipboard", "access",
                   f"{site}")  # Allow clipboard access
#######

## Binds ##
config.bind(',m', 'spawn mpv {url}')  # Open mpv
# Translate page to english (google)
config.bind(
    ',t', 'open -t https://translate.google.com/translate?sl=auto&tl=en&u={url}')
#######

## Search ##
c.url.default_page = "https://search.brave.com"
c.url.start_pages = "https://search.brave.com"
c.url.searchengines = {
    "DEFAULT": "https://search.brave.com/search?q={}",
    "!aw": "https://wiki.archlinux.org/index.php?search={}",
    "!gh": "https://github.com/search?o=desc&q={}&s=stars",
    "!gist": "https://gist.github.com/search?q={}",
    "!gi": "https://www.google.com/search?tbm=isch&q={}&tbs=imgo:1",
    "!m": "https://www.google.com/maps/search/{}",
    "!t": "https://www.thesaurus.com/browse/{}",
    "!w": "https://en.wikipedia.org/wiki/{}",
    "!yt": "https://www.youtube.com/results?search_query={}",
}
#######

## File selection ##
file_select = [os.environ['TERMINAL'], "-e", "yazi", "--chooser-file={}"]
folder_select = [os.environ['TERMINAL'], "-e", "yazi", "--cwd-file={}"]
editor_cmd = [os.environ['TERMINAL'], "-e", os.environ['EDITOR'], "{file}"]
c.editor.command = editor_cmd
c.fileselect.folder.command = folder_select
c.fileselect.multiple_files.command = file_select
c.fileselect.single_file.command = file_select
c.fileselect.handler = "external"
#######

# Load from yaml file
# Set to false to disable yaml overrides
config.load_autoconfig(True)
# Source user overrides python configuration
config.source('overrides.py')
