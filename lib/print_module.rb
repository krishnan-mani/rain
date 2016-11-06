module PrintModule

  def self.print_metadata(hsh)
    hsh.collect { |k, v|
      v.is_a?(Hash) ? "#{k}: #{print_metadata(v)}" : "#{k}: #{v}"
    }.join("\n")
  end

  def self.print_stack_description(stack_description_response)
    [
        "Name: #{stack_description_response.stack_name}",
        "Status: #{stack_description_response.stack_status}"
    ].join("\n")
  end

end