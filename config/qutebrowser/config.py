import pywalQute.draw

## Appearance ##
c.colors.webpage.darkmode.enabled = True
pywalQute.draw.color(c, {"spacing": {"vertical": 6, "horizontal": 8}})
c.fonts.default_family = "JetBrainsMonoNerdFont"
#######

## Privacy & Adblock ##
c.content.cookies.accept = "no-unknown-3rdparty"
c.content.blocking.method = "both"
c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"
#######

## Search ##
c.url.default_page = "https://search.brave.com"
c.url.start_pages = "https://search.brave.com"
c.url.searchengines = {
    "DEFAULT": "https://search.brave.com/search?q={}",
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
file_select = ["kitty", "-e", "yazi", "--chooser-file={}"]
c.fileselect.folder.command = file_select
c.fileselect.multiple_files.command = file_select
c.fileselect.single_file.command = file_select
c.fileselect.handler = "external"
#######

# Load from yaml file
# Set to false to disable any overrides
config.load_autoconfig(True)
