defmodule Yowed.Crafts do
  @moduledoc """
  The Crafts context.
  """

  use Yowed, :context

  alias Yowed.Accounts.User
  alias Yowed.Crafts.{Project, Template}

  @doc """
  Returns the list of projects by user.

  ## Examples

      iex> list_projects(user)
      [%Project{}, ...]

  """
  def list_projects(%User{} = user) do
    Repo.all(
      from p in Project,
        select: [:id, :name],
        where: p.user_id == ^user.id,
        order_by: p.inserted_at
    )
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

  @doc """
  Returns the list of templates by project.

  ## Examples

      iex> list_templates(project)
      [%Template{}, ...]

  """
  def list_templates(%Project{} = project) do
    Repo.all(
      from t in Template,
        select: [:id, :name],
        where: t.project_id == ^project.id,
        order_by: t.inserted_at
    )
  end

  @doc """
  Gets a single template by project and id.

  Raises `Ecto.NoResultsError` if the Template does not exist.

  ## Examples

      iex> get_template!(project, 123)
      %Template{}

      iex> get_template!(project, 456)
      ** (Ecto.NoResultsError)

  """
  def get_template!(%Project{} = project, id) do
    Repo.get_by!(Template, project_id: project.id, id: id)
  end

  @doc """
  Creates a template.

  ## Examples

      iex> create_template(project, %{field: value})
      {:ok, %Template{}}

      iex> create_template(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_template(%Project{} = project, attrs \\ %{}) do
    %Template{project_id: project.id}
    |> Template.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a template.

  ## Examples

      iex> update_template(template, %{field: new_value})
      {:ok, %Template{}}

      iex> update_template(template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_template(%Template{} = template, attrs) do
    template
    |> Template.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a template.

  ## Examples

      iex> delete_template(template)
      {:ok, %Template{}}

      iex> delete_template(template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_template(%Template{} = template) do
    Repo.delete(template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking template changes.

  ## Examples

      iex> change_template(template)
      %Ecto.Changeset{data: %Template{}}

  """
  def change_template(%Template{} = template, attrs \\ %{}) do
    Template.changeset(template, attrs)
  end
end
