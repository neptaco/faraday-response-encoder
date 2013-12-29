require "spec_helper"

describe Faraday::Response::Scrub do
  let(:connection) do
    Faraday.new do |builder|
      builder.response :scrub, encoding: encoding, replace: replace, text_only: text_only
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/sample'){ [200, {"Content-Type" => "aplication/json"}, test_srtings] }
      end
    end
  end

  let(:test_srtings){ "\xff" }
  # default
  let(:encoding){ "UTF-8" }
  let(:replace){ "" }
  let(:text_only){ false }

  describe "encoding" do
    context "default" do
      let(:encoding){ nil }
      
      it do
        expect(connection.get("/sample").body.encoding.to_s).to eq "UTF-8"
      end
    end

    %w(UTF-8 EUC-JP Windows-31J).each do |encoding_name|
      context encoding_name do
        let(:encoding){ encoding_name }

        it do
          expect(connection.get("/sample").body.encoding.to_s).to eq encoding_name
        end
      end
    end

  end

  describe "replace" do
    context "default" do
      let(:replace){ nil }

      it do
        expect(connection.get("/sample").body).to eq ""
      end
    end

    context "blank" do
      let(:replace){ "" }

      it do
        expect(connection.get("/sample").body).to eq replace
      end
    end

    context "?" do
      let(:replace){ "?" }

      it do
        expect(connection.get("/sample").body).to eq replace
      end
    end
  end

  describe "text_only" do
    context "default" do
      let(:text_only){ nil }
      it do
        expect(connection.get("/sample").body).to eq test_srtings
      end
    end

    context "true" do
      let(:text_only){ true }
      it do
        expect(connection.get("/sample").body).to eq test_srtings
      end
    end

    context "false" do
      let(:text_only){ false }
      it do
        expect(connection.get("/sample").body).to eq replace
      end
    end
  end
end
