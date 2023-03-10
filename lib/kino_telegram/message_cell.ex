defmodule KinoTelegram.MessageCell do
  @moduledoc false

  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "Telegram message"

  @impl true
  def init(attrs, ctx) do
    fields = %{
      "token_secret_name" => attrs["token_secret_name"] || "",
      "chat_id" => attrs["chat_id"] || "",
      "message" => attrs["message"] || ""
    }

    ctx = assign(ctx, fields: fields)
    {:ok, ctx}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{fields: ctx.assigns.fields}, ctx}
  end

  @impl true
  def handle_event("update_chat_id", value, ctx) do
    ctx = update(ctx, :fields, &Map.merge(&1, %{"chat_id" => value}))
    {:noreply, ctx}
  end

  @impl true
  def handle_event("update_message", value, ctx) do
    ctx = update(ctx, :fields, &Map.merge(&1, %{"message" => value}))
    {:noreply, ctx}
  end

  @impl true
  def handle_event("update_token_secret_name", value, ctx) do
    broadcast_event(ctx, "update_token_secret_name", value)
    ctx = update(ctx, :fields, &Map.merge(&1, %{"token_secret_name" => value}))
    {:noreply, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    ctx.assigns.fields
  end

  @impl true
  def to_source(attrs) do
    required_fields = ~w(token_secret_name chat_id message)

    if all_fields_filled?(attrs, required_fields) do
      quote do
        req = Req.new(base_url: "https://api.telegram.org")

        bot_token = System.fetch_env!(unquote("LB_#{attrs["token_secret_name"]}"))
        chat_id = unquote(attrs["chat_id"])
        message = unquote(attrs["message"])

        url = "/bot#{bot_token}/sendMessage"

        response = Req.post!(req, url: url, form: [chat_id: chat_id, text: message])

        case response.body do
          %{"ok" => true} -> :ok
          %{"ok" => false, "error" => error} -> {:error, error}
        end
      end
      |> Kino.SmartCell.quoted_to_string()
    else
      ""
    end
  end

  def all_fields_filled?(attrs, keys) do
    Enum.all?(keys, fn key -> attrs[key] not in [nil, ""] end)
  end
end
