# md-to-html

**To fix**

 - Not working well when lists of a different type are nested together.

**Limitations**

 - Inline HTML is likely never to be supported. You can add three backticks *(\`\`\`)* at each end of the block instead.
 - Every word surrounded by two colons *(:likethis:)* is assumed to be an emoji and thus becomes a unicode star.
 - Links that are referenced by using brackets are not supported.

## How to try this script

Run this from your terminal:

```shell
git clone https://github.com/stamby/md-to-html
cd md-to-html
chmod +x md-to-html.sed
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
 
