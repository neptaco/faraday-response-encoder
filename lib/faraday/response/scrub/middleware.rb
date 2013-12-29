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

    def encoding(env)
      @opts[:encoding] || guess(env) || "UTF-8"
    end

    def scrub(env)
      env[:body].force_encoding(encoding(env)).scrub(@opts[:replace] || "")      
    end

    def text?(env)
      content_type(env).split(";").first.split("/").first == "text"
    end

    def text_only?
      !(@opts[:text_only] == false)
    end

    def guess(env)
      content_type = content_type(env).split(";")
      if content_type.size > 1
        return $1.strip if content_type.last.strip =~ /charset=(.+)/
      end
    end

    def content_type(env)
      env[:response_headers]["content-type"]
    end
  end
end
