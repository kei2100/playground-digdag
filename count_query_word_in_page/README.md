# count_query_word_in_page

特定キーワードでgoogle検索し、TOP3のページから、キーワードの出現回数を取得するDigdag workflow。Digdagの機能確認でやってるので、この処理内容に価値はない。

## memo

```
Digdag v0.8.21
```
で動かした

## How to play

### Install Digdag

```
$ curl -o ~/bin/digdag --create-dirs -L "https://dl.digdag.io/digdag-latest"
$ chmod +x ~/bin/digdag
$ echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
$ source ~/.bashrc
```

### Install gems

```
$ cd count_query_word_in_page
$ bundle install --path=vendor/bundle
```

### Run digdag

```
$ cd count_query_word_in_page
$ digdag run -a -l error count_query_word_in_page.dig
```
