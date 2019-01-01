# md-to-html

**Note:** combining two different types of lists does not work properly, although this is seldom used in Markdown syntax.

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
