class Api::CountriesController < ApplicationController
  def states
    country = Country.find(params[:id])
    states = country.states.active.order(:name)

    render json: states.map { |state| { id: state.id, name: state.name } }
  rescue ActiveRecord::RecordNotFound
    render json: [], status: :not_found
  end
end
