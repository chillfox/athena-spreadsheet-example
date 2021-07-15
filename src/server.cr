require "athena"
require "ecr"

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
  @[ARTA::RequestParam("name")]
  @[ARTA::RequestParam("table_head")]
  def create_table(name : String, table_head : Array(String)) : ART::Response

    table_data = [["", "", ""], ["", "", ""], ["", "", ""]]

    view = ECR.render "src/show_table.ecr"
    html = ECR.render "src/layout.ecr"
    ART::Response.new html, headers: HTTP::Headers{"content-type" => MIME.from_extension(".html")}
  end
end

ART.run
