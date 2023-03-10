defmodule KinoTelegram.MessageCellTest do
  use ExUnit.Case

  import Kino.Test

  alias KinoTelegram.MessageCell

  setup :configure_livebook_bridge

  test "when required fields are filled in, generates source code" do
    {kino, _source} = start_smart_cell!(MessageCell, %{})

    push_event(kino, "update_token_secret_name", "TELEGRAM_BOT_TOKEN")
    push_event(kino, "update_chat_id", "channel/group id")
    push_event(kino, "update_message", "telegram message")

    assert_smart_cell_update(
      kino,
      %{
        "token_secret_name" => "TELEGRAM_BOT_TOKEN",
        "chat_id" => "channel/group id",
        "message" => "telegram message"
      },
      generated_code
    )

    expected_code = ~S"""
    req = Req.new(base_url: "https://api.telegram.org")
    bot_token = System.fetch_env!("LB_TELEGRAM_BOT_TOKEN")
    chat_id = "channel/group id"
    message = "telegram message"
    url = "/bot#{bot_token}/sendMessage"
    response = Req.post!(req, url: url, form: [chat_id: chat_id, text: message])

    case response.body do
      %{"ok" => true} -> :ok
      %{"ok" => false, "error" => error} -> {:error, error}
    end
    """

    expected_code = String.trim(expected_code)

    assert generated_code == expected_code
  end

  test "generates source code from stored attributes" do
    stored_attrs = %{
      "token_secret_name" => "TELEGRAM_BOT_TOKEN",
      "chat_id" => "channel/group id",
      "message" => "telegram message"
    }

    {_kino, source} = start_smart_cell!(MessageCell, stored_attrs)

    expected_source = ~S"""
    req = Req.new(base_url: "https://api.telegram.org")
    bot_token = System.fetch_env!("LB_TELEGRAM_BOT_TOKEN")
    chat_id = "channel/group id"
    message = "telegram message"
    url = "/bot#{bot_token}/sendMessage"
    response = Req.post!(req, url: url, form: [chat_id: chat_id, text: message])

    case response.body do
      %{"ok" => true} -> :ok
      %{"ok" => false, "error" => error} -> {:error, error}
    end
    """

    expected_source = String.trim(expected_source)

    assert source == expected_source
  end

  test "when any required field is empty, returns empty source code" do
    required_attrs = %{
      "token_secret_name" => "TELEGRAM_BOT_TOKEN",
      "chat_id" => "channel/group id",
      "message" => "telegram message"
    }

    attrs_missing_required = put_in(required_attrs["token_secret_name"], "")
    assert MessageCell.to_source(attrs_missing_required) == ""

    attrs_missing_required = put_in(required_attrs["chat_id"], "")
    assert MessageCell.to_source(attrs_missing_required) == ""

    attrs_missing_required = put_in(required_attrs["message"], "")
    assert MessageCell.to_source(attrs_missing_required) == ""
  end

  test "when telegram token secret field changes, broadcasts secret name back to client" do
    {kino, _source} = start_smart_cell!(MessageCell, %{})

    push_event(kino, "update_token_secret_name", "TELEGRAM_BOT_TOKEN")

    assert_broadcast_event(kino, "update_token_secret_name", "TELEGRAM_BOT_TOKEN")
  end
end
