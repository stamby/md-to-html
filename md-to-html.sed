#!/bin/sed -Ef

### md-to-html: Sed script that converts Markdown to HTML code

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

# Per-word formatting

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

# ~~text~~
s/(^|[^~])~~([^~]+)~~([^~]|$)/\1<s>\2<\/s>\3/g

# `text`
s/(^|[^`])`([^`]+)`([^`]|$)/\1<code>\2<\/code>\3/g

# Numbered lists, bulleted lists, blockquotes
/^ *[0-9]+ *[\.-]|^ *[\*-] *[^\*-]|^ *>/{
    # Append the previously held space to the current space
    x
    G
    # Only when we are not at the last line
    $!{
        # The current space goes to hold space and gets removed for now
        h
        d
    }
}

# Find out what's being held
x

/(^|\n) *[0-9]+ *[\.-]/{
    # Add "<li>" and "</li>" to all occurrences
    s/(^|\n)( *)[0-9]+ *[\.-] *([^\n]+)/\1\2<li>\3<\/li>/g
    # Check whether there are subtrees
    /\n * <li>/{
        # Note that these are assumed to start with a new line and a space
        # Add "<ol>" and "</ol>" delimiters for subtrees
        s/\n( +)<li>[^\n]+<\/li>(\n\1<li>[^\n]+<\/li>)*/\n\1<ol>&\n\1<\/ol>/g
    }
    # Add them for the main tree
    s/(^|\n)( *)(<li>.*)(<\/ol>|<\/li>)/\1\2<ol>\n\2\3\4\n\2<\/ol>/
}

# These are copied from the previous block
# except for the regular expressions and HTML tags
/(^|\n) *[\*-] *[^\*-]/{
    s/(^|\n)( *) *[\*-] *([^\n]+)/\1\2<li>\3<\/li>/g
    /\n * <li>/{
        s/\n( +)<li>[^\n]+<\/li>(\n\1<li>[^\n]+<\/li>)*/\n\1<ul>&\n\1<\/ul>/g
    }
    s/(^|\n)( *)(<li>.*)(<\/ul>|<\/li>)/\1\2<ul>\n\2\3\4\n\2<\/ul>/
}

/(^|\n) *>/{
    s/(^|\n)( *)> *([^\n]+)/\1\2<p>\3<\/p>/g
    /\n * <p>/{
        s/\n( +)<p>[^\n]+<\/p>(\n\1<p>[^\n]+<\/p>)*/\n\1<blockquote>&\n\1<\/blockquote>/g
    }
    s/(^|\n)( *)(<p>.*)(<\/blockquote>|<\/p>)/\1\2<blockquote>\n\2\3\4\n\2<\/blockquote>/
}

# If any of the previous matches were successful
/\n *<li>|(^|\n) *<blockquote>/{
    # Add new lines in the right places
    s/^\n*(.*)\n?/\1\n/
    # If this is the last line, remove the exceeding new line
    $s/\n$//
    # Go to the end of script
    b
}

x

# No headers means it's a normal paragraph
s/^ *[^#].*/<p>&<\/p>/;t

# Headers
s/^ *#{6} *([^#].*)*$/<h6>\1<\/h6>/;t
s/^ *#{5} *([^#].*)*$/<h5>\1<\/h5>/;t
s/^ *#{4} *([^#].*)*$/<h4>\1<\/h4>/;t
s/^ *#{3} *([^#].*)*$/<h3>\1<\/h3>/;t
s/^ *#{2} *([^#].*)*$/<h2>\1<\/h2>/;t
s/^ *# *([^#].*)*$/<h1>\1<\/h1>/;t
