class Faraday::Response::Scrub
  class Middleware < Faraday::Response::Middleware
    Faraday.register_middleware :response, scrub: self

    def initialize(app, opts = {})
      super(app)
      @opts = opts
    end

    def call(env)
      @app.call(env).on_complete do
        p text_only?
        if text?(env)
          env[:body] = env[:body].force_encoding(@opts[:encoding] || "UTF-8")
            .scrub(@opts[:replace] || "")
        else
          unless text_only?
            env[:body] = env[:body].force_encoding(@opts[:encoding] || "UTF-8")
              .scrub(@opts[:replace] || "")
          end
        end
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
