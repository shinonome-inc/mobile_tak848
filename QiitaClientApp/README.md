# QiitaClientApp
## アクセストークン・スキームの登録
方法は2通りあります。スキームも環境変数で設定できます。読み込み時のInfo.plistが変更されるため，git管理下のInfo.plistが書き変わることはありません。
1. `QiitaClientApp/QiitaClientApp/`内に[僕の作成した.env](https://drive.google.com/file/d/1CB4nYrYnslMXTpRj_K5Ao3pVzg16VQf6/view?usp=sharing)を放り込む。
2.  * `QiitaClientApp/QiitaClientApp/`内に`example.env`があるので，同じ場所に`.env`という名前でコピー。リダイレクト先URLを`APPLICATION_URL_SCHEME://APPLICATION_QIITA_CALLBACK_HOST`となるように[Qiitaのアプリケーションを登録](https://qiita.com/settings/applications/new)して，クライアントIDとクライアントsecretも`.env`に記入し保存する。
    * 例
    <img width="472" alt="Screen Shot 2022-03-17 at 14 04 01" src="https://user-images.githubusercontent.com/41906969/158741205-0f1bf0aa-01ee-488b-8b7b-177ca1ec0529.png">
    <img width="778" alt="Screen Shot 2022-03-17 at 14 04 15" src="https://user-images.githubusercontent.com/41906969/158741216-12b2d927-d65d-45cb-b9f8-b88418a5b225.png">
