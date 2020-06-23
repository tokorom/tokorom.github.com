---
title: "Github ActionsからSlackへ通知するのを良い感じにしたい"
date: 2020-05-13T17:26:38+09:00
draft: false
authors: [tokorom]
tags: [GitHub,Slack]
images: [/images/github-actions-context/github-actions.png]
canonical: https://spinners.work
---

![image](/images/github-actions-context/github-actions.png)

この記事は`push`をトリガーとしたGitHub Actionsのワークフローを前提として書いています。

## 概要

GitHub Actions、簡単便利で良いですね！

ぼくも遅まきながら使いはじめ、先日、Git pushをトリガーにデプロイしてSlackで通知、とよくあるワークフローを追加して運用しはじめました。

Slackへの通知も [Marketplace](https://github.com/marketplace?type=actions&query=slack) に数ある既存Actionを選んで利用すれば、すぐに実現できました。すごい！

## ぼくはこんな感じにしたかった

とはいえ、贅沢を言えば、ぼくは

- レガシーなCustom integrationsのIncoming Webhooksでなく、きちんと新しいIncoming Webhooksでやりたい
    - ref: https://api.slack.com/legacy/custom-integrations#incoming-webhooks
- Action独自のパラメータでなくSlackが定義している`Message payloads`のフィールドをそのまま指定したい
    - ref: https://api.slack.com/reference/messaging/payload
- GitHubで変更差分を見るためのURLを追加したりとか、お好みでカスタムしたい

と思い、意外とそれが叶う既存Actionが見つからなかったため、GitHub Actionsを作る練習も兼ねて、自作することにしました。

作ったActionは https://github.com/marketplace/actions/slack-incoming-webhook です。

## 実際の通知

### テキストメッセージ送るだけ

テキストメッセージを送るだけなら、どのActionを使っても同じようなものですが、こんな感じに

- Incoming WebhookのURLをenvに指定
- `text`フィールドを指定
    - フィールド名を [SlackのPayloadの仕様](https://api.slack.com/reference/messaging/payload) に合わせてます

の２つだけ設定すると、

```yml
- name: Slack Notification
  uses: tokorom/action-slack-incoming-webhook@master
  env:
    INCOMING_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
  with:
    text: Hello, Slack!
```

![image](/images/github-actions-context/sample-simple.png)

こんな感じにSlackにメッセージを送れます。

### いろいろカスタム

次に、`text`だけでなく、`attachments`フィールドも指定して、

- 成功ならgreenなど色をつける
- pushした人の名前やアイコンも表示する
- GitHub Actionsの該当のワークフローへのリンクをつける
- 変更差分を見るためのCompareページへのリンクをつける

といろいろカスタムしてみます。

```yml
- name: Set COMMIT_MESSAGE
  run: echo ::set-env name=COMMIT_MESSAGE::$(echo "${{ github.event.head_commit.message }}" | tr '\n' ' ')
- name: Slack Notification on SUCCESS
  if: success()
  uses: tokorom/action-slack-incoming-webhook@master
  env:
    INCOMING_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
  with:
    text: Successfully automated deployment.
    attachments: |
      [
        {
          "color": "good",
          "author_name": "${{ github.actor }}",
          "author_icon": "${{ github.event.sender.avatar_url }}",
          "fields": [
            {
              "title": "Commit Message",
              "value": "${{ env.COMMIT_MESSAGE }}"
            },
            {
              "title": "GitHub Actions URL",
              "value": "${{ github.event.repository.url }}/actions/runs/${{ github.run_id }}"
            },
            {
              "title": "Compare URL",
              "value": "${{ github.event.compare }}"
            }
          ]
        }
      ]
```

![image](/images/github-actions-context/sample-advanced.png)

この設定を使うと、こんな感じにカスタムしたメッセージも送れます。

## 指定できるフィールド（Inputs）

指定できるフィールド（Inputs）は、現在、Slackが [Message payloads](https://api.slack.com/reference/messaging/payload) に明記している

- `text`
- `blocks`
- `attachments`
- `thread_ts`
- `mrkdwn`

の５つです。

`attachments`や`blocks`にJSONフォーマットでなんでも指定できますので、実質、どんなメッセージも表現できるはずです。

## ほんとは...

なお、`attachments`や`blocks`にJSONを指定するのは、ほんとはやりたくなくて、はじめは、

```yml
with:
  text: Successfully automated deployment.
  attachments:
    - color: good
      author_name: ${{ github.actor }}
      author_icon: ${{ github.event.sender.avatar_url }}
      fields:
        - title: Commit Message
          value: ${{ env.COMMIT_MESSAGE }}
```

とYamlのまま子要素も指定させるつもりでした。

ただ、現状、GitHub ActionsのInputsには文字列しか指定できず、上の指定のしかたを受け入れてくれないため、しかたなくJSONの文字列を指定するようにしています。

## GitHub Actionsで利用できるコンテキスト

ところで、上のワークフローの設定例では、

```yml
author_icon: ${{ github.event.sender.avatar_url }}
```

で`push`した人のアイコンを表示したりしていますが、これは、GitHub Actionsで利用できる`github`コンテキストをdumpしてたまたま見つけたものです。

これらコンテキストについての情報は https://help.github.com/ja/actions/reference/context-and-expression-syntax-for-github-actions にきちんと書かれているのですが、`github.event`の中身に具体的にどんな値が入っているか、など詳細については今のところ明記されていません。

しかし、このドキュメントでは「各コンテキストをdumpして実際にどんな値が使えるか調べられるよ」と紹介されています。

以下が実際に `push`をトリガーとした場合の`github`コンテキストの中身をdumpしたものです。

```js
{
  "token": "***",
  "job": "deploy",
  "ref": "refs/heads/master",
  "sha": "8a58cb9b359c49b7f2ab604c53a6944dcc221dff",
  "repository": "tokorom/github-actions-sandbox",
  "repository_owner": "tokorom",
  "repositoryUrl": "git://github.com/tokorom/github-actions-sandbox.git",
  "run_id": "103131997",
  "run_number": "2",
  "actor": "tokorom",
  "workflow": "sandbox",
  "head_ref": "",
  "base_ref": "",
  "event_name": "push",
  "event": {
    "after": "8a58cb9b359c49b7f2ab604c53a6944dcc221dff",
    "base_ref": null,
    "before": "ea89168554cf912efd3bf2a08b6e2cbd95db2b66",
    "commits": [
      {
        "author": {
          "email": "tokorom@gmail.com",
          "name": "tokorom",
          "username": "tokorom"
        },
        "committer": {
          "email": "tokorom@gmail.com",
          "name": "tokorom",
          "username": "tokorom"
        },
        "distinct": true,
        "id": "8a58cb9b359c49b7f2ab604c53a6944dcc221dff",
        "message": "更新テスト",
        "timestamp": "2020-05-13T11:06:38+09:00",
        "tree_id": "36a30d1029ee63104706e57357a9db8de0ac535b",
        "url": "https://github.com/tokorom/github-actions-sandbox/commit/8a58cb9b359c49b7f2ab604c53a6944dcc221dff"
      }
    ],
    "compare": "https://github.com/tokorom/github-actions-sandbox/compare/ea89168554cf...8a58cb9b359c",
    "created": false,
    "deleted": false,
    "forced": false,
    "head_commit": {
      "author": {
        "email": "tokorom@gmail.com",
        "name": "tokorom",
        "username": "tokorom"
      },
      "committer": {
        "email": "tokorom@gmail.com",
        "name": "tokorom",
        "username": "tokorom"
      },
      "distinct": true,
      "id": "8a58cb9b359c49b7f2ab604c53a6944dcc221dff",
      "message": "更新テスト",
      "timestamp": "2020-05-13T11:06:38+09:00",
      "tree_id": "36a30d1029ee63104706e57357a9db8de0ac535b",
      "url": "https://github.com/tokorom/github-actions-sandbox/commit/8a58cb9b359c49b7f2ab604c53a6944dcc221dff"
    },
    "pusher": {
      "email": "tokorom@gmail.com",
      "name": "tokorom"
    },
    "ref": "refs/heads/master",
    "repository": {
      "archive_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/{archive_format}{/ref}",
      "archived": false,
      "assignees_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/assignees{/user}",
      "blobs_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/git/blobs{/sha}",
      "branches_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/branches{/branch}",
      "clone_url": "https://github.com/tokorom/github-actions-sandbox.git",
      "collaborators_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/collaborators{/collaborator}",
      "comments_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/comments{/number}",
      "commits_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/commits{/sha}",
      "compare_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/compare/{base}...{head}",
      "contents_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/contents/{+path}",
      "contributors_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/contributors",
      "created_at": 1589333793,
      "default_branch": "master",
      "deployments_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/deployments",
      "description": "所がGitHub Actionsを試すお砂場",
      "disabled": false,
      "downloads_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/downloads",
      "events_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/events",
      "fork": false,
      "forks": 0,
      "forks_count": 0,
      "forks_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/forks",
      "full_name": "tokorom/github-actions-sandbox",
      "git_commits_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/git/commits{/sha}",
      "git_refs_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/git/refs{/sha}",
      "git_tags_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/git/tags{/sha}",
      "git_url": "git://github.com/tokorom/github-actions-sandbox.git",
      "has_downloads": true,
      "has_issues": true,
      "has_pages": false,
      "has_projects": true,
      "has_wiki": true,
      "homepage": null,
      "hooks_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/hooks",
      "html_url": "https://github.com/tokorom/github-actions-sandbox",
      "id": 263495697,
      "issue_comment_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/issues/comments{/number}",
      "issue_events_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/issues/events{/number}",
      "issues_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/issues{/number}",
      "keys_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/keys{/key_id}",
      "labels_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/labels{/name}",
      "language": null,
      "languages_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/languages",
      "license": null,
      "master_branch": "master",
      "merges_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/merges",
      "milestones_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/milestones{/number}",
      "mirror_url": null,
      "name": "github-actions-sandbox",
      "node_id": "MDEwOlJlcG9zaXRvcnkyNjM0OTU2OTc=",
      "notifications_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/notifications{?since,all,participating}",
      "open_issues": 0,
      "open_issues_count": 0,
      "owner": {
        "avatar_url": "https://avatars2.githubusercontent.com/u/629993?v=4",
        "email": "tokorom@gmail.com",
        "events_url": "https://api.github.com/users/tokorom/events{/privacy}",
        "followers_url": "https://api.github.com/users/tokorom/followers",
        "following_url": "https://api.github.com/users/tokorom/following{/other_user}",
        "gists_url": "https://api.github.com/users/tokorom/gists{/gist_id}",
        "gravatar_id": "",
        "html_url": "https://github.com/tokorom",
        "id": 629993,
        "login": "tokorom",
        "name": "tokorom",
        "node_id": "MDQ6VXNlcjYyOTk5Mw==",
        "organizations_url": "https://api.github.com/users/tokorom/orgs",
        "received_events_url": "https://api.github.com/users/tokorom/received_events",
        "repos_url": "https://api.github.com/users/tokorom/repos",
        "site_admin": false,
        "starred_url": "https://api.github.com/users/tokorom/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/tokorom/subscriptions",
        "type": "User",
        "url": "https://api.github.com/users/tokorom"
      },
      "private": false,
      "pulls_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/pulls{/number}",
      "pushed_at": 1589335611,
      "releases_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/releases{/id}",
      "size": 0,
      "ssh_url": "git@github.com:tokorom/github-actions-sandbox.git",
      "stargazers": 0,
      "stargazers_count": 0,
      "stargazers_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/stargazers",
      "statuses_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/statuses/{sha}",
      "subscribers_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/subscribers",
      "subscription_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/subscription",
      "svn_url": "https://github.com/tokorom/github-actions-sandbox",
      "tags_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/tags",
      "teams_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/teams",
      "trees_url": "https://api.github.com/repos/tokorom/github-actions-sandbox/git/trees{/sha}",
      "updated_at": "2020-05-13T02:00:26Z",
      "url": "https://github.com/tokorom/github-actions-sandbox",
      "watchers": 0,
      "watchers_count": 0
    },
    "sender": {
      "avatar_url": "https://avatars2.githubusercontent.com/u/629993?v=4",
      "events_url": "https://api.github.com/users/tokorom/events{/privacy}",
      "followers_url": "https://api.github.com/users/tokorom/followers",
      "following_url": "https://api.github.com/users/tokorom/following{/other_user}",
      "gists_url": "https://api.github.com/users/tokorom/gists{/gist_id}",
      "gravatar_id": "",
      "html_url": "https://github.com/tokorom",
      "id": 629993,
      "login": "tokorom",
      "node_id": "MDQ6VXNlcjYyOTk5Mw==",
      "organizations_url": "https://api.github.com/users/tokorom/orgs",
      "received_events_url": "https://api.github.com/users/tokorom/received_events",
      "repos_url": "https://api.github.com/users/tokorom/repos",
      "site_admin": false,
      "starred_url": "https://api.github.com/users/tokorom/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/tokorom/subscriptions",
      "type": "User",
      "url": "https://api.github.com/users/tokorom"
    }
  },
  "workspace": "/home/runner/work/github-actions-sandbox/github-actions-sandbox",
  "action": "run1",
  "event_path": "/home/runner/work/_temp/_github_workflow/event.json"
}
```

これを見ていると「最新のcommitメッセージは`github.event.head_commit.message`で参照できるぞ」など、楽しくなってきますね！

それでは、ぜひ https://github.com/marketplace/actions/slack-incoming-webhook を使って、GitHub ActionsからのSlack通知をお好みにカスタマイズしてみてください！
