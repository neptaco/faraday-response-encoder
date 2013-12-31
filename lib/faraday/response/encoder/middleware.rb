class Faraday::Response::Encoder
  class Middleware < Faraday::Response::Middleware
    Faraday.register_middleware :response, encoder: self

    def initialize(app, opts = {})
      super(app)
      @opts = opts
    end

    def call(env)
      @env = env
      @app.call(env).on_complete do
        if !@opts[:if] or @opts[:if].call(@env)
          if text?
            env[:body] = encode!
          else
            env[:body] = encode! unless text_only?
          end
        end
      end
    end

    private

    def encode!
      @env[:body].encode(to, from,
                         :invalid => :replace, :undef => :replace, :replace => replace)
    end

    def from
      @opts[:from] || guess || "UTF-8"
    end

    def to
      @opts[:to] || "UTF-8"
    end

    def replace
      @opts[:replace] || ""
    end

    def text?
      content_type.split(";").first.split("/").first == "text"
    end

    def text_only?
      !(@opts[:text_only] == false)
    end

    def guess
      content_type = content_type.split(";")
      if content_type.size > 1
        return $1.strip if content_type.last.strip =~ /charset=(.+)/
      end
    end

    def content_type
      @env[:response_headers]["content-type"]
    end
  end
end
