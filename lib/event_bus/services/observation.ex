defmodule EventBus.Service.Observation do

  @typep event_shadow :: EventBus.event_shadow()
  @typep subscribers :: EventBus.subscribers()
  @typep subscriber_with_event_ref :: EventBus.subscriber_with_event_ref()
  @typep topic :: EventBus.topic()
  @typep watcher :: {subscribers(), subscribers(), subscribers()}

  @callback exist?(topic()) :: boolean()
  @callback register_topic(topic()) :: :ok
  @callback unregister_topic(topic()) :: :ok
  @callback mark_as_completed(subscriber_with_event_ref()) :: :ok
  @callback mark_as_skipped(subscriber_with_event_ref()) :: :ok
  @callback fetch(event_shadow()) :: {subscribers(), subscribers(), subscribers()} | nil
  @callback save(event_shadow(), watcher()) :: :ok
end
