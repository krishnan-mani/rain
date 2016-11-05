module PrintModule

  def self.print_metadata(hsh)
    hsh.collect { |k, v|
      v.is_a?(Hash) ? "#{k}: #{print_metadata(v)}" : "#{k}: #{v}"
    }.join("\n")
  end

end