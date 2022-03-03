defmodule Spirit.AuthTest do
  use Spirit.DataCase

  alias Spirit.Auth

  describe "tokens" do
  end

  describe "challenges" do
    alias Spirit.Auth.Challenge

    import Spirit.AuthFixtures

    @invalid_attrs %{pubkey: nil, message: nil}

    test "list_challenges/0 returns all challenges" do
      challenge = challenge_fixture()
      assert Auth.list_challenges() == [challenge]
    end

    test "get_challenge!/1 returns the challenge with given id" do
      challenge = challenge_fixture()
      assert Auth.get_challenge!(challenge.id) == challenge
    end

    test "create_challenge/1 with valid data creates a challenge" do
      pubkey = unique_challenge_pubkey()
      message = unique_challenge_message()

      valid_attrs = %{
        pubkey: pubkey,
        message: message
      }

      assert {:ok, %Challenge{} = challenge} = Auth.create_challenge(valid_attrs)
      assert challenge.pubkey == pubkey
      assert challenge.message == message
    end

    test "create_challenge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_challenge(@invalid_attrs)
    end

    test "update_challenge/2 with valid data updates the challenge" do
      challenge = challenge_fixture()
      pubkey = unique_challenge_pubkey()
      message = unique_challenge_message()

      update_attrs = %{
        pubkey: pubkey,
        message: message
      }

      assert {:ok, %Challenge{} = challenge} =
               Auth.update_challenge(challenge, update_attrs)
      assert challenge.pubkey == pubkey
      assert challenge.message == message
    end

    test "update_challenge/2 with invalid data returns error changeset" do
      challenge = challenge_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Auth.update_challenge(challenge, @invalid_attrs)

      assert challenge == Auth.get_challenge!(challenge.id)
    end

    test "delete_challenge/1 deletes the challenge" do
      challenge = challenge_fixture()
      assert {:ok, %Challenge{}} = Auth.delete_challenge(challenge)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_challenge!(challenge.id) end
    end

    test "change_challenge/1 returns a challenge changeset" do
      challenge = challenge_fixture()
      assert %Ecto.Changeset{} = Auth.change_challenge(challenge)
    end
  end
end
