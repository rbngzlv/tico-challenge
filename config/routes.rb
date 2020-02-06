# frozen_string_literal: true

require "api_constraints"

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resource :profile, only: [:show, :update], controller: :profile
      resources :platforms, only: [:show, :update], param: :kind, constraints: ->(req) { Platform::TYPES.include?(req.params[:kind]) }
    end
  end
end
