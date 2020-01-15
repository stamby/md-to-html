# md-to-html

Following John Gruber's [Markdown syntax](https://daringfireball.net/projects/markdown/syntax) guide with some exceptions, listed below.

**To fix**

 - Not working well when numbered and unnumbered are nested together.

**Limitations**

 - Inline HTML is not supported yet.
 - Every word surrounded by two colons *(:likethis:)* is assumed to be an emoji and thus becomes a unicode star.
 - Links that are referenced by using brackets *(\[like this\] \[reference\])* are not supported.

## How to try this script

Run this from your terminal:

```shell
git clone https://github.com/stamby/md-to-html
cd md-to-html
./md-to-html.sed example.md > /tmp/example.html
```

Then open `file:///tmp/example.html` with your browser to see the result.

It also works this way on Bash:

```shell
./md-to-html.sed <<< '1. Hello!'
```

The output of that being:

```html
<ol>
<li>Hello!</li>
</ol>
```
