#!/bin/sed -Ef
# https://guides.github.com/features/mastering-markdown/

/^ *```/{
    # Exchange hold and pattern spaces
    x
    # Hold space was empty
    /./!s/.*/<pre><code>/
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
s/(^| )\[(.*)\] *\((.+)\)/\1<a href="\3">\2<\/a>/g

# ***text*** or ___text___
s/(^|[^\*_])[\*_]{3}([^\*_]+)[\*_]{3}([^\*_]|$)/\1<b><i>\2<\/i><\/b>\3/g

# **text** or __text__
s/(^|[^\*_])[\*_]{2}([^\*_]+)[\*_]{2}([^\*_]|$)/\1<b>\2<\/b>\3/g

# *text* or _text_
s/(^|[^\*_])[\*_]([^\*_]+)[\*_]([^\*_]|$)/\1<i>\2<\/i>\3/g

# `text`
s/(^|[^`])`([^`]+)`([^`]|$)/\1<code>\2<\/code>\3/g

# No headers means it's a normal paragraph
s/^[^# ]+.*/<p>&<\/p>/;t

# Headers
s/^ *#{6} *([^#].*)*$/<h6>\1<\/h6>/;t
s/^ *#{5} *([^#].*)*$/<h5>\1<\/h5>/;t
s/^ *#{4} *([^#].*)*$/<h4>\1<\/h4>/;t
s/^ *#{3} *([^#].*)*$/<h3>\1<\/h3>/;t
s/^ *#{2} *([^#].*)*$/<h2>\1<\/h2>/;t
s/^ *# *([^#].*)*$/<h1>\1<\/h1>/;t
