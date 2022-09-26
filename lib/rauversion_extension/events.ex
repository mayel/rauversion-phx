defmodule Rauversion.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  import RauversionExtension

  alias Rauversion.Events.Event

  @doc """
  Returns the list of event.

  ## Examples

      iex> list_event()
      [%Event{}, ...]

  """
  def list_event do
    repo().all(Event)
  end

  def all_events do
    repo().all(Event)
  end

  def list_events(state \\ "published") when is_binary(state) do
    from(pi in Event,
      where: pi.state == ^state,
      preload: [:category, user: :avatar_blob]
    )

    # |> repo().all()
  end

  def list_events(query, state) do
    query
    |> where([p], p.state == ^state)
    |> preload(user: :avatar_blob)

    # |> repo().all()
  end

  def list_events(user = %{}) do
    user
    |> Ecto.assoc(:events)
    |> preload(user: :avatar_blob)

    # |> repo().all()
  end

  def list_tickets(event) do
    from(a in Rauversion.Events.Event,
      where: a.id == ^event.id,
      join: t in Rauversion.EventTickets.EventTicket,
      on: a.id == t.event_id,
      join: pt in Rauversion.PurchasedTickets.PurchasedTicket,
      on: t.id == pt.event_ticket_id,
      # group_by: [pt.id],
      limit: 10,
      select: pt
      # order_by: [desc: count(t.id)],
      # preload: [
      #  :user
      # ]
    )
    |> repo().all()
    |> repo().preload([:user, :event_ticket])
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: repo().get!(Event, id)
  def get_by_slug!(id), do: repo().get_by!(Event, slug: id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> repo().insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Event.process_one_upload(attrs, "cover")
    |> repo().update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    repo().delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def new_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
  end

  def event_dates(struct) do
    case Cldr.Interval.to_string(struct.event_start, struct.event_ends, Rauversion.Cldr) do
      {:ok, d} ->
        d

      e ->
        struct.event_start
    end
  end

  def simple_date_for(date) do
    case Cldr.DateTime.to_string(date, format: :ed) do
      {:ok, d} -> d
      _ -> date
    end
  end

  def country_name(name) do
    case Countries.filter_by(:alpha2, name) do
      [%{name: country_name} | _] -> country_name
      _ -> name
    end
  end
end
