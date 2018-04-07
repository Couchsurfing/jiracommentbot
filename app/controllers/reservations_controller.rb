class ReservationsController < ApplicationController
  def setup
    setup = Reservation.create(server: "QA01", reserver: "FREE")
    setup = Reservation.create(server: "QA02", reserver: "FREE")
    setup = Reservation.create(server: "QA03", reserver: "FREE")
    setup = Reservation.create(server: "QA04", reserver: "FREE")
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
    current_res = Reservation.where(server: desired_server).take

    if current_res.nil?
      message_text = "The #{desired_server} server does not exist."
    elsif current_res.reserver != "FREE"
      message_text = "The #{desired_server} server is already reserved."
    else
      current_res.reserver = params[:user_id]
      current_res.save
      message_text = "You have reserved #{desired_server}."
    end

    render json: { status: 200, response_type: "in_channel", text: message_text }
  end

  def unreserve
    if params[:token] != ENV['TOKEN']
      render json: { status: 401, text: 'Could not validate token.' }
      return
    end

    current_res = Reservation.where(server: params[:text]).take

    if current_res.nil?
      message_text = "The #{params[:text]} server does not exist."
    elsif current_res.reserver == "FREE"
      message_text = "The #{params[:text]} server is already unreserved."
    else
      current_res.reserver = "FREE"
      current_res.save
      message_text = "You have unreserved #{params[:text]}."
    end

    render json: { status: 200, response_type: "in_channel", text: message_text }
  end
end
