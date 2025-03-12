defmodule BudgieWeb.BudgetShowLive do
  use BudgieWeb, :live_view

  alias Budgie.Tracking

  def mount(%{"budget_id" => id}, _session, socket) when is_uuid(id) do
    # Get the budget from the database
    # and preload the creator
    # If the budget is not found, redirect to the budgets page
    # If the budget is found, assign it to the socket and render the page
    budget =
      Tracking.get_budget(id,
        user: socket.assigns.current_user,
        preload: [:creator]
      )

    if budget do
      {:ok, assign(socket, budget: budget)}
    else
      socket =
        socket
        |> put_flash(:error, "Budget not found")
        |> redirect(to: ~p"/budgets")

      {:ok, socket}
    end
  end

  def mount(_invalid_id, _session, socket) do
    socket =
      socket
      |> put_flash(:error, "Budget not found")
      |> redirect(to: ~p"/budgets")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    {@budget.name} by {@budget.creator.name}
    """
  end
end
