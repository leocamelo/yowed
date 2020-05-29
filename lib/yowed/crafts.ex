defmodule Yowed.Crafts do
  @moduledoc """
  The Crafts context.
  """

  use Yowed, :context

  alias Yowed.Accounts.User
  alias Yowed.Crafts.Project

  @doc """
  Returns the list of projects by user.

  ## Examples

      iex> list_projects(user)
      [%Project{}, ...]

  """
  def list_projects(%User{} = user) do
    Repo.all(from p in Project, where: p.user_id == ^user.id, order_by: p.inserted_at)
  end

  @doc """
  Gets a single project by user and id.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(user, 123)
      %Project{}

      iex> get_project!(user, 456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(%User{} = user, id) do
    Repo.get_by!(Project, user_id: user.id, id: id)
  end

  @doc """
  Creates a project by user.

  ## Examples

      iex> create_project(user, %{field: value})
      {:ok, %Project{}}

      iex> create_project(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(%User{} = user, attrs \\ %{}) do
    %Project{user_id: user.id}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end
end
