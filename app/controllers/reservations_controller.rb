class ReservationsController < ApplicationController
  def setup
    Reservation.create(server: "beta", reserver: "FREE", purpose: "none")
    Reservation.create(server: "rails5", reserver: "FREE", purpose: "none")
    Reservation.create(server: "integration01", reserver: "FREE", purpose: "none")
    Reservation.create(server: "api-integration", reserver: "FREE", purpose: "none")
    Reservation.create(server: "QA01", reserver: "FREE", purpose: "none")
    Reservation.create(server: "QA02", reserver: "FREE", purpose: "none")
    Reservation.create(server: "QA03", reserver: "FREE", purpose: "none")
    Reservation.create(server: "staging", reserver: "FREE", purpose: "none")
  end

  def cleanup
    Reservation.delete_all
  end

  def show
    if params[:token] != ENV['TOKEN']
      render json: { status: 401, text: 'Could not validate token.' }
      return
    end

    res_list = ""
    Reservation.all.each do |reservation|
      res_list << "\n#{reservation.server} is "
      if reservation.reserver == "FREE"
        res_list << "free!"
      else
        res_list << "currently reserved by `<@#{reservation.reserver}>` (#{reservation.purpose})"
      end
    end
    res_list.slice!(0)

    render json: { status: 200, response_type: "in_channel", text: res_list }
  end

  def reserve
    if params[:token] != ENV['TOKEN']
      render json: { status: 401, text: 'Could not validate token.' }
      return
    end

    input_text = params[:text].split(' ')
    desired_server = input_text[0]
    desired_purpose = input_text[1..-1].join(' ')
    current_res = Reservation.where(server: desired_server).take

    if current_res.nil?
      response = "ephemeral"
      message_text = "The #{desired_server} server does not exist."
    elsif current_res.reserver != "FREE"
      response = "ephemeral"
      message_text = "The #{desired_server} server is already reserved."
    elsif desired_purpose == ""
      response = "ephemeral"
      message_text = "Please provide a purpose for this reservation."
      message_text << "\nA valid example would be: `/reserve QA01 WEB-199 admin events page`"
    else
      response = "in_channel"
      current_res.reserver = params[:user_id]
      current_res.purpose = desired_purpose
      current_res.save
      message_text = "You have reserved #{desired_server} (#{desired_purpose})."
    end

    render json: { status: 200, response_type: response, text: message_text }
  end

  def unreserve
    if params[:token] != ENV['TOKEN']
      render json: { status: 401, text: 'Could not validate token.' }
      return
    end

    current_res = Reservation.where(server: params[:text]).take

    if current_res.nil?
      response = "ephemeral"
      message_text = "The #{params[:text]} server does not exist."
    elsif current_res.reserver == "FREE"
      response = "ephemeral"
      message_text = "The #{params[:text]} server is already unreserved."
    else
      response = "in_channel"
      current_res.reserver = "FREE"
      current_res.purpose = "none"
      current_res.save
      message_text = "You have unreserved #{params[:text]}."
    end

    render json: { status: 200, response_type: response, text: message_text }
  end
end
