# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :set_reservation, except: %i[new index create free_slots]

  def index
    @reservations = ReservedSlot.order(start_at: :desc).all
  end

  def new; end

  def create
    @reservation = ReservedSlot.new(reservation_params)
    if @reservation.save
      flash[:notice] = 'Reservation successfully created'
      turbo_request? ? redirect_to(action: :index) : render(inline: '')
    else
      flash[:error] = @reservation.errors.full_messages.join(', ')
      render_turbo_content { render inline: '' }
    end
  end

  def free_slots
    @slots = SlotsGenerator.call(Date.parse(params[:date]), params[:duration].to_i)
    @reservation = ReservedSlot.new
    if request.format == 'application/json'
      render json: @slots
    else
      render_turbo_content(skip_flash: true) { render }
    end
  end

  def destroy
    @reservation.destroy!
    flash[:notice] = 'Reservation destroyed successfully'
    redirect_to url_for(action: :index)
  end

  private

  def set_reservation
    @reservation = ReservedSlot.find(params[:id])
  end

  def reservation_params
    {
      start_at: params[:start_at],
      end_at: Time.zone.parse(params[:start_at]) + params[:duration].to_i.minutes
    }
  end
end
