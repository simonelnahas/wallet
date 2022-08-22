defmodule InMemoryEventStoreCase do
  use ExUnit.CaseTemplate

  alias Commanded.EventStore.Adapters.InMemory

  setup do
    {:ok, _apps} = Application.ensure_all_started(:wallet)

    on_exit(fn ->
      :ok = Application.stop(:wallet)
    end)
  end
end
