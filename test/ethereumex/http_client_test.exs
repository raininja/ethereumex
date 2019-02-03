defmodule Ethereumex.HttpClientTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Ethereumex.HttpClient

  setup_all do
    HttpClient.start_link()

    :ok
  end

  @tag :web3
  describe "HttpClient.web3_client_version/0" do
    test "returns client version" do
      use_cassette "web3web3_client_version" do
        result = HttpClient.web3_client_version()

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :web3
  describe "HttpClient.web3_sha3/1" do
    test "returns sha3 of the given data" do
      use_cassette "web3_sha3" do
        result = HttpClient.web3_sha3("0x68656c6c6f20776f726c64")

        {
          :ok,
          "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"
        } = result
      end
    end
  end

  @tag :net
  describe "HttpClient.net_version/0" do
    test "returns network id" do
      use_cassette "net_version" do
        result = HttpClient.net_version()

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :net
  describe "HttpClient.net_peer_count/0" do
    test "returns number of peers currently connected to the client" do
      use_cassette "net_peer_count" do
        result = HttpClient.net_peer_count()

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :net
  describe "HttpClient.net_listening/0" do
    test "returns true" do
      use_cassette "net_listening" do
        result = HttpClient.net_listening()

        {:ok, true} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_protocol_version/0" do
    test "returns true" do
      use_cassette "eth_protocol_version" do
        result = HttpClient.eth_protocol_version()

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_syncing/1" do
    test "checks sync status" do
      use_cassette "eth_syncing" do
        {:ok, result} = HttpClient.eth_syncing()

        assert is_map(result) || is_boolean(result)
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_coinbase/1" do
    test "returns coinbase address" do
      use_cassette "eth_coinbase" do
        result = HttpClient.eth_coinbase()

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_mining/1" do
    test "checks mining status" do
      use_cassette "eth_mining" do
        result = HttpClient.eth_mining()

        {:ok, true} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_hashrate/1" do
    test "returns hashrate" do
      use_cassette "eth_hashrate" do
        result = HttpClient.eth_hashrate()

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_gas_price/1" do
    test "returns current price per gas" do
      use_cassette "eth_gas_price" do
        result = HttpClient.eth_gas_price()

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_accounts/1" do
    test "returns addresses owned by client" do
      use_cassette "eth_accounts" do
        {:ok, result} = HttpClient.eth_accounts()

        assert result |> is_list
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_block_number/1" do
    test "returns number of most recent block" do
      use_cassette "eth_block_number" do
        result = HttpClient.eth_block_number()

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_balance/3" do
    test "returns balance of given account" do
      use_cassette "eth_get_balance" do
        result = HttpClient.eth_get_balance("0x001bdcde60cb916377a3a3bf4e8054051a4d02e7")

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :skip
  describe "HttpClient.eth_get_storage_at/4" do
    test "returns value from a storage position at a given address." do
      use_cassette "eth_get_storage_at" do
        result =
          HttpClient.eth_get_balance(
            "0x001bdcde60cb916377a3a3bf4e8054051a4d02e7",
            "0x0"
          )

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_transaction_count/3" do
    test "returns number of transactions sent from an address." do
      use_cassette "eth_get_transaction_count" do
        result = HttpClient.eth_get_transaction_count("0x001bdcde60cb916377a3a3bf4e8054051a4d02e7")

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_block_transaction_count_by_hash/2" do
    test "number of transactions in a block from a block matching the given block hash" do
      use_cassette "eth_get_block_transaction_count_by_hash" do
        result =
          HttpClient.eth_get_block_transaction_count_by_hash(
            "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"
            )

        {:ok, nil} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_block_transaction_count_by_number/2" do
    test "returns number of transactions in a block from a block matching the given block number" do
      use_cassette "eth_get_block_transaction_count_by_number" do
        result = HttpClient.eth_get_block_transaction_count_by_number()

        {:ok, <<_::binary>>} = result
      end
    end
  end

  # @tag :eth
  # describe "HttpClient.eth_get_uncle_by_block_hash/2" do
  #   test "the number of uncles in a block from a block matching the given block hash" do
  #     result =
  #       HttpClient.eth_get_uncle_by_block_hash(
  #         "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"
  #       )
  #
  #     {:ok, nil} = result
  #   end
  # end
  #
  # @tag :eth
  # describe "HttpClient.eth_get_uncle_by_block_number/2" do
  #   test "the number of uncles in a block from a block matching the given block number" do
  #     result = HttpClient.eth_get_count_by_block_number()
  #
  #     {:ok, <<_::binary>>} = result
  #   end
  # end

  @tag :eth
  describe "HttpClient.eth_get_code/3" do
    test "returns code at a given address" do
      use_cassette "eth_get_code" do
        result = HttpClient.eth_get_code("0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b")

        {:ok, <<_::binary>>} = result
      end
    end
  end

  # @tag :eth_sign
  @tag :skip
  describe "HttpClient.eth_sign/3" do
    test "returns signature" do
      use_cassette "eth_sign" do
        result = HttpClient.eth_sign("0x4b6f0963088345e3b0e95af72c186dd40fa95392", "test")

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_estimate_gas/3" do
    test "estimates gas" do
      use_cassette "eth_estimate_gas" do
        data =
          "0x6060604052341561" <>
          "000f57600080fd5b60b38061001d6000396000f3006060604052" <>
          "63ffffffff7c0100000000000000000000000000000000000000" <>
          "00000000000000000060003504166360fe47b181146045578063" <>
          "6d4ce63c14605a57600080fd5b3415604f57600080fd5b605860" <>
          "0435607c565b005b3415606457600080fd5b606a6081565b6040" <>
          "5190815260200160405180910390f35b600055565b6000549056" <>
          "00a165627a7a7230582033edcee10845eead909dccb4e95bb7e4" <>
          "062e92234bf3cfaf804edbd265e599800029"

        from = "0x001bdcde60cb916377a3a3bf4e8054051a4d02e7"
        transaction = %{data: data, from: from}

        result = HttpClient.eth_estimate_gas(transaction)

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_block_by_hash/3" do
    test "returns information about a block by hash" do
      use_cassette "eth_get_block_by_hash" do
        result =
          HttpClient.eth_get_block_by_hash(
            "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238",
            true
          )

        {:ok, nil} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_block_by_number/3" do
    test "returns information about a block by number" do
      use_cassette "eth_get_block_by_number" do
        {:ok, result} = HttpClient.eth_get_block_by_number("0x1b4", true)

        assert is_nil(result) || is_map(result)
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_transaction_by_hash/2" do
    test "returns the information about a transaction by its hash" do
      use_cassette "eth_get_transaction_by_hash" do
        result =
          HttpClient.eth_get_transaction_by_hash(
            "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"
          )

        {:ok, nil} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_transaction_by_block_hash_and_index/3" do
    test "returns the information about a transaction by block hash and index" do
      use_cassette "eth_get_transaction_by_block_hash_and_index" do
        result =
          HttpClient.eth_get_transaction_by_block_hash_and_index(
            "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238",
            "0x0"
            )

        {:ok, nil} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_transaction_by_block_number_and_index/3" do
    test "returns the information about a transaction by block number and index" do
      use_cassette "eth_get_transaction_by_block_number_and_index" do
        result = HttpClient.eth_get_transaction_by_block_number_and_index("earliest", "0x0")

        {:ok, nil} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_transaction_receipt/2" do
    test "returns the receipt of a transaction by transaction hash" do
      use_cassette "eth_get_transaction_receipt" do
        result =
          HttpClient.eth_get_transaction_receipt(
            "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"
          )

        {:ok, nil} = result
      end
    end
  end

  # @tag :eth
  # describe "HttpClient.eth_get_uncle_by_block_hash_and_index/3" do
  #   test "returns information about a uncle of a block by hash and uncle index position" do
  #     result =
  #       HttpClient.eth_get_uncle_by_block_hash_and_index(
  #         "0xc6ef2fc5426d6ad6fd9e2a26abeab0aa2411b7ab17f30a99d3cb96aed1d1055b",
  #         "0x0"
  #       )
  #
  #     {:ok, nil} = result
  #   end
  # end
  #
  # @tag :eth
  # describe "HttpClient.eth_get_uncle_by_block_number_and_index/3" do
  #   test "returns information about a uncle of a block by number and uncle index position" do
  #     result = HttpClient.eth_get_uncle_by_block_number_and_index("0x29c", "0x0")
  #
  #     {:ok, _} = result
  #   end
  # end

  # @tag :eth_compile
  # describe "HttpClient.eth_get_compilers/1" do
  #   test "returns a list of available compilers in the client" do
  #     result = HttpClient.eth_get_compilers()
  #
  #     {:ok, _} = result
  #   end
  # end

  @tag :eth
  describe "HttpClient.eth_new_filter/2" do
    test "creates a filter object" do
      use_cassette "eth_new_filter" do
        filter = %{
          fromBlock: "0x1",
          toBlock: "0x2",
          address: "0x8888f1f195afa192cfee860698584c030f4c9db1",
          topics: [
            "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b",
            nil,
            [
              "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b",
              "0x0000000000000000000000000aff3454fce5edbc8cca8697c15331677e6ebccc"
            ]
          ]
        }

        result = HttpClient.eth_new_filter(filter)

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_new_12" do
    test "creates a filter object" do
      use_cassette "eth_new_12" do
        filter = %{
          fromBlock: "0x1",
          toBlock: "0x2",
          address: "0x8888f1f195afa192cfee860698584c030f4c9db1",
          topics: [
            "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b",
            nil,
            [
              "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b",
              "0x0000000000000000000000000aff3454fce5edbc8cca8697c15331677e6ebccc"
            ]
          ]
        }

        result = HttpClient.eth_new_filter(filter)

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_new_block_filter/1" do
    test "creates new block filter" do
      use_cassette "eth_new_block_filter" do
        result = HttpClient.eth_new_block_filter()

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_new_pending_transaction_filter/1" do
    test "creates new pending transaction filter" do
      use_cassette "eth_new_pending_transaction_filter" do
        result = HttpClient.eth_new_pending_transaction_filter()

        {:ok, <<_::binary>>} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_uninstall_filter/2" do
    test "uninstalls a filter with given id" do
      use_cassette "eth_uninstall_filter" do
        {:ok, result} = HttpClient.eth_uninstall_filter("0xb")

        assert is_boolean(result)
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_filter_changes/2" do
    test "returns an array of logs which occurred since last poll" do
      use_cassette "eth_get_filter_changes" do
        result = HttpClient.eth_get_filter_changes("0x68087cc0282c35d9ad8b51bf6a35a933")

        {:ok, []} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_filter_logs/2" do
    test "returns an array of all logs matching filter with given id" do
      use_cassette "eth_get_filter_logs" do
        result = HttpClient.eth_get_filter_logs("0x2a98c5f40bfa3dee83431103c535f6fae9a8ad38")

        # {:ok, []} = result
        {:ok, [%{"address" => "0x2a98c5f40bfa3dee83431103c535f6fae9a8ad38", "blockHash" => "0x4f9e6d252ff3b89c89257e450e3ee6d39e63df930cd90a24f02b6715a3a78923", "blockNumber" => "0x668b4", "data" => "0x45544855534400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", "logIndex" => "0x0", "removed" => false, "topics" => ["0x5a690ecd0cb15c1c1fd6b6f8a32df0d4f56cb41a54fea7e94020f013595de796", "0x0000000000000000000000000000000000000000000000000000000000000002", "0x0000000000000000000000002f9e4311a159c12e4cf13b36f09dca9b007ee319", "0x0000000000000000000000000000000000000000000000000000000000000000"], "transactionHash" => "0xf51d8dae1e7b08b497bed633936301dcee3c34b6b667f5de0dd85795f1f491e7", "transactionIndex" => "0x0"}, %{"address" => "0x2a98c5f40bfa3dee83431103c535f6fae9a8ad38", "blockHash" => "0x4f9e6d252ff3b89c89257e450e3ee6d39e63df930cd90a24f02b6715a3a78923", "blockNumber" => "0x668b4", "data" => "0x000000000000000000000000000000000000000000000000925d699715e6e000", "logIndex" => "0x1", "removed" => false, "topics" => ["0xa9c6cbc4bd352a6940479f6d802a1001550581858b310d7f68f7bea51218cda6", "0x4554485553440000000000000000000000000000000000000000000000000000"], "transactionHash" => "0xf51d8dae1e7b08b497bed633936301dcee3c34b6b667f5de0dd85795f1f491e7", "transactionIndex" => "0x0"}, %{"address" => "0x2f9e4311a159c12e4cf13b36f09dca9b007ee319", "blockHash" => "0x4f9e6d252ff3b89c89257e450e3ee6d39e63df930cd90a24f02b6715a3a78923", "blockNumber" => "0x668b4", "data" => "0x00000000000000000000000000000000000000000000000092459a281c9e0000", "logIndex" => "0x2", "removed" => false, "topics" => ["0xa609f6bd4ad0b4f419ddad4ac9f0d02c2b9295c5e6891469055cf73c2b568fff", "0x0000000000000000000000002f9e4311a159c12e4cf13b36f09dca9b007ee319"], "transactionHash" => "0xf51d8dae1e7b08b497bed633936301dcee3c34b6b667f5de0dd85795f1f491e7", "transactionIndex" => "0x0"}]} = result
      end
    end
  end

  @tag :eth
  describe "HttpClient.eth_get_logs/2" do
    test "returns an array of all logs matching a given filter object" do
      use_cassette "eth_get_logs" do
        filter = %{
          topics: ["0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b"]
        }

        result = HttpClient.eth_get_logs(filter)

        {:ok, []} = result
      end
    end
  end

  @tag :eth_mine
  describe "HttpClient.eth_submit_work/4" do
    test "validates solution" do
      use_cassette "eth_submit_work" do
        result =
            HttpClient.eth_submit_work(
            "0x0000000000000001",
            "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
            "0xD1FE5700000000000000000000000000D1FE5700000000000000000000000000"
          )

        {:ok, false} = result
      end
    end
  end

  @tag :eth_mine
  describe "HttpClient.eth_get_work/1" do
    test "returns the hash of the current block, the seedHash, and the boundary condition to be met " do
      use_cassette "eth_get_work" do
        result = HttpClient.eth_get_work()
      {:ok, [<<_::binary>>, <<_::binary>>, <<_::binary>>]} = result
      end
    end
  end

  @tag :eth_mine
  describe "HttpClient.eth_submit_hashrate/3" do
    test "submits mining hashrate" do
      use_cassette "eth_submit_hashrate" do
        result =
          HttpClient.eth_submit_hashrate(
            "0x0000000000000000000000000000000000000000000000000000000000500000",
            "0x59daa26581d0acd1fce254fb7e85952f4c09d0915afd33d3886cd914bc7d283c"
          )

        {:ok, true} = result
      end
    end
  end

  # db methods removed, see https://github.com/ethereum/go-ethereum/issues/311
  # @tag :eth_db
  # describe "HttpClient.db_put_string/4" do
  #   test "stores a string in the local database" do
  #     result = HttpClient.db_put_string("testDB", "myKey", "myString")
  #
  #     {:ok, true} = result
  #   end
  # end
  #
  # @tag :eth_db
  # describe "HttpClient.db_get_string/3" do
  #   test "returns string from the local database" do
  #     result = HttpClient.db_get_string("db", "key")
  #
  #     {:ok, nil} = result
  #   end
  # end
  #
  # @tag :eth_db
  # describe "HttpClient.db_put_hex/4" do
  #   test "stores binary data in the local database" do
  #     result = HttpClient.db_put_hex("db", "key", "data")
  #
  #     {:ok, true} = result
  #   end
  # end
  #
  # @tag :eth_db
  # describe "HttpClient.db_get_hex/3" do
  #   test "returns binary data from the local database" do
  #     result = HttpClient.db_get_hex("db", "key")
  #
  #     {:ok, nil} = result
  #   end
  # end

  # @tag :shh
  # describe "HttpClient.shh_post/2" do
  #   test "sends a whisper message" do
  #     whisper = %{
  #       from:
  #         "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1",
  #       to:
  #         "0x3e245533f97284d442460f2998cd41858798ddf04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a0d4d661997d3940272b717b1",
  #       topics: [
  #         "0x776869737065722d636861742d636c69656e74",
  #         "0x4d5a695276454c39425154466b61693532"
  #       ],
  #       payload: "0x7b2274797065223a226d6",
  #       priority: "0x64",
  #       ttl: "0x64"
  #     }
  #
  #     result = HttpClient.shh_post(whisper)
  #
  #     {:ok, true} = result
  #   end
  # end
  #
  # @tag :shh
  # describe "HttpClient.shh_version/1" do
  #   test "returns the current whisper protocol version" do
  #     result = HttpClient.shh_version()
  #
  #     {:ok, <<_::binary>>} = result
  #   end
  # end
  #
  # @tag :shh
  # describe "HttpClient.shh_new_identity/1" do
  #   test "creates new whisper identity in the client" do
  #     result = HttpClient.shh_new_identity()
  #
  #     {:ok, <<_::binary>>} = result
  #   end
  # end
  #
  # @tag :shh
  # describe "HttpClient.shh_has_entity/2" do
  #   test "creates new whisper identity in the client" do
  #     result =
  #       HttpClient.shh_has_identity(
  #         "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1"
  #       )
  #
  #     {:ok, false} = result
  #   end
  # end

  # @tag :shh
  # describe "HttpClient.shh_add_to_group/2" do
  #   test "adds address to group" do
  #     result =
  #       HttpClient.shh_add_to_group(
  #         "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1"
  #       )
  #
  #     {:ok, false} = result
  #   end
  # end
  #
  # @tag :shh
  # describe "HttpClient.shh_new_group/1" do
  #   test "creates new group" do
  #     result = HttpClient.shh_new_group()
  #
  #     {:ok, <<_::binary>>} = result
  #   end
  # end

  # @tag :shh
  # describe "HttpClient.shh_new_message_filter/2" do
  #   test "creates filter to notify, when client receives whisper message matching the filter options" do
  #     filter_options = %{
  #       topics: ['0x12341234bf4b564f'],
  #       to:
  #         "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1"
  #     }
  #
  #     result = HttpClient.shh_new_message_filter(filter_options)
  #
  #     {:ok, <<_::binary>>} = result
  #   end
  # end
  #
  # @tag :shh
  # describe "HttpClient.shh_uninstall_filter/2" do
  #   test "uninstalls a filter with given id" do
  #     result = HttpClient.shh_uninstall_filter("0x7")
  #
  #     {:ok, false} = result
  #   end
  # end
  #
  # @tag :shh
  # describe "HttpClient.shh_get_filter_changes/2" do
  #   test "polls filter chages" do
  #     result = HttpClient.shh_get_filter_changes("0x7")
  #
  #     {:ok, []} = result
  #   end
  # end
  #
  # @tag :shh
  # describe "HttpClient.shh_get_messages/2" do
  #   test "returns all messages matching a filter" do
  #     result = HttpClient.shh_get_messages("0x7")
  #
  #     {:ok, []} = result
  #   end
  # end

  @tag :batch
  describe "HttpClient.batch_request/1" do
    test "sends batch request" do
      use_cassette "batch_request" do
        requests = [
          {:web3_client_version, []},
          {:net_version, []},
          {:web3_sha3, ["0x68656c6c6f20776f726c64"]}
        ]

        result = HttpClient.batch_request(requests)

        {
          :ok,
          [
            <<_::binary>>,
            <<_::binary>>,
            "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"
          ]
        } = result
      end
    end
  end
end
