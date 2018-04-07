ENV['TOKEN'] = "RealToken"

require 'rails_helper'

RSpec.describe Reservation, type: :request do
  after(:each) do
    DatabaseCleaner.clean_with(:truncation)
  end

  let(:invalid_token) { { "token" => "FakeToken" } }
  let(:valid_token) { { "token" => "RealToken" } }
  let(:valid_attributes) {
     {
       "server" => "QA01",
       "reserver" => "FREE",
       "purpose" => "none"
     }
   }
   let(:invalid_server) {
     {
       "token" => "RealToken",
       "text" => "InvalidServer"
     }
   }
   let(:invalid_purpose) {
     {
       "token" => "RealToken",
       "text" => "QA01"
     }
   }
   let(:valid_reservation) {
     {
       "token" => "RealToken",
       "text" => "QA01 WEB-123 new feature"
     }
   }
   let(:valid_unreservation) {
     {
       "token" => "RealToken",
       "text" => "QA01"
     }
   }

###################################################################
  describe 'POST #show' do
    context 'an invalid token' do
      it 'blocks unauthorized users' do
        post '/servers/reservations', params: invalid_token
        json = JSON.parse(response.body)

        expect(json['status']).to eq(401)
        expect(json['text']).to eq('Could not validate token.')
      end
    end

    context 'a valid token' do
      it 'returns a reservations summary' do
        server = Reservation.create! valid_attributes

        post '/servers/reservations', params: valid_token
        json = JSON.parse(response.body)

        expect(json['status']).to eq(200)
        expect(json['text']).to eq('QA01 is free!')
      end
    end
  end

####################################################################
  describe "POST #reserve" do
    context 'an invalid token' do
      it 'blocks unauthorized users' do
        post '/servers/reserve', params: invalid_token
        json = JSON.parse(response.body)

        expect(json['status']).to eq(401)
        expect(json['text']).to eq('Could not validate token.')
      end
    end

    context 'a set of valid inputs' do
      it 'reserves a server' do
        server = Reservation.create! valid_attributes

        post '/servers/reserve', params: valid_reservation
        json = JSON.parse(response.body)

        expect(json['status']).to eq(200)
        expect(json['text']).to eq("You have reserved QA01 (WEB-123 new feature).")
      end
    end

    context 'an invalid server' do
      it 'returns an error message' do
        server = Reservation.create! valid_attributes

        post '/servers/reserve', params: invalid_server
        json = JSON.parse(response.body)

        expect(json['status']).to eq(200)
        expect(json['text']).to eq('The InvalidServer server does not exist.')
      end
    end

    context 'an invalid purpose' do
      it 'returns an error message' do
        server = Reservation.create! valid_attributes

        post '/servers/reserve', params: invalid_purpose
        json = JSON.parse(response.body)

        expect(json['status']).to eq(200)
        expect(json['text']).to eq("Please provide a purpose for this reservation.\nA valid example would be: `/reserve QA01 WEB-199 admin events page`")
      end
    end

    context 'an already reserved server' do
      it 'returns an error message' do
        server = Reservation.create! valid_attributes

        post '/servers/reserve', params: valid_reservation
        post '/servers/reserve', params: valid_reservation
        json = JSON.parse(response.body)

        expect(json['status']).to eq(200)
        expect(json['text']).to eq('The QA01 server is already reserved.')
      end
    end
  end


##################################################

  describe "POST #unreserve" do
    context 'an invalid token' do
      it 'blocks unauthorized users' do
        post '/servers/unreserve', params: invalid_token
        json = JSON.parse(response.body)

        expect(json['status']).to eq(401)
        expect(json['text']).to eq('Could not validate token.')
      end
    end

    context 'a set of valid inputs' do
      it 'unreserves a server' do
        server = Reservation.create! valid_attributes

        post '/servers/reserve', params: valid_reservation
        post '/servers/unreserve', params: valid_unreservation
        json = JSON.parse(response.body)

        expect(json['status']).to eq(200)
        expect(json['text']).to eq("You have unreserved QA01.")
      end
    end

    context 'an invalid server' do
      it 'returns an error message' do
        server = Reservation.create! valid_attributes

        post '/servers/unreserve', params: invalid_server
        json = JSON.parse(response.body)

        expect(json['status']).to eq(200)
        expect(json['text']).to eq('The InvalidServer server does not exist.')
      end
    end

    context 'an already unreserved server' do
      it 'returns an error message' do
        server = Reservation.create! valid_attributes

        post '/servers/unreserve', params: valid_unreservation
        json = JSON.parse(response.body)

        expect(json['status']).to eq(200)
        expect(json['text']).to eq('The QA01 server is already unreserved.')
      end
    end
  end
end
