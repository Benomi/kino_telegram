# KinoTelegram

[![Docs](https://img.shields.io/badge/hex.pm-docs-8e7ce6.svg)](https://hexdocs.pm/kino_telegram)
[![Actions Status](https://github.com/benomi/kino_telegram/workflows/Test/badge.svg)](https://github.com/benomi/kino_telegram/actions)

Telegram integration with [Kino](https://github.com/livebook-dev/kino)
for [Livebook](https://github.com/livebook-dev/livebook).

This project is heavily inspired from [:kino_slack](https://github.com/livebook-dev/kino_slack).

## Installation

To bring KinoTelegram to Livebook all you need to do is `Mix.install/2`:

```elixir
Mix.install([
  {:kino_telegram, "~> 0.1.0"}
])
```

## Get started

- Create a Telegram bot ([see doc](https://core.telegram.org/bots#how-do-i-create-a-bot)) & copy the **bot token**

- Add the bot to your Telegram channel/group with message sending rights

- If your channel/group is public, you can use the **username** of your channel/group as the **id** of your channel/group if not:
  - To get the **id** of your channel/group:
    - First send a message to the channel/group
    - Then go to this URL `https://api.telegram.org/bot<your-bot-token>/getUpdates` (replace `<your-bot-token>` with your bot token)
    - Copy the `chat.id` value of your channel/group

- Create a "Telegram message" smart cell in your Livebook and fill in the channel/group id(username) & bot token

## License

Copyright (C) 2023  Binyam T. Fisseha

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
