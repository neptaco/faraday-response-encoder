class Faraday::Response::Scrub
  class Middleware < Faraday::Response::Middleware
    Faraday.register_middleware :response, scrub: self

    def initialize(app, opts = {})
      super(app)
      @opts = opts
    end

    def call(env)
      @app.call(env).on_complete do
        if text?(env)
          env[:body] = scrub(env)
        else
          env[:body] = scrub(env) unless text_only?
        end
      end
    end

    private

    def scrub(env)
      env[:body].force_encoding(@opts[:encoding] || "UTF-8").scrub(@opts[:replace] || "")      
    end

    def text?(env)
      env[:response_headers]["content-type"].split(";").first.split("/").first == "text"
    end

    def text_only?
      !(@opts[:text_only] == false)
    end

    def guess
      
    end
  end
end
