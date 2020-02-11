defmodule Talos.Types.FloatType do
  @moduledoc """
  Type for check value is float

  For example:
  ```elixir

    iex> percents = %Talos.Types.FloatType{gteq: 0, lteq: 100}
    iex> Talos.valid?(percents, 42.0)
    true
    iex>Talos.valid?(percents, 136.0)
    false

  ```

  Additional parameters:

  `allow_nil` - allows value to be nil

  `allow_blank` - allows value to be blank (0.0)

  `gteq` - greater than or equal, same as `>=`

  `lteq` - lower than or equal, same as `<=`

  `gt` - lower than, same as `>`

  `lt` - lower than, same as `<`
  """
  defstruct [:gteq, :lteq, :gt, :lt, allow_nil: false, allow_blank: false]

  @type t :: %{
          __struct__: atom,
          gteq: float,
          lteq: float,
          gt: float,
          lt: float,
          allow_blank: boolean,
          allow_nil: boolean
        }

  alias Talos.Types.NumberType
  @behaviour Talos.Types

  @spec valid?(Talos.Types.FloatType.t(), any) :: boolean
  def valid?(module, value) do
    errors(module, value) == []
  end

  def errors(%__MODULE__{allow_blank: true}, 0.0) do
    []
  end

  def errors(%__MODULE__{allow_nil: true}, nil) do
    []
  end

  def errors(type, value) do
    type
    |> wrap_type()
    |> NumberType.errors(value)
  end

  defp wrap_type(%__MODULE__{gteq: gteq, lteq: lteq, gt: gt, lt: lt}) do
    %NumberType{gteq: gteq, lteq: lteq, gt: gt, lt: lt, type: :float}
  end
end
