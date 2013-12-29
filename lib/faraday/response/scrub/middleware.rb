class Faraday::Response::Scrub
  class Middleware < Faraday::Response::Middleware
    Faraday.register_middleware :response, scrub: self

    def initialize(app, opts = {})
      super(app)
      @opts = opts
    end

    def call(env)
      @app.call(env).on_complete do
        return if text?(env) and text_only?
        org_encoding = env[:body].encoding
        env[:body].force_encoding(@opts[:encoding] || "UTF-8")
          .scrub!(@opts[:replace] || "").encode(org_encoding).encode(@opts[:encoding] || "UTF-8")
      end
    end

    private

    def text?(env)
      env[:response_headers]["content-type"].split(";").first.split("/").first == "text"
    end

    def text_only?
      !(@opts[:text_only] == false)
    end
  end
end
