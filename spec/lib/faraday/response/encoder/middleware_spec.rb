require "spec_helper"

describe Faraday::Response::Encoder do
  let(:connection) do
    Faraday.new do |builder|
      builder.response :encoder, { source: source, encoding: encoding, replace: replace,
        text_only: text_only, if: if_block }
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/sample'){ [200, {"Content-Type" => content_type }, body] }
      end
    end
  end

  let(:source){ "UTF-8" }
  let(:encoding){ "EUC-JP" }
  let(:replace){ "" }
  let(:text_only){ true }
  let(:if_block){ ->(env){ env[:url].to_s =~ /sample/ } }

  let(:content_type){ "text/html; charset=UTF-8" }
  let(:body){ "\xff" }

  it do
    expect(connection.get("/sample").body.encoding.to_s).to eq "EUC-JP"
  end
  
  it do
    expect(connection.get("/sample").body).to be_empty
  end

  describe "encoding" do
    context "SJIS" do
      let(:encoding){ "SJIS" }

      it do
        expect(connection.get("/sample").body.encoding.to_s).to eq "Windows-31J"
      end

      it do
        expect(connection.get("/sample").body).to be_empty
      end
    end

    context "empty" do
      let(:encoding){ nil }

      it do
        expect(connection.get("/sample").body.encoding.to_s).to eq source
      end

      it do
        expect(connection.get("/sample").body).to be_empty
      end
    end
  end

  describe "replace" do
    context "???" do
      let(:replace){ "???" }

      it do
        expect(connection.get("/sample").body).to eq replace
      end
    end

  end

  describe "text_only" do
    context "false" do
      let(:text_only){ false }

      context "text" do
        it do
          expect(connection.get("/sample").body).to eq replace
        end
      end

      context "binary" do
        let(:content_type){ "image/jpeg" }

        it do
          expect(connection.get("/sample").body).to eq replace
        end
      end
    end

    context "true" do
      let(:text_only){ true }

      context "text" do
        it do
          expect(connection.get("/sample").body).to eq replace
        end
      end

      context "binary" do
        let(:content_type){ "image/jpeg" }

        it do
          expect(connection.get("/sample").body).to eq body
        end
      end
    end
  end

  describe "if" do
    context "none" do
      let(:if_block){ false }
      
      it do
        expect(connection.get("/sample").body).to be_empty
      end

      it do
        expect(connection.get("/sample").body.encoding.to_s).to eq encoding
      end
    end

    context "false" do
      let(:if_block){ ->(env){ env[:url].to_s == "" } }
      
      it do
        expect(connection.get("/sample").body).to eq body
      end

      it do
        expect(connection.get("/sample").body.encoding.to_s).to eq source
      end
    end
  end
end
