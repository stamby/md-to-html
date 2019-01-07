# Welcome to this web site

## Index

1. [What this page is all about](#what-this-page-is-all-about)
2. [Other nonsense](#other-nonsense)

## What this page is all about

Nothing in particular, just a demo to see how the
[md-to-html](https://github.com/stamby/md-to-html) script works when dealing
with an indexed list.

If you are familiar with HTML syntax, you might or might not know that the ID
field makes some tags into bookmarks. If run under GNU Sed, this script will
automatically add them to whatever headers you write in your text to make it
easy for you to reference those headers later. Links, however, must be added
manually and their syntax has to follow this pattern:

```
[link](#bookmark)
[link](http://example.com/#bookmark)
```

If there's a header called "bookmark" anywhere in the linked address, no matter
what level that header is, this link will redirect to it. Keep in mind that
every character in the ID field that is neither a letter nor a number becomes a
dash, and then the extra dashes are removed from the edges.

A header that looks like this, when written in Markdown:

```
### Header 3? :star:
```

Will transform into this, once it goes through the editor:

```
<h3 id="header-3">Header 3? &#x2B50;</h3>
```

And if you wanted to add a link to it, it would look like this:

```
[go to header 3](#header-3)
```

[Back to index](#index)

## Other nonsense

KKKKkkkkkkk. This part isn't important.

[Back to index](#index)

