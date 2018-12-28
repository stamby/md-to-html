#!/bin/sed -Ef
# https://guides.github.com/features/mastering-markdown/

# Code snippets
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

# ![image](url)
s/!\[(.*)\] *\((.+)\)/<img src="\2" alt="\1">/g
s/!\((.*)\)/<img src="\1">/g

# [Web site](url)
s/\[(.*)\] *\((.+)\)/<a href="\2">\1<\/a>/g

# ***text*** and ___text___
s/(^|[^\*])\*{3}([^\*]+)\*{3}([^\*]|$)/\1<b><i>\2<\/i><\/b>\3/g
s/(^|[^_])_{3}([^_]+)_{3}([^_]|$)/\1<b><i>\2<\/i><\/b>\3/g

# **text** and __text__
s/(^|[^\*])\*{2}([^\*]+)\*{2}([^\*]|$)/\1<b>\2<\/b>\3/g
s/(^|[^_])_{2}([^_]+)_{2}([^_]|$)/\1<b>\2<\/b>\3/g

# *text* and _text_
s/(^|[^\*])\*([^\*]+)\*([^\*]|$)/\1<i>\2<\/i>\3/g
s/(^|[^_])_([^_]+)_([^_]|$)/\1<i>\2<\/i>\3/g

# `text`
s/(^|[^`])`([^`]+)`([^`]|$)/\1<code>\2<\/code>\3/g

# Numbered lists
/^ *[0-9]+\./{
    s/^ +/  /
    s/^( *)[0-9]+\. *(.*)/\1<li>\2<\/li>/
    # Append the previous line in hold space to the current pattern space
    x
    G
    # Remove leading newlines if any
    s/^\n//
    # This line goes to hold space and gets removed for now
    h
    d
}

x
/^<li>/{
    s/.*/<ol>\n&\n<\/ol>\n/
    # Add leading "<ol>" tags
    s/(\n<li>[^\n]+<\/li>\n)(  <li>)/\1  <ol>\n\2/g
    # Add trailing "</ol>" tags
    s/(\n  <li>[^\n]+<\/li>\n)(<li>|<\/ol>)/\1  <\/ol>\n\2/g
    b
}
x

# No headers means it's a normal paragraph
s/^[^# ]+.*/<p>&<\/p>/;t

# Headers
s/^ *#{6} *([^#].*)*$/<h6>\1<\/h6>/;t
s/^ *#{5} *([^#].*)*$/<h5>\1<\/h5>/;t
s/^ *#{4} *([^#].*)*$/<h4>\1<\/h4>/;t
s/^ *#{3} *([^#].*)*$/<h3>\1<\/h3>/;t
s/^ *#{2} *([^#].*)*$/<h2>\1<\/h2>/;t
s/^ *# *([^#].*)*$/<h1>\1<\/h1>/;t
