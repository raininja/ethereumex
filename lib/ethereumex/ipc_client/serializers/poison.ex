defmodule Ethereumex.IpcClient.Serializers.Poison do
  @moduledoc false

  def decode(json) do
    try do
      {:ok, :poison.decode(json, [:return_maps, :use_nil])}
    catch
      kind, payload -> {:error, {kind, payload}}
    end
  end

  def encode(json) do
    try do
      {:ok, :poison.encode(json, [:use_nil])}
    catch
      kind, payload -> {:error, {kind, payload}}
    end
  end
end
