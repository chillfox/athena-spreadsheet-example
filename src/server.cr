require "athena"
require "ecr"

class ART::Request
  def request : HTTP::Request
    @request
  end
end

class IndexController < ART::Controller
  @[ARTA::Get("/")]
  def index : ART::Response
    view = ECR.render "src/index.ecr"
    html = ECR.render "src/layout.ecr"
    ART::Response.new html, headers: HTTP::Headers{"content-type" => MIME.from_extension(".html")}
  end
end

class AssetController < ART::Controller
  @[ARTA::Get("/assets/main.js")]
  def mainjs : ART::Response
    js = {{ `cat #{__DIR__}/../dist/main.js`.stringify }}
    ART::Response.new js, headers: HTTP::Headers{"content-type" => MIME.from_extension(".js")}
  end
end

class TableController < ART::Controller
  @[ARTA::Get("/new")]
  def index : ART::Response
    view = ECR.render "src/create_table.ecr"
    html = ECR.render "src/layout.ecr"
    ART::Response.new html, headers: HTTP::Headers{"content-type" => MIME.from_extension(".html")}
  end

  @[ARTA::Post("/new")]
  def create_table(request : ART::Request) : ART::Response
    raise ART::Exceptions::BadRequest.new "Request body is empty." unless request.body

    name = nil
    table_head = [] of String
    table_data = [] of Array(String)
    HTTP::FormData.parse(request.request) do |part|
      case part.name
      when "name"
        name = part.body.gets_to_end
      when "table_head"
        table_head << part.body.gets_to_end
      when /R\d+C\d+/
        if match = part.name.match(/R(?<row>\d+)C\d+/)
          row = match["row"].to_i
          if table_data[row - 1]?
            table_data[row - 1] << part.body.gets_to_end
          else
            table_data << [part.body.gets_to_end]
          end
        end
      end
    end

    raise ART::Exceptions::BadRequest.new "Missing table name" unless name
    raise ART::Exceptions::BadRequest.new "Missing table head" unless table_head
    raise ART::Exceptions::BadRequest.new "Missing table data" unless table_data

    view = ECR.render "src/show_table.ecr"
    html = ECR.render "src/layout.ecr"
    ART::Response.new html, headers: HTTP::Headers{"content-type" => MIME.from_extension(".html")}
  end
end

ART.run
