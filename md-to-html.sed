#!/bin/sed -Ef

### md-to-html: Sed script that converts Markdown to HTML code

# HTML entities
s/(>=|=>)/\&ge\;/g
s/(<=|=<)/\&le\;/g
s/\&/\&amp\;/g
s/"/\&quot\;/g
s/'/\&apos\;/g
s/>/\&gt\;/g
s/</\&lt\;/g

s/([^\\]):[a-zA-Z0-9]+:/\1\&#x1f31f\;/g

s/\\\&ge\;/=>/g
s/\\\&le\;/<=/g
s/\\\&amp\;/\&/g
s/\\\&quot\;/"/g
s/\\\&apos\;/'/g
s/\\\&gt\;/>/g
s/\\\&lt\;/</g

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

# Currently using '[[:alnum:] \&\;\?!,\)\+]*.{0,10}[[:alnum:] \&\;\?!,\)\+]+' in place of '.*'

# [![image](url)](url)
s/\[!\[ *([[:alnum:] \&\;\?!,\)\+]*.{0,10}[[:alnum:] \&\;\?!,\)\+]+) *\] *\( *([^ ]+) *\) *] *\( *([^ ]+) *\)/<a href="\3"><img src="\2" alt="\1"><\/a>/g

# ![image](url)
s/!\[ *([[:alnum:] \&\;\?!,\)\+]*.{0,10}[[:alnum:] \&\;\?!,\)\+]) *\] *\( *([^ ]+) *\)/<img src="\2" alt="\1">/g

# [Web site](url)
s/\[ *([[:alnum:] \&\;\?!,\)\+]*.{0,10}[[:alnum:] \&\;\?!,\)\+-]) *\] *\( *([^ ]+) *"([^"]+)"\)/<a href="\2" title="\3">\1<\/a>/g
s/\[ *([[:alnum:] \&\;\?!,\)\+]*.{0,10}[[:alnum:] \&\;\?!,\)\+]+) *\] *\( *([^ ]+) *\)/<a href="\2">\1<\/a>/g

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
    s/(^|\n)<oli>[^\n]+<\/oli>(\n *<oli>[^\n]+<\/oli>)*/\1<ol>&\n<\/ol>/g
    s/(^|\n)( )<oli>[^\n]+<\/oli>(\n\2 *<oli>[^\n]+<\/oli>)*/\1\2<ol>&\n\2<\/ol>/g
    s/(^|\n)( {2})<oli>[^\n]+<\/oli>(\n\2 *<[ou]li>[^\n]+<\/[ou]li>)*/\1\2<ol>&\n\2<\/ol>/g
    s/(^|\n)( {3})<oli>[^\n]+<\/oli>(\n\2 *<[ou]li>[^\n]+<\/[ou]li>)*/\1\2<ol>&\n\2<\/ol>/g
    s/(^|\n)( {4})<oli>[^\n]+<\/oli>(\n\2 *<[ou]li>[^\n]+<\/[ou]li>)*/\1\2<ol>&\n\2<\/ol>/g
    s/(^|\n)( {5,})<oli>[^\n]+<\/oli>(\n\2 *<[ou]li>[^\n]+<\/[ou]li>)*/\1\2<ol>&\n\2<\/ol>/g
}

# These are copied from the previous block
# except for the regular expressions and HTML tags
/(^|\n) *[\*\+-]/{
    s/(^|\n)( *)[\*\+-] *([^\n]+)/\1\2<uli>\3<\/uli>/g
    s/(^|\n)<uli>[^\n]+<\/uli>(\n *<uli>[^\n]+<\/uli>)*/\1<ul>&\n<\/ul>/g
    s/(^|\n)( )<uli>[^\n]+<\/uli>(\n\2 *<uli>[^\n]+<\/uli>)*/\1\2<ul>&\n\2<\/ul>/g
    s/(^|\n)( {2})<uli>[^\n]+<\/uli>(\n\2 *<[ou]li>[^\n]+<\/[ou]li>)*/\1\2<ul>&\n\2<\/ul>/g
    s/(^|\n)( {3})<uli>[^\n]+<\/uli>(\n\2 *<[ou]li>[^\n]+<\/[ou]li>)*/\1\2<ul>&\n\2<\/ul>/g
    s/(^|\n)( {4})<uli>[^\n]+<\/uli>(\n\2 *<[ou]li>[^\n]+<\/[ou]li>)*/\1\2<ul>&\n\2<\/ul>/g
    s/(^|\n)( {5,})<uli>[^\n]+<\/uli>(\n\2 *<[ou]li>[^\n]+<\/[ou]li>)*/\1\2<ul>&\n\2<\/ul>/g
}

/(^|\n) *\&gt\;/{
    # Loop until all the leading ">" signs become spaces
    :b
    /(^|\n) *\&gt\; *\&gt\;/{
        s/(^|\n)( *)\&gt\;( *)\&gt\;/\1\2 \3/g
        tb
    }
    s/(^|\n)( *)\&gt\; *([^\n]+)/\1\2<p>\3<\/p>/g
    s/(^|\n)<p>[^\n]+<\/p>(\n *<p>[^\n]+<\/p>)*/\1<blockquote>&\n<\/blockquote>/g
    s/(^|\n)( )<p>[^\n]+<\/p>(\n\2 *<p>[^\n]+<\/p>)*/\1\2<blockquote>&\n\2<\/blockquote>/g
    s/(^|\n)( {2})<p>[^\n]+<\/p>(\n\2 *<p>[^\n]+<\/p>)*/\1\2<blockquote>&\n\2<\/blockquote>/g
    s/(^|\n)( {3})<p>[^\n]+<\/p>(\n\2 *<p>[^\n]+<\/p>)*/\1\2<blockquote>&\n\2<\/blockquote>/g
    s/(^|\n)( {4})<p>[^\n]+<\/p>(\n\2 *<p>[^\n]+<\/p>)*/\1\2<blockquote>&\n\2<\/blockquote>/g
    s/(^|\n)( {5,})<p>[^\n]+<\/p>(\n\2 *<p>[^\n]+<\/p>)*/\1\2<blockquote>&\n\2<\/blockquote>/g
}

# If any of the previous matches were successful
/\n *<[ou]li>|\n *<p>/{
    s/<(\/?)[ou]li>/<\1li>/g
    # Remove escape characters
    s/([^\\])\\(.)/\1\2/g
#    s/\\(`|-|\*|_|\{|\}|\[|\]|\(|\)|#|\+|\.|!)/\1/g
    s/^\n+//
    $!s/.*/&\n/
    p
    d
}

x

## Headers and paragraphs

# Remove escape characters again (exact copy of the former)
s/([^\\])\\(.)/\1\2/g

# No headers means it's a normal paragraph
/^ *[^#]/{
    N
    /\n *=+ *$/{
        s/^(.*)\n *=+ */# \1/
    }
    /\n--+$/{
        s/^(.*)\n-+ */## \1/
    }
    /^[^#]/{
        /\n *[0-9]+ *[\.-]|\n *[\*\+-] *[^\*\+-]|\n *>/{
            P
            D
        }
        /<\/p>\n/{
            s/^<p>//
            s/([^ ]) ?<\/p>\n ?/\1 /
            s/$/<\/p>/
            P
            D
        }
        /\n *[^ ].*$/{
            s/.*/<p>&\\<\/p\\>/
        }
        /\n *$/{
            s/^[^\n]+/<p>&<\/p>/
        }
        P
        D
    }
}

# Headers

s/^ *(\#+) *(.*[^#])[# ]*$/\1 \2/

h
x
s/^[# ]+ ([[:alnum:] -]*).*$/\L\1/
s/[^[:alnum:]]+/-/g
s/-+$//

H
s/.*//
x

s/^#{6} (.*)\n(.*)$/<h6 id="\2">\1<\/h6>/
s/^#{5} (.*)\n(.*)$/<h5 id="\2">\1<\/h5>/
s/^#{4} (.*)\n(.*)$/<h4 id="\2">\1<\/h4>/
s/^#{3} (.*)\n(.*)$/<h3 id="\2">\1<\/h3>/
s/^#{2} (.*)\n(.*)$/<h2 id="\2">\1<\/h2>/
s/^# (.*)\n(.*)$/<h1 id="\2">\1<\/h1>/

s/\n+//g
