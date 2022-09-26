defmodule RauversionExtension do

  def user_schema, do: Application.get_env(:rauversion_extension, :user_schema, Rauversion.Accounts.User)

end
