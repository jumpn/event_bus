defmodule EventBus.Service.Store do

  @typep event :: EventBus.event()
  @typep event_shadow :: EventBus.event_shadow()
  @typep topic :: EventBus.topic()

  @callback exist?(topic()) :: boolean()
  @callback register_topic(topic()) :: :ok
  @callback unregister_topic(topic()) :: :ok

  @callback create(event()) :: :ok
  @callback fetch(event_shadow()) :: event() | nil
  @callback fetch_data(event_shadow()) :: any()
  @callback delete(event_shadow()) :: :ok
end
