# slack bot
## セットアップ  
いろいろライブラリをよんでいるので、ターミナルで以下のコマンドをうってください。
```
bundle install
```
`bundle`がないと言われたら`gem`なり`bundler`なりを入れてください。

環境変数として以下のものを設定してください
```
PGRP_ID=(p-grpのホームページに入るためのid)
PGRP_PASS=(p-grpのホームページに入るためのpassword)
SLACKBOT_TOKEN=(Slackのボットにアクセスするためのtoken)
```

## 使用方法
`bot.rb`がmainなので
```
ruby bot.rb
```
と打てば、ずっとslackを監視し続けるはずです。

## 反応することば
全部`@ruby_bot `の後に続けてください。

今日　=>　今日の全体の予定を返します。  
mura　=>　今日の村上先生の予定を返します。  
ゼミ　=>　直近のゼミの予定を返します．
