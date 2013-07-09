module Sentry
  #
  # Bind actual method to current context (thus hiding it from being called) and define method such that it wraps the binding and
  # only calls the bound method if the expectations are met.
  # Can define multiple sentries on same method, but order is important. Define sentries in the order
  # you want them to execute.
  #
  def sentry_on(method_name, opts)
    # Define sentry method for checking expectations
    define_method(:expectations_met?) do |expectations|
      expectations.each do |expectation|
        return false unless self.send(expectation).present?
      end
    end

    # Hide guarded method and define new method
    eval "#{protected_method_name(method_name)} = self.instance_method(method_name)
          define_method(method_name) do
            if expectations_met? #{opts[:expect]}
              #{protected_method_name(method_name)}.bind(self).call
            else
              #{opts[:if_not]}
            end
          end"
  end

  protected
  def protected_method_name(target_method_name)
    "guarded_#{target_method_name.to_s}"
  end
end
