
class PaleoKetoCli::Scraper
    attr_accessor :path, :recipe
  
    BASE_PATH = "https://www.veganricha.com/"
  
    def scrape_main
      begin
        file = open(@path)
        doc = Nokogiri::HTML(file).css("article")
      rescue
        puts "Cannot open URL!"
      end
    end
  
    def create_recipes
      self.scrape_main.each do |node|
        name = node.css(".entry-title").text
        link = node.css("a.entry-title-link").attr("href").value
        recipe = PaleoKetoCli::Recipe.new(name, link)
      end unless 
      self.scrape_main.nil?
      !PaleoKetoCli::Recipe.all.empty?
    end
  
    def add_description
      self.recipe.description = self.scrape_description
    end
  
    def scrape_description
      begin
        file = open(self.recipe.link)
        Nokogiri::HTML(file).css(".wprm-recipe-container").css(".wprm-recipe-summary").css("span").text
      rescue
        puts "Cannot open URL!"
      end
    end
  
    def add_ingredients
      doc = self.scrape_ingredients
        doc.css(".wprm-recipe-ingredient").each do |i|
          ingredient = {}
          ingredient[:amount] = i.css(".wprm-recipe-ingredient-amount").text
          ingredient[:unit] = i.css(".wprm-recipe-ingredient-unit").text
          ingredient[:name] = i.css(".wprm-recipe-ingredient-name").text
          ingredient[:notes] = i.css(".wprm-recipe-ingredient-notes").text
          self.recipe.ingredients << ingredient
        end
    end
  
    def make_path(month)
     BASE_PATH + month
    end
  
    def self.create_by_month(month = "2019/02")
      scrape = self.new
      scrape.path = scrape.make_path(month)
      scrape
    end
  
    def self.scrape_by_recipe(recipe)
      scrape = self.new
      scrape.recipe = recipe
      scrape
    end
  
    def scrape_ingredients
      begin
        file = open(self.recipe.link)
        Nokogiri::HTML(file).css(".wprm-recipe-container")
      rescue
        puts "Cannot open URL!"
      end
    end
  
   
  
  end
  