# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :set_reservation, except: %i[index new create free_slots]

  def index
    @reservations = ReservedSlot.order(start_at: :desc).all
  end

  def create
    @reservation = ReservedSlot.new(start_at: Time.parse(params[:start_at]).in_current_zone)
    @reservation.end_at = @reservation.start_at + params[:duration].to_i.minutes
    if @reservation.save
      flash[:notice] = 'Reservation successfully created'
      redirect_to action: :index
    else
      flash[:error] = @reservation.errors.full_messages.join(', ')
      render_turbo_content { render inline: '' }
    end
  end

  def free_slots
    @slots = SlotsGenerator.call(Date.parse(params[:date]), params[:duration].to_i)
    @reservation = ReservedSlot.new
    render_turbo_content { render }
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
end
