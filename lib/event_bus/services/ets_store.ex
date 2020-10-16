defmodule EventBus.Service.EtsStore do
  @behaviour EventBus.Service.Store
  @moduledoc false

  require Logger

  alias EventBus.Model.Event
  alias EventBus.Service.Store, as: StoreService
  alias :ets, as: Ets

  @ets_opts [:set, :public, :named_table, {:read_concurrency, true}]
  @prefix "eb_es_"

  @doc false
  @impl StoreService
  def exist?(topic) do
    table_name = table_name(topic)
    all_tables = Ets.all()
    Enum.any?(all_tables, fn table -> table == table_name end)
  end

  @doc false
  @impl StoreService
  def register_topic(topic) do
    unless exist?(topic), do: Ets.new(table_name(topic), @ets_opts)
    :ok
  end

  @doc false
  @impl StoreService
  def unregister_topic(topic) do
    if exist?(topic), do: Ets.delete(table_name(topic))
    :ok
  end

  @doc false
  @impl StoreService
  def fetch({topic, id}) do
    case Ets.lookup(table_name(topic), id) do
      [{_, %Event{} = event}] -> event
      _ ->
        Logger.log(:info, fn ->
          "[EVENTBUS][STORE]\s#{topic}.#{id}.ets_fetch_error"
        end)

        nil
    end
  end

  @doc false
  @impl StoreService
  def fetch_data({topic, id}) do
    event = fetch({topic, id}) || %{}
    Map.get(event, :data)
  end

  @doc false
  @impl StoreService
  def delete({topic, id}) do
    Ets.delete(table_name(topic), id)
    :ok
  end

  @doc false
  @impl StoreService
  def create(%Event{id: id, topic: topic} = event) do
    Ets.insert(table_name(topic), {id, event})
    :ok
  end

  defp table_name(topic) do
    String.to_atom("#{@prefix}#{topic}")
  end
end
