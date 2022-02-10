defmodule Spirit.AuthTest do
  use Spirit.DataCase

  alias Spirit.Auth

  describe "tokens" do
    alias Spirit.Auth.Token

    import Spirit.AuthFixtures

    @invalid_attrs %{}

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Auth.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Auth.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      valid_attrs = %{}

      assert {:ok, %Token{} = token} = Auth.create_token(valid_attrs)
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      update_attrs = %{}

      assert {:ok, %Token{} = token} = Auth.update_token(token, update_attrs)
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_token(token, @invalid_attrs)
      assert token == Auth.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Auth.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Auth.change_token(token)
    end
  end

  describe "challenges" do
    alias Spirit.Auth.Challenge

    import Spirit.AuthFixtures

    @invalid_attrs %{}

    test "list_challenges/0 returns all challenges" do
      challenge = challenge_fixture()
      assert Auth.list_challenges() == [challenge]
    end

    test "get_challenge!/1 returns the challenge with given id" do
      challenge = challenge_fixture()
      assert Auth.get_challenge!(challenge.id) == challenge
    end

    test "create_challenge/1 with valid data creates a challenge" do
      valid_attrs = %{}

      assert {:ok, %Challenge{} = challenge} = Auth.create_challenge(valid_attrs)
    end

    test "create_challenge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_challenge(@invalid_attrs)
    end

    test "update_challenge/2 with valid data updates the challenge" do
      challenge = challenge_fixture()
      update_attrs = %{}

      assert {:ok, %Challenge{} = challenge} =
               Auth.update_challenge(challenge, update_attrs)
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
