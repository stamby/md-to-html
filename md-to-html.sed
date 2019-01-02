#!/bin/sed -Ef

### md-to-html: Sed script that converts Markdown to HTML code

# HTML entities
s/\&/\&amp\;/g
s/"/&quot\;/g
s/'/&apos\;/g
s/>/\&gt\;/g
s/</\&lt\;/g
s/(>=|=>)/\&ge\;/g
s/(<=|=<)/\&le\;/g

## Code snippets
/^ *```/{
    # Exchange hold and pattern spaces
    x
    # Hold space did not start with three backticks
    /^ *```/!s/.*/<pre><code>/
    t
    # Remove everything from the hold space
    s/.*//
    x
    # This is where the code block ends
    s/.*/<\/code><\/pre>/
    b
}

# If a block of code is being processed, jump onto the next line
x
/^ *```/{
    x
    b
}
x

## Per-word formatting

# <text>
s/(^| )\&lt\; *([^ ]*[:\/][^ ]*) *\&gt\;( |$)/\1<a href="\2">\2<\/a>\3/g
s/(^| )\&lt\; *([^ ]*@[^ ]+) *\&gt\;( |$)/\1<a href="mailto:\2">\2<\/a>\3/g

# ![image](url)
s/!\[(.*)\] *\( *([^ ]+) *\)/<img src="\2" alt="\1">/g
s/!\((.*)\)/<img src="\1">/g

# [Web site](url)
s/\[(.*)\] *\( *([^ ]+) *"([^"]+)"\)/<a href="\2" title="\3">\1<\/a>/g
s/\[(.*)\] *\( *([^ ]+) *\)/<a href="\2">\1<\/a>/g

# ***text*** and ___text___
s/(^|[^\\\*])\*{3}([^\*]+)\*{3}([^\*]|$)/\1<strong><em>\2<\/em><\/strong>\3/g
s/(^|[^\\_])_{3}([^_]+)_{3}([^_]|$)/\1<strong><em>\2<\/em><\/strong>\3/g

# **text** and __text__
s/(^|[^\\\*])\*{2}([^\*]+)\*{2}([^\*]|$)/\1<strong>\2<\/strong>\3/g
s/(^|[^\\_])_{2}([^\_]+)_{2}([^_]|$)/\1<strong>\2<\/strong>\3/g

# *text* and _text_
s/(^|[^\\\*])\*([^\*]+)\*([^\*]|$)/\1<em>\2<\/em>\3/g
s/(^|[^\\_])_([^_]+)_([^_]|$)/\1<em>\2<\/em>\3/g

# ~~text~~
s/(^|[^\\~])~~(.+)~~([^~]|$)/\1<s>\2<\/s>\3/g

# `text`
s/(^|[^\\`])`([^`]+)`([^`]|$)/\1<code>\2<\/code>\3/g

## Numbered lists, bulleted lists, blockquotes

/^ *[0-9]+ *[\.-]|^ *[\*\+-] *[^\*\+-]|^ *\&gt\;/{
    H
    # Only when we are not at the last line, start a new cycle
    $!d
}

# Find out what's being held
x

/(^|\n) *[0-9]+ *[\.-]/{
    # Add "<oli>" and "</oli>" to all occurrences
    s/(^|\n)( *)[0-9]+ *[\.-] *([^\n]+)/\1\2<oli>\3<\/oli>/g
    # Add "<ol>" and "</ol>" tags, up to 3 levels are supported
    s/(^|\n)( ?)<oli>[^\n]+<\/oli>(\n\2 *<oli>[^\n]+<\/oli>)*/\1\2<ol>&\n\2<\/ol>/g
    s/(^|\n)( {1})<oli>[^\n]+<\/oli>(\n\2 *<oli>[^\n]+<\/oli>)*/\1\2<ol>&\n\2<\/ol>/g
    s/(^|\n)( {2})<oli>[^\n]+<\/oli>(\n\2 *<oli>[^\n]+<\/oli>)*/\1\2<ol>&\n\2<\/ol>/g
    s/(^|\n)( {3})<oli>[^\n]+<\/oli>(\n\2 *<oli>[^\n]+<\/oli>)*/\1\2<ol>&\n\2<\/ol>/g
    s/(^|\n)( {4})<oli>[^\n]+<\/oli>(\n\2 *<oli>[^\n]+<\/oli>)*/\1\2<ol>&\n\2<\/ol>/g
}

# These are copied from the previous block
# except for the regular expressions and HTML tags
/(^|\n) *[\*\+-]/{
    s/(^|\n)( *)[\*\+-] *([^\n]+)/\1\2<uli>\3<\/uli>/g
    s/(^|\n)( ?)<uli>[^\n]+<\/uli>(\n\2 *<uli>[^\n]+<\/uli>)*/\1\2<ul>&\n\2<\/ul>/g
    s/(^|\n)( {1})<uli>[^\n]+<\/uli>(\n\2 *<uli>[^\n]+<\/uli>)*/\1\2<ul>&\n\2<\/ul>/g
    s/(^|\n)( {2})<uli>[^\n]+<\/uli>(\n\2 *<uli>[^\n]+<\/uli>)*/\1\2<ul>&\n\2<\/ul>/g
    s/(^|\n)( {3})<uli>[^\n]+<\/uli>(\n\2 *<uli>[^\n]+<\/uli>)*/\1\2<ul>&\n\2<\/ul>/g
    s/(^|\n)( {4})<uli>[^\n]+<\/uli>(\n\2 *<uli>[^\n]+<\/uli>)*/\1\2<ul>&\n\2<\/ul>/g
}

/(^|\n) *\&gt\;/{
    # Loop until all the leading ">" signs become spaces
    :a
    /(^|\n) *\&gt\; *\&gt\;/{
        s/(^|\n)( *)\&gt\;( *)\&gt\;/\1\2 \3/g
        ta
    }
    s/(^|\n)( *)\&gt\; *([^\n]+)/\1\2<p>\3<\/p>/g
    /\n +<p>/{
        s/\n( +)<p>[^\n]+<\/p>(\n\1<p>[^\n]+<\/p>)*/\n\1<blockquote>&\n\1<\/blockquote>/g
    }
    s/(^|\n)( *)(<p>.*)(<\/blockquote>|<\/p>)/\1\2<blockquote>\n\2\3\4\n\2<\/blockquote>\n/
    s/^\n+//
}

# If any of the previous matches were successful
/\n *<[ou]li>|(^|\n) *<blockquote>/{
    # Remove escape characters from special Markdown characters
    s/\\(`|-|\*|_|\{|\}|\[|\]|\(|\)|#|\+|\.|!)/\1/g
    s/<(\/?)[ou]li>/<\1li>/g
    s/^\n*(.*)\n?/\1\n/
    # If this is the last line, remove the exceeding new lin
    $s/\n$//
    # Go to the end of script
    b
}

x

# Remove escape characters again (exact copy of the former)
s/\\(`|-|\*|_|\{|\}|\[|\]|\(|\)|#|\+|\.|!)/\1/g

## Headers and paragraphs

# No headers means it's a normal paragraph
s/^ *[^#].*/<p>&<\/p>/;t

# Headers
s/^ *#{6} *([^#].*)*( *#+)?$/<h6>\1<\/h6>/;t
s/^ *#{5} *([^#].*)*( *#+)?$/<h5>\1<\/h5>/;t
s/^ *#{4} *([^#].*)*( *#+)?$/<h4>\1<\/h4>/;t
s/^ *#{3} *([^#].*)*( *#+)?$/<h3>\1<\/h3>/;t
s/^ *#{2} *([^#].*)*( *#+)?$/<h2>\1<\/h2>/;t
s/^ *# *([^#].*)*( *#+)?$/<h1>\1<\/h1>/;t
