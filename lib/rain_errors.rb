module RainErrors

  class StackAlreadyExistsError < StandardError
  end

  class StackActionNotSupportedError < StandardError
  end

  class NoUpdatesToStackError < StandardError
  end

end