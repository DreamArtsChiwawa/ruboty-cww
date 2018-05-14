# Ruboty::Cww

Chiwawa adapter for [Ruboty](https://github.com/r7kamura/ruboty).

## Usage
Get your Chiwawa API Token

``` ruby
# Gemfile
gem 'ruboty-cww'
```

## ENV

```
CHIWAWA_COMPANY_ID,         - 知話輪から発行されたINSUITEの企業別ID
CHIWAWA_API_TOKEN,          - 知話輪管理画面から発行したBOTのAPI利用トークン
CHIWAWA_VERIFY_TOKEN,       - 知話輪管理画面から発行したBOTのWebhook検証トークン
CHIWAWA_BOT_USER_ID,        - 知話輪管理画面から発行したBOTのユーザID
CHIWAWA_BOT_USER_NAME,      - 知話輪管理画面から発行したBOTのユーザ名
CHIWAWA_GROUP_ID,           - BOTが所属するグループID
CHIWAWA_GROUP_NAME,         - BOTが所属するグループ名
```