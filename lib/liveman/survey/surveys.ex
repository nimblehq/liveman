defmodule Liveman.Survey.Surveys do
  use Ecto.Schema

  alias Liveman.Survey.Schemas.{Survey, Question}

  @survey_json "priv/repo/data/surveys.json"

  def list_surveys do
    survey_list_json = get_json(@survey_json)

    Enum.map(survey_list_json, fn survey_json ->
      survey = build_survey(survey_json)
      questions = build_question(survey_json["questions"], survey)

      survey
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_embed(:questions, questions)
      |> Ecto.Changeset.apply_changes()
    end)
  end

  defp get_json(filename) do
    with {:ok, body} <- File.read(filename), {:ok, json} <- Jason.decode!(body), do: {:ok, json}
  end

  defp build_survey(json) do
    %Survey{
      id: json["id"],
      title: json["title"],
      description: json["description"],
      thank_email_above_threshold: json["thank_email_above_threshold"],
      thank_email_below_threshold: json["thank_email_below_threshold"],
      is_active: json["is_active"],
      cover_image_url: json["cover_image_url"],
      created_at: json["created_at"],
      active_at: json["active_at"],
      inactive_at: json["inactive_at"],
      type: json["type"]
    }
  end

  def build_question(question_json, survey) do
    Enum.map(question_json, fn question ->
      %Question{
        id: question["id"],
        survey_id: survey.id,
        text: question["text"],
        help_text: question["help_text"],
        display_order: question["display_order"],
        short_text: question["short_text"],
        pick: question["pick"],
        display_type: question["display_type"],
        is_mandatory: question["is_mandatory"],
        correct_answer_id: question["correct_answer_id"],
        facebook_profile: question["facebook_profile"],
        twitter_profile: question["twitter_profile"],
        image_url: question["image_url"],
        cover_image_url: question["cover_image_url"],
        cover_image_opacity: question["cover_image_opacity"],
        cover_background_color: question["cover_background_color"],
        is_shareable_on_facebook: question["is_shareable_on_facebook"],
        is_shareable_on_twitter: question["is_shareable_on_twitter"],
        font_face: question["font_face"],
        font_size: question["font_size"],
        tag_list: question["tag_list"]
      }
    end)
  end
end
