defmodule Ethereumex.IpcClient do
  use Ethereumex.Client.Macro
  import Ethereumex.Config

  if Code.ensure_loaded?(:shackle_client) do
  @behaviour :shackle_client
  end
  @moduledoc false

  # require Logger

  def init do
    # serializer = Application.get_env(:ethereumex)
    {:ok, %{request_counter: 0}}
  end

  def setup(_socket, state) do
    {:ok, state}
  end

  @spec single_request(map()) :: {:ok, any() | [any()]} | error
  def single_request(payload) do
    payload
    |> encode_payload
    |> post_request
  end

  @spec encode_payload(map()) :: binary()
  defp encode_payload(payload) do
    payload |> Poison.encode!()
  end

  @spec post_request(binary()) :: {:ok | :error, any()}
  defp post_request(payload) do
    options = Ethereumex.Config.ipc_client_options()

    # with {:ok, response} <- IpcClient.Client.post(socket(), payload, headers, options),
    with
         %Poison.Response{body: body, status_code: code} = response do
      decode_body(body, code)
    else
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      e -> {:error, e}
    end
  end

def handle_request({:call, method, params, string_id}, state) do
  external_request_id_int = external_request_id(state.request_counter)

  external_request_id =
    if string_id do
      Integer.to_string(external_request_id_int)
    else
      external_request_id_int
    end

  {:ok, data} =
    {method, params, external_request_id}
    |> Ethereumex.Request.serialized_request(state.serializer)

  new_state = %{state | request_counter: external_request_id_int + 1}
  {:ok, external_request_id, [data, "\r\n"], new_state}
end

def handle_request({:notify, method, params}, state) do
  {:ok, data} = Ethereumex.Request.serialized_request({method, params}, state.serializer)

  {:ok, nil, [data, "\r\n"], state}
end

def handle_data(data, state) do
  case Ethereumex.Response.deserialize_response(data, state.serializer) do
    {:ok, {nil, result}} ->
      _ =
        Logger.error([
          inspect(__MODULE__),
          " received response with null ID: ",
          inspect(result)
        ])

      {:ok, [], state}

    {:ok, {id, result}} ->
      {:ok, [{id, result}], state}

    {:error, error} ->
      _ =
        Logger.error([
          inspect(__MODULE__),
          " received invalid response, error: ",
          inspect(error)
        ])

      {:ok, [], state}
  end
end

def terminate(_state) do
  :ok
end

defp external_request_id(request_counter) do
  rem(request_counter, 2_147_483_647)
end
end

# defmodule JSONRPC2.Clients.TCP do
#   @moduledoc """
#   A client for JSON-RPC 2.0 using a line-based TCP transport.
#   """
#
#   alias JSONRPC2.Clients.TCP.Protocol

  @default_timeout 5_000

  @type host :: binary | :inet.socket_address() | :inet.hostname()

  @type request_id :: any

  @type call_option ::
          {:string_id, boolean}
          | {:timeout, pos_integer}

  @type call_options :: [call_option]

  @type cast_options :: [{:string_id, boolean}]

  @doc """
  Start a client pool named `name`, connected to `host` at `port`.

  You can optionally pass `client_opts`, detailed
  [here](https://github.com/lpgauth/shackle#client_options), as well as `pool_opts`, detailed
  [here](https://github.com/lpgauth/shackle#pool_options).
  """
  @spec start(host, :inet.port_number(), atom, Keyword.t(), Keyword.t()) :: :ok
  def start(host, port, name, client_opts \\ [], pool_opts \\ []) do
    host = if is_binary(host), do: to_charlist(host), else: host

    ip =
      case host do
        host when is_list(host) ->
          case :inet.parse_address(host) do
            {:ok, ip} -> ip
            {:error, :einval} -> host
          end

        host ->
          host
      end

    client_opts = Keyword.merge([ip: ip, port: port, socket_options: [:binary, packet: :line]], client_opts)
    :shackle_pool.start(name, Protocol, client_opts, pool_opts)
  end

  @doc """
  Stop the client pool with name `name`.
  """
  @spec stop(atom) :: :ok | {:error, :shackle_not_started | :pool_not_started}
  def stop(name) do
    :shackle_pool.stop(name)
  end

  @doc """
  Call the given `method` with `params` using the client pool named `name` with `options`.

  You can provide the option `string_id: true` for compatibility with pathological implementations,
  to force the request ID to be a string.

  You can also provide the option `timeout: 5_000` to set the timeout to 5000ms, for instance.

  For backwards compatibility reasons, you may also provide a boolean for the `options` parameter,
  which will set `string_id` to the given boolean.
  """
  @spec call(atom, ethereumex.method(), ethereumex.params(), boolean | call_options) ::
          {:ok, any} | {:error, any}
  def call(name, method, params, options \\ [])

  def call(name, method, params, string_id) when is_boolean(string_id) do
    call(name, method, params, string_id: string_id)
  end

  def call(name, method, params, options) do
    string_id = Keyword.get(options, :string_id, false)
    timeout = Keyword.get(options, :timeout, @default_timeout)

    :shackle.call(name, {:call, method, params, string_id}, timeout)
  end

  @doc """
  Asynchronously call the given `method` with `params` using the client pool named `name` with
  `options`.

  Use `receive_response/1` with the `request_id` to get the response.

  You can provide the option `string_id: true` for compatibility with pathological implementations,
  to force the request ID to be a string.

  You can also provide the option `timeout: 5_000` to set the timeout to 5000ms, for instance.

  Additionally, you may provide the option `pid: self()` in order to specify which process should
  be sent the message which is returned by `receive_response/1`.

  For backwards compatibility reasons, you may also provide a boolean for the `options` parameter,
  which will set `string_id` to the given boolean.
  """
  @spec cast(atom, ethereumex.method(), ethereumex.params(), boolean | cast_options) ::
          {:ok, request_id} | {:error, :backlog_full}
  def cast(name, method, params, options \\ [])

  def cast(name, method, params, string_id) when is_boolean(string_id) do
    cast(name, method, params, string_id: string_id)
  end

  def cast(name, method, params, options) do
    string_id = Keyword.get(options, :string_id, false)
    timeout = Keyword.get(options, :timeout, @default_timeout)
    pid = Keyword.get(options, :pid, self())

    :shackle.cast(name, {:call, method, params, string_id}, pid, timeout)
  end

  @doc """
  Receive the response for a previous `cast/3` which returned a `request_id`.
  """
  @spec receive_response(request_id) :: {:ok, any} | {:error, any}
  def receive_response(request_id) do
    :shackle.receive_response(request_id)
  end

  @doc """
  Send a notification with the given `method` and `params` using the client pool named `name`.

  This function returns a `request_id`, but it should not be used with `receive_response/1`.
  """
  @spec notify(atom, ethereumex.method(), ethereumex.params()) :: {:ok, request_id} | {:error, :backlog_full}
  def notify(name, method, params) do
    # Spawn a dead process so responses go to /dev/null
    pid = spawn(fn -> :ok end)
    :shackle.cast(name, {:notify, method, params}, pid, 0)
  end
end
# #
# # -record(state, {
# #     buffer =       <<>> :: binary(),
# #     request_counter = 0 :: non_neg_integer()
# # }).
# #
# # -spec init(Options :: term()) ->
# #     {ok, State :: term()} |
# #     {error, Reason :: term()}.
# #
# # init(_Options) ->
# #     {ok, #state {}}.
# #
# # -spec setup(Socket :: inet:socket(), State :: term()) ->
# #     {ok, State :: term()} |
# #     {error, Reason :: term(), State :: term()}.
# #
# # setup(Socket, State) ->
# #     case gen_tcp:send(Socket, <<"INIT">>) of
# #         ok ->
# #             case gen_tcp:recv(Socket, 0) of
# #                 {ok, <<"OK">>} ->
# #                     {ok, State};
# #                 {error, Reason} ->
# #                     {error, Reason, State}
# #             end;
# #         {error, Reason} ->
# #             {error, Reason, State}
# #     end.
# #
# # -spec handle_request(Request :: term(), State :: term()) ->
# #     {ok, RequestId :: external_request_id(), Data :: iodata(), State :: term()}.
# #
# # handle_request({Operation, A, B}, #state {
# #         request_counter = RequestCounter
# #     } = State) ->
# #
# #     RequestId = request_id(RequestCounter),
# #     Data = request(RequestId, Operation, A, B),
# #
# #     {ok, RequestId, Data, State#state {
# #         request_counter = RequestCounter + 1
# #     }}.
# #
# # -spec handle_data(Data :: binary(), State :: term()) ->
# #     {ok, [{RequestId :: external_request_id(), Reply :: term()}], State :: term()}.
# #
# # handle_data(Data, #state {
# #         buffer = Buffer
# #     } = State) ->
# #
# #     Data2 = <<Buffer/binary, Data/binary>>,
# #     {Replies, Buffer2} = parse_replies(Data2, []),
# #
# #     {ok, Replies, State#state {
# #         buffer = Buffer2
# #     }}.
# #
# # -spec terminate(State :: term()) -> ok.
# #
# # terminate(_State) -> ok.
