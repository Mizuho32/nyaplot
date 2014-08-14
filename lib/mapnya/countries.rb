module Nyaplot
  class Countries
    class << self
      path = File.expand_path("../datasets/countries/countries.json", __FILE__)
      file = File.read(path)
      df = Nyaplot::DataFrame.new(JSON.parse(file))

      # pre-process
      lat = []; lng = []
      df.column(:latlng).each do |latlng|
        lat.push(latlng[0])
        lng.push(latlng[1])
      end
      df.insert_column(:lat, lat)
      df.insert_column(:lng, lng)
      df.delete_column(:latlng)

      df.filter! {|row| !(row[:lat].nil? || row[:lng].nil? || row[:cca3] == "ATA")}
      df.each_row {|row| row[:area]=0 if row[:area]<0}
      @@df = df

      def countries_list
        @@df[:name].to_a
      end

      def cca3_list
        @@df[:cca3].to_a
      end

      def df
        @@df
      end
    end
  end
end
