module ApplicationHelper
  def generate_data_set_values(dataset)
    result = "["
    dataset.each do |data|
      result += "{value: \"#{data["id"]}\","
      result += "label: \"#{data["name"]}\"},"
    end
    result = result.chomp(",")
    result += "]"
    result
  end
end
