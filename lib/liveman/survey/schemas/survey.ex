defmodule Liveman.Survey.Schemas.Survey do
  use Ecto.Schema
  import Ecto.Changeset

  alias Liveman.Survey.Schemas.Question

  @primary_key {:id, :string, autogenerate: false}
  embedded_schema do
    field(:access_code_prompt, :string)
    field(:access_code_validation, :string)
    field(:active_at, :naive_datetime)
    field(:cover_background_color, :string)
    field(:cover_image_url, :string)
    field(:default_language, :string)
    field(:description, :string)
    field(:footer_content, :string)
    field(:inactive_at, :naive_datetime)
    field(:is_access_code_required, :boolean, default: false)
    field(:is_access_code_valid_required, :boolean, default: false)
    field(:is_active, :boolean, default: false)
    field(:language_list, {:array, :string})
    field(:short_url, :string)
    field(:survey_version, :integer)
    field(:tag_list, :string)
    field(:thank_email_above_threshold, :string)
    field(:thank_email_below_threshold, :string)
    field(:title, :string)
    field(:type, :string)
    field(:theme, :string)

    embeds_many(:questions, Question)

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [
      :title,
      :description,
      :access_code_prompt,
      :thank_email_above_threshold,
      :thank_email_below_threshold,
      :footer_content,
      :cover_background_color,
      :type,
      :is_active,
      :cover_image_url,
      :created_at,
      :active_at,
      :inactive_at,
      :survey_version,
      :short_url,
      :language_list,
      :default_language,
      :tag_list,
      :is_access_code_required,
      :is_access_code_valid_required,
      :access_code_validation,
      :theme
    ])
    |> cast_embed(:questions)
    |> validate_required([
      :title,
      :description,
      :type,
      :created_at
    ])
  end
end
